
import tensorflow as tf
from Simulated_Annealing import *
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import *
from sklearn.model_selection import train_test_split
from keras import backend as K
import os
import pickle

print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))


def shuffle_and_divide_dataset(images, labels, num_of_clients):
    ''' gets arrays of images and labels, shuffle them and reshape them to
     number of clients X number of images in each client X image shape'''
    perm = np.random.permutation(len(images))
    images = images[perm]
    labels = labels[perm]
    client_data_len = len(images)//num_of_clients
    clients_images = images.reshape((num_of_clients, client_data_len, *images.shape[1:]))
    clients_labels = labels.reshape((num_of_clients, client_data_len, *labels.shape[1:]))
    return clients_images, clients_labels


def show_img(img):
    ''' plot the image '''
    plt.figure()
    plt.imshow(img)
    plt.show()


def make_clients(clients_images, clients_labels, num_of_clients):
    ''' gets arrays that each tensor in the first dimension represent the imges/clients of each client, and returns
     a list of Client objects with the images and labels inside each client'''
    all_clients = [0]*num_of_clients
    for i in range(num_of_clients):
        all_clients[i] = Client(i, 10000, 10000, clients_images[i], clients_labels[i], 0)
    return all_clients


def train_selection(global_model, local_model, clients_lst, selection_size, clients_dists, cs_ucb=False):
    ''' execute the FL stages of "model distribute", model local update, "model upload" and model aggregation.
    recieve: global_model = the Global model,
    local_model = replica of the global model for local update
    clients_lst = list of the clients in the selection
    clients_expected_times = list of the cliets expected iter times in the selection '''
    starting_weights = global_model.get_weights()
    new_weights = np.array(starting_weights)*0
    iter_time = 0
    for i in range(selection_size):
        local_model.set_weights(starting_weights)
        train_client(local_model, clients_lst[i])
        new_weights += np.array(local_model.get_weights())
        time = min([1, max([0.05, clients_dists[i][0] + np.random.randn() * clients_dists[i][1]])])
        clients_lst[i].update_u_noo(time, cs_ucb)
        if time > iter_time:
            iter_time = time
    global_model.set_weights(new_weights/selection_size)
    return iter_time


def train_client(local_model, client):
    ''' train the local model with specific client on its local data'''
    c_train_images, c_validate_images, c_train_labels, c_validate_labels = train_test_split(client.data, client.labels, test_size=0.2, random_state=42)
    local_model.fit(
        c_train_images, c_train_labels,
        batch_size= 32,
        epochs=1,
        verbose=1,
        validation_data=(c_validate_images, c_validate_labels)
    )


def update_clients_ucb_g(client_lst, t, selection_size, num_of_clients, iid = True):
    ''' update each client's UCB and g function from the client_lst '''
    for client in client_lst:
        client.update_ucb_g(t, selection_size, num_of_clients, iid)


def BSFL(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
         test_labels, total_time=None, alpha = 3, iid=True, t=0):
    ''' execute the FL training process under the BSFL algorithm of client selection.
    recieve: global_model, local_model - initialized models with same architecture and optimizer,
            all clients - list of all clients,
            all_clients_dists - list of 2d tuples - client's (mean, variance) of  iteration latency,
            total time - the total amount of latency that the process should take,
            alpha - the generalization factor for reward calculation,
            t - iteration number, ...
    return: time - list of the time passed when evaluationg the global model,
            loss - list of the losses when evaluationg the global model,
            acc - list of the accuracies when evaluationg the global model,
            list of number of iterations each client participate in the training.'''
    if not total_time:
        total_time = num_of_clients // selection_size + 30

    time_left = total_time
    time = []
    loss = []
    accuracy = []
    last_eval_time = time_left+3

    tmp_t=t

    # Initializing
    for t in range(num_of_clients // selection_size):  # RR for 1 epoch
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in np.arange(t * selection_size,
                                                               (t + 1) * selection_size)], selection_size,
                                [all_clients_dists[j] for j in np.arange(t * selection_size, (t + 1) * selection_size)])
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            # loss.append(np.average(tf.keras.losses.categorical_crossentropy(test_labels, preds_test).numpy()))
            # accuracy.append(np.average(tf.keras.metrics.categorical_accuracy(test_labels, preds_test).numpy()))
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time-time_left)
            print("\n\nglobal model in iteration", t, " with ",time_left," time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

    t += 1
    if num_of_clients % selection_size != 0:  # last RR selection in case of num_of_clients % selection_size != 0
        start = t * selection_size
        end = (start + selection_size) % num_of_clients
        idxes = np.concatenate((np.arange(start, num_of_clients), np.arange(0, end)))
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                        [all_clients_dists[j] for j in idxes])
        time_left -= iter_time

        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time-time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")
        t += 1

    t = tmp_t + int(np.ceil(num_of_clients/selection_size))
    update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients, iid)
    # main loop
    while time_left > 0:
        # selection training
        print("u_time:", [client.u_time for client in all_clients])  # for check
        print("ucb extra:", [(client.ucb - client.u_time) for client in all_clients])  # for check
        print("ucb:", [client.ucb for client in all_clients])  # for check
        print("g:", [client.g/0.1 for client in all_clients])  # for check
        print("num of observations:", [client.num_of_observations for client in all_clients])  # for check
        selection_idxes = simulated_annealing_B(all_clients, num_of_clients, selection_size, iters=1000,
                                                return_idxes=True, alpha=alpha, save_max=True)
        if selection_size <= 2:
            idxes = find_max_energy(all_clients, selection_size, alpha)
            if selection_idxes != idxes:
                print("\n\nsimulated_annealing didnt find the best energy!\n\n")
                selection_idxes = idxes

        print("chosen clients:", selection_idxes)
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size,
                                    [all_clients_dists[j] for j in selection_idxes])
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time-time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients, iid)

    return time, loss, accuracy, [client.num_of_observations for client in all_clients]


def cs_ucb(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
           test_labels, total_time=None, optimal_genie = False, t=0):
    ''' execute the FL training process under the cs-ucb algorithm (for the case where the data is iid and balanced) of client selection.
        recieve: global_model, local_model - initialized models with same architecture and optimizer,
                all clients - list of all clients,
                all_clients_dists - list of 2d tuples - client's (mean, variance) of  iteration latency,
                total time - the total amount of latency that the process should take,
                t - iteration number, ...
        return: time - list of the time passed when evaluationg the global model,
                loss - list of the losses when evaluationg the global model,
                acc - list of the accuracies when evaluationg the global model,
                list of number of iterations each client participate in the training.'''
    if not total_time:
        total_time = num_of_clients // selection_size + 30

    time_left = total_time
    time = []
    loss = []
    accuracy = []
    last_eval_time = time_left+3
    tmp_t = t
    optimal_genie_idxes = np.argsort([expect for expect, var in all_clients_dists])[:selection_size]
    if not optimal_genie:
        # Initializing
        for t in range(num_of_clients // selection_size):  # RR for 1 epoch
            iter_time = train_selection(global_model, local_model, [all_clients[j] for j in np.arange(t * selection_size,
                         (t + 1) * selection_size)], selection_size, [all_clients_dists[j] for j in np.arange(t *
                          selection_size, (t + 1) * selection_size)], cs_ucb=True)
            time_left -= iter_time
            # global model evaluation
            #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
            if last_eval_time > time_left + 2:
                last_eval_time = time_left
                preds_test = global_model.predict(test_images)
                loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
                accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
                time.append(total_time-time_left)
                print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

        t += 1
        if num_of_clients % selection_size != 0:    # last RR selection in case of num_of_clients % selection_size != 0
            start = t * selection_size
            end = (start + selection_size) % num_of_clients
            idxes = np.concatenate((np.arange(start, num_of_clients), np.arange(0, end)))
            iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                            [all_clients_dists[j] for j in idxes], cs_ucb=True)
            time_left -= iter_time
            # global model evaluation
            #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
            if last_eval_time > time_left + 2:
                last_eval_time = time_left
                preds_test = global_model.predict(test_images)
                loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
                accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
                time.append(total_time-time_left)
                print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")
            t += 1
        t = tmp_t + int(np.ceil(num_of_clients / selection_size))
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients)

    elif optimal_genie and t == 0:
        t = 1

    # main loop
    while time_left > 0:
        # selection training
        if optimal_genie:
            selection_idxes = optimal_genie_idxes
        else:
            print("ucb:", [client.ucb for client in all_clients])  # for check
            sorted_ucbs = sorted(all_clients, key=lambda client: client.ucb, reverse=True)
            selection_idxes = [client.num for client in sorted_ucbs[:selection_size]]
        print("chosen clients:", selection_idxes)
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size,
                                    [all_clients_dists[j] for j in selection_idxes], cs_ucb=True)
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time-time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients)
    return time, loss, accuracy,  [client.num_of_observations for client in all_clients]


def RR_train(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
             test_labels, total_time=None, t=0):
    ''' execute the FL training process under the Round-Robin algorithm of client selection.
        recieve: global_model, local_model - initialized models with same architecture and optimizer,
                all clients - list of all clients,
                all_clients_dists - list of 2d tuples - client's (mean, variance) of  iteration latency,
                total time - the total amount of latency that the process should take,
                t - iteration number, ...
        return: time - list of the time passed when evaluationg the global model,
                loss - list of the losses when evaluationg the global model,
                acc - list of the accuracies when evaluationg the global model,
                list of number of iterations each client participate in the training.'''
    if not total_time:
        total_time = num_of_clients // selection_size + 30

    start = 0
    end = selection_size
    time_left = total_time
    time = []
    loss = []
    accuracy = []
    last_eval_time = time_left+3
    while time_left > 0:
        # selection ttraining
        if end > num_of_clients:
            end = end % num_of_clients
            idxes = np.concatenate((np.arange(start, num_of_clients), np.arange(0, end)))
        else:
            idxes = np.arange(start, end)
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                                    [all_clients_dists[j] for j in idxes])
        time_left -= iter_time
        start = end
        end += selection_size

        # global model evaluation
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients)
    return time, loss, accuracy


def Random_selection_train(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
                           test_labels, total_time=None, iid=True, t=0):
    ''' execute the FL training process under the random selection (proportional to the client's dataset size) of client selection.
            recieve: global_model, local_model - initialized models with same architecture and optimizer,
                    all clients - list of all clients,
                    all_clients_dists - list of 2d tuples - client's (mean, variance) of  iteration latency,
                    total time - the total amount of latency that the process should take,
                    t - iteration number, ...
            return: time - list of the time passed when evaluationg the global model,
                    loss - list of the losses when evaluationg the global model,
                    acc - list of the accuracies when evaluationg the global model,
                    list of number of iterations each client participate in the training.'''
    if not total_time:
        total_time = num_of_clients // selection_size + 30

    time_left = total_time
    time = []
    loss = []
    accuracy = []
    last_eval_time = time_left+3
    while time_left > 0:
        # selection training
        if iid:
            idxes = np.random.choice(num_of_clients,selection_size,replace=False)
        else:
            all_clients_size = np.array([client.data_size for client in all_clients])
            idxes = np.random.choice(num_of_clients, selection_size, replace=False, p=all_clients_size/np.sum(all_clients_size))
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                                    [all_clients_dists[j] for j in idxes])
        time_left -= iter_time

        # global model evaluation
        #t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

        #update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients)
    return time, loss, accuracy


def cs_ucb_q(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
           test_labels, total_time=None, t=1):
    ''' execute the FL training process under the cs-ucb-q (for the case where the data is not iid and imbalanced) algorithm of client selection.
            recieve: global_model, local_model - initialized models with same architecture and optimizer,
                    all clients - list of all clients,
                    all_clients_dists - list of 2d tuples - client's (mean, variance) of  iteration latency,
                    total time - the total amount of latency that the process should take,
                    t - iteration number, ...
            return: time - list of the time passed when evaluationg the global model,
                    loss - list of the losses when evaluationg the global model,
                    acc - list of the accuracies when evaluationg the global model,
                    list of number of iterations each client participate in the training.'''
    if not total_time:
        total_time = num_of_clients // selection_size + 30

    time_left = total_time
    time = []
    loss = []
    accuracy = []
    phi = 0.5
    total_data_size = sum([client.data_size for client in all_clients])
    min_data_size = min([client.data_size for client in all_clients])
    cmin = phi * selection_size * min_data_size / total_data_size
    c = [client.data_size / min_data_size * cmin for client in all_clients]     # fairness constrained for each client
    D = np.zeros((num_of_clients))
    y_gag = np.zeros((num_of_clients))
    b = np.zeros((num_of_clients))
    beta = 0.5
    last_eval_time = time_left+3
    # main loop
    while time_left > 0:
        for client in all_clients:
            if client.num_of_observations>0:
                y_gag[client.num] = min(1, client.ucb)
            else:
                y_gag[client.num] = 1
            D[client.num] = max(D[client.num]+c[client.num]-b[client.num], 0)

        sorted_clients = sorted(all_clients, key=lambda client:(1-beta)*y_gag[client.num]+beta*D[client.num], reverse=True)
        selection_idxes = [client.num for client in sorted_clients[:selection_size]]
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size, [all_clients_dists[j] for j in selection_idxes], cs_ucb=True)
        b = np.zeros((num_of_clients))
        b[selection_idxes] = 1
        time_left -= iter_time
        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t, selection_size=1, num_of_clients=num_of_clients)
        # global model evaluation
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_images)
            loss.append(np.average(tf.keras.losses.sparse_categorical_crossentropy(test_labels, preds_test).numpy()))
            accuracy.append(np.average(tf.keras.metrics.sparse_categorical_accuracy(test_labels, preds_test).numpy()))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1], "\naccuracy: ", accuracy[-1], "\n\n")

    return time, loss, accuracy, [client.num_of_observations for client in all_clients]


def find_max_energy(all_clients, selection_size, alpha=3):
    ''' finding the selection that maximize the selection criterion iff the selection size is at most 2 clients (if the
     selection size is bigger returns None)'''
    energy_lst = [client.ucb + alpha / 0.1 * client.g for client in all_clients]
    max1idx = np.argmax(energy_lst)
    if selection_size == 1:
        return [max1idx]
    elif selection_size == 2:
        max2idx = np.argmax(energy_lst[:max1idx]+energy_lst[max1idx+1:])
        if max2idx>=max1idx:
            max2idx += 1
        return [max1idx, max2idx]
    return None


def save_loss_acc(time, loss, accuracy, name, dir_name):
    ''' saving the loss_list, accuracy-_list and the times_list in "dir_name" directory'''
    with open(dir_name+'/'+name+'_loss', 'wb') as fp:
        pickle.dump(loss, fp)
    with open(dir_name+'/'+name+'_accuracy', 'wb') as fp:
        pickle.dump(accuracy, fp)
    with open(dir_name+'/'+name+'_time', 'wb') as fp:
        pickle.dump(time, fp)
    plt.figure(0)
    plt.plot(time, loss, label=name)
    plt.figure(1)
    plt.plot(time, accuracy, label=name)


def init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=0, cs_ucb=False):
    ''' initialize the clients attributes in all_clients list according to the selection rule'''
    if t==0:
        for client in all_clients:
            client.ucb = 100000
            client.g = 0
            client.num_of_observations = 0
    else:
        for client in all_clients:
            if cs_ucb:
                client.u_time = 1 - all_clients_dists[client.num][0]
            else:
                client.u_time = 1 / all_clients_dists[client.num][0]

            client.num_of_observations = t*selection_size//num_of_clients
            client.update_ucb_g(t, selection_size, num_of_clients)


def selection_policies_compare(global_model,local_model, train_images, train_labels, test_images,
                test_labels, cifar10_OR_fashion_mnist=True, t=0, num_of_clients=500, selection_size=25, time_bulks=15, alpha=50):
    ''' recieving global model and local model, and compare the FL training process under 3 different selection
     policies: BSFL, cs-ucb, Random selection. The training process is done for the scenario where the data is divided
      iid and balanced between the clients and the training is done with the train_images+train_labels and test_images+
      test_labels data.'''
    init_weights = global_model.get_weights()
    clients_images, clients_labels = shuffle_and_divide_dataset(train_images, train_labels, num_of_clients)
    all_clients = make_clients(clients_images, clients_labels, num_of_clients)
    all_clients_dists =np.concatenate((np.random.uniform(low=[0.85, 0], high=[0.9, 0.05], size=(     # TODO change the dists to totally random try diff dits to emphasize our advantage over random selection
    num_of_clients//10, 2)), np.random.uniform(low=[0.05, 0], high=[0.1, 0.05], size=(
    num_of_clients//10*9, 2))))  # distributions N(E,sigma) time after normalization by t_max
    np.random.shuffle(all_clients_dists)                # TODO delete later.. done for enphasize the advantage over RR

    # for i in range(10):
    #     num_c = np.random.randint(num_of_clients)
    #     num_i = np.random.randint(all_clients[num_c].data_size)
    #     plt.imshow(all_clients[num_c].data[num_i], interpolation='nearest')
    #     plt.show()
    #     print(class_names[all_clients[num_c].labels[num_i]])

    dir_name = str(num_of_clients) + '_' + str(selection_size) + '_t=' + str(t) + '_lr=' + str(
        local_model.optimizer.lr.numpy())+ '_alpha='+str(alpha)
    if not cifar10_OR_fashion_mnist:
        dir_name = 'results/cifar10/iid/' + dir_name
    else:
        dir_name = 'results/fashion_mnist/iid/' + dir_name
    os.mkdir(path=dir_name)
    total_time = 1 + num_of_clients // selection_size * time_bulks
    # total_time = 2

    # init_clients(all_clients, all_clients_dists)
    # global_model.set_weights(init_weights)
    # local_model.set_weights(init_weights)
    #
    # time, loss, accuracy = RR_train(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
    #             test_labels, total_time=total_time)
    # save_loss_acc(time, loss, accuracy, 'RR', dir_name)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    time, loss, accuracy = Random_selection_train(global_model, local_model, all_clients, all_clients_dists,
                                                  num_of_clients, selection_size, test_images,
                                                  test_labels, total_time=total_time, t=t)
    save_loss_acc(time, loss, accuracy, 'Random_selection', dir_name)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t, cs_ucb=True)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    time, loss, accuracy, num_of_observations_lst = cs_ucb(global_model, local_model, all_clients,
                                                           all_clients_dists, num_of_clients, selection_size,
                                                           test_images,
                                                           test_labels, total_time=total_time, optimal_genie=False, t=t)
    save_loss_acc(time, loss, accuracy, 'cs_ucb', dir_name)
    with open(dir_name + '/cs_ucb_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    time, loss, accuracy, num_of_observations_lst = BSFL(global_model, local_model, all_clients,
                                                         all_clients_dists, num_of_clients,
                                                         selection_size, test_images, test_labels,
                                                         total_time=total_time, alpha=alpha, t=t)
    save_loss_acc(time, loss, accuracy, 'BSFL', dir_name)
    with open(dir_name + '/BSFL_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    with open(dir_name+'/all_clients_dists', 'wb') as fp:
        pickle.dump(all_clients_dists, fp)

    plt.figure(0)
    plt.legend()
    plt.title("Loss "+dir_name)
    plt.xlabel('latency')
    plt.ylabel('loss')
    plt.savefig(dir_name+'/'+'loss_selections', dpi = 1000)
    plt.figure(1)
    plt.legend()
    plt.title("Acccuracy "+dir_name)
    plt.xlabel('latency')
    plt.ylabel('accuracy')
    plt.savefig(dir_name + '/' + 'acc_selections', dpi=1000)
    plt.show()
    plt.figure(0)
    plt.show()


        # for alpha in [1,10,50]:
        #     init_clients(all_clients)
        #     global_model.set_weights(init_weights)
        #     local_model.set_weights(init_weights)
        #     time, loss, accuracy, num_of_observations_lst = BSFL(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
        #         test_labels, total_time=total_time, alpha=alpha)
        #     save_loss_acc(time, loss, accuracy, 'alpha='+str(alpha), dir_name)
        #     with open('results/' + dir_name + '/alpha='+str(alpha)+'_num_of_observations_lst', 'wb') as fp:
        #         pickle.dump(num_of_observations_lst, fp)
        #
        # plt.figure(0)
        # plt.legend()
        # plt.title("Loss in different alpha sgu_ucb")
        # plt.xlabel('latency')
        # plt.ylabel('loss')
        # plt.savefig('results/' + dir_name + '/' + 'loss_BSFL', dpi=500)
        # plt.figure(1)
        # plt.legend()
        # plt.title("Acccuracy in different alpha sgu_ucb")
        # plt.xlabel('latency')
        # plt.ylabel('accuracy')
        # plt.savefig('results/' + dir_name + '/' + 'acc_BSFL', dpi=500)
        # plt.show()
        # plt.figure(0)
        # plt.show()


def make_clients_non_iid(train_images_sorted, train_labels_sorted, num_of_clients, data_size_gama_teta=1000, class_gama_teta=5):
    ''' receive arrays of images and labels sorted by classes (all the class images together at the first of the array
     and so on..) and returns list of clients with the data divided in a non iid and imbalanced way, i.e. each client
      has different amount of images and classes of the images inside each client distributed not uniformly. '''
    classes_idxes = np.zeros(10, dtype=int)
    all_clients = []
    class_size = len(train_labels_sorted)//10
    for j in range(num_of_clients):

        class_data_size = [max(min(class_size-classes_idxes[k], int(np.random.gamma(1, data_size_gama_teta) / data_size_gama_teta
                * (np.shape(train_labels_sorted)[0]) / num_of_clients//10+1)), 1) for k in range(10)]
        client_data = np.empty([0, *np.shape(train_images_sorted)[1:]], dtype=float)
        client_labels = np.empty([0, *np.shape(train_labels_sorted)[1:]], dtype=float)
        for i in range(10):
            if class_data_size[i] == 1:
                classes_idxes[i] -= 1
            client_data = np.concatenate((client_data, train_images_sorted[(i * class_size + classes_idxes[i]):(
                        i * class_size + classes_idxes[i] + class_data_size[i]), :, :, :]))
            client_labels = np.concatenate((client_labels, train_labels_sorted[
                                                           i * class_size + classes_idxes[i]:i * class_size + classes_idxes[i] +
                                                                                       class_data_size[i]]))

        classes_idxes += class_data_size
        all_clients.append(Client(j, 10000, 10000, client_data, client_labels, 0))

    np.random.shuffle(all_clients)
    for i in range(num_of_clients):
        all_clients[i].num = i
    return all_clients


def non_iid_selection_policies_compare(global_model, local_model, sorted_train_images, sorted_train_labels, test_images, test_labels, cifar10_OR_fashion_mnist=True, t=0, num_of_clients=500, selection_size=25, time_bulks=20, alpha=50):
    ''' recieving global model and local model, and compare the FL training process under 3 different selection
         policies: BSFL, cs-ucb-q, Random selection. The training process is done for the scenario where the data is divided
          non iid and imbalanced between the clients and the training is done with the train_images+train_labels and test_images+
          test_labels data.'''
    init_weights = global_model.get_weights()
    all_clients = make_clients_non_iid(sorted_train_images, sorted_train_labels, num_of_clients)
    all_clients_dists = np.concatenate((np.random.uniform(low=[0.85, 0], high=[0.9, 0.05], size=( # TODO change the dists to totally random try diff dits to emphasize our advantage over random selection
        num_of_clients // 10, 2)), np.random.uniform(low=[0.05, 0], high=[0.1, 0.05], size=(
        num_of_clients // 10 * 9, 2))))  # distributions N(E,sigma) time after normalization by t_max
    np.random.shuffle(all_clients_dists)  # TODO delete later.. done for emphasize the advantage over RR

    dir_name = str(num_of_clients) + '_' + str(selection_size)+'_t='+str(t)+'_lr='+str(local_model.optimizer.lr.numpy())+ '_alpha='+str(alpha)
    if not cifar10_OR_fashion_mnist:
        dir_name = 'results/cifar10/non_iid/'+dir_name
    else:
        dir_name = 'results/fashion_mnist/non_iid/' + dir_name
    os.mkdir(path=dir_name)
    total_time = 1 + num_of_clients // selection_size * time_bulks
    # total_time = 2

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    time, loss, accuracy = Random_selection_train(global_model, local_model, all_clients, all_clients_dists,
                                                  num_of_clients, selection_size, test_images, test_labels,
                                                  total_time=total_time, iid=False, t=t)
    save_loss_acc(time, loss, accuracy, 'Random_selection', dir_name)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    time, loss, accuracy, num_of_observations_lst = cs_ucb_q(global_model, local_model, all_clients, all_clients_dists,
                                                             num_of_clients, selection_size, test_images, test_labels,
                                                             total_time=total_time, t=t)
    save_loss_acc(time, loss, accuracy, 'cs_ucb_q', dir_name)
    with open(dir_name + '/cs_ucb_q_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.set_weights(init_weights)
    local_model.set_weights(init_weights)

    # time, loss, accuracy = RR_train(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
    #             test_labels, total_time=total_time)
    # save_loss_acc(time, loss, accuracy, 'RR', dir_name)
    #
    # init_clients(all_clients)
    # global_model.set_weights(init_weights)
    # local_model.set_weights(init_weights)

    time, loss, accuracy, num_of_observations_lst = BSFL(global_model, local_model, all_clients,
                                                         all_clients_dists, num_of_clients, selection_size,
                                                         test_images, test_labels, total_time=total_time,
                                                         alpha=alpha, t=t)
    save_loss_acc(time, loss, accuracy, 'BSFL', dir_name)
    with open(dir_name + '/BSFL_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    with open(dir_name+'/all_clients_dists', 'wb') as fp:
        pickle.dump(all_clients_dists, fp)
    with open(dir_name+'/all_clients_data_sizes', 'wb') as fp:
        pickle.dump([client.data_size for client in all_clients], fp)

    plt.figure(0)
    plt.legend()
    plt.title("Loss "+dir_name)
    plt.xlabel('latency')
    plt.ylabel('loss')
    plt.savefig(dir_name + '/' + 'loss_selections', dpi=1000)
    plt.figure(1)
    plt.legend()
    plt.title("Accuracy "+dir_name)
    plt.xlabel('latency')
    plt.ylabel('accuracy')
    plt.savefig(dir_name + '/' + 'acc_selections', dpi=1000)
    plt.show()
    plt.figure(0)
    plt.show()

        # for alpha in [1,10,50]:
        #     init_clients(all_clients)
        #     global_model.set_weights(init_weights)
        #     local_model.set_weights(init_weights)
        #     time, loss, accuracy, num_of_observations_lst = BSFL(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_images,
        #         test_labels, total_time=total_time, alpha=alpha)
        #     save_loss_acc(time, loss, accuracy, 'alpha='+str(alpha), dir_name)
        #     with open('results/' + dir_name + '/alpha='+str(alpha)+'_num_of_observations_lst', 'wb') as fp:
        #         pickle.dump(num_of_observations_lst, fp)
        #
        # plt.figure(0)
        # plt.legend()
        # plt.title("Loss in different alpha sgu_ucb")
        # plt.xlabel('latency')
        # plt.ylabel('loss')
        # plt.savefig('results/' + dir_name + '/' + 'loss_BSFL', dpi=500)
        # plt.figure(1)
        # plt.legend()
        # plt.title("Acccuracy in different alpha sgu_ucb")
        # plt.xlabel('latency')
        # plt.ylabel('accuracy')
        # plt.savefig('results/' + dir_name + '/' + 'acc_BSFL', dpi=500)
        # plt.show()
        # plt.figure(0)
        # plt.show()


def run(cifar10_OR_fashion_mnist, iid, t, num_of_clients, selection_size, lr=0.001, time_bulks=15, alpha=50):
    ''' receive variable the selects which dataset the compare will be (Cifar10/Fasion_mnist) and a var that select
     under what scenario the compare will be (with iid/non-iid data), creating a global+local model according to the
      dataset chosen and compare the FL training process for time_bulks amount of time. the FL trining process is done
       where the dataset is divided to num_of_clients number of clients and in each iteration selection_size clients are
        being selected, the results (the loss, accuracy, time of evaluations and comparing graphs of each client
         selection policy is saved to the directory according to the received variables) '''
    if cifar10_OR_fashion_mnist:

        global_model = Sequential()
        global_model.add(Conv2D(32, kernel_size=(3, 3),
                                activation='relu',
                                kernel_initializer='he_normal',
                                input_shape=(28, 28, 1)))
        global_model.add(MaxPooling2D((2, 2)))
        global_model.add(Dropout(0.25))
        global_model.add(Conv2D(64, (3, 3), activation='relu'))
        global_model.add(MaxPooling2D(pool_size=(2, 2)))
        global_model.add(Dropout(0.25))
        global_model.add(Conv2D(128, (3, 3), activation='relu'))
        global_model.add(Dropout(0.4))
        global_model.add(Flatten())
        global_model.add(Dense(128, activation='relu'))
        global_model.add(Dropout(0.3))
        global_model.add(Dense(10, activation='softmax'))
        optimizer = tf.optimizers.Adam(learning_rate=lr)
        global_model.compile(loss='sparse_categorical_crossentropy',
                             optimizer=optimizer,
                             metrics=['accuracy'])
        global_model.summary()

        # local model build
        local_model = tf.keras.models.clone_model(global_model)
        local_model.build((None, (28, 28, 1))) # replace 10 with number of variables in input layer
        # optimizer = tf.optimizers.Adam(learning_rate=0.001)
        # local_model.compile(loss ='sparse_categorical_crossentropy', optimizer=optimize, metrics=['accuracy'])
        # K.set_value(model.optimizer.learning_rate, 0.001)
        local_model.compile(loss ='sparse_categorical_crossentropy', optimizer=optimizer, metrics=['accuracy'])
        local_model.set_weights(global_model.get_weights())
        local_model.summary()

        # # checks:
        # weights = global_model.get_weights()
        # weights_div = np.array(weights) * 0
        # weights = np.array(weights)*1.1
        # local_model.set_weights(weights_div)
        # double_weights = weights+10*weights_div
        # local_model.set_weights(double_weights)

        init_weights = global_model.get_weights()

        class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',
                       'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']
        fashion_mnist = tf.keras.datasets.fashion_mnist
        (train_images, train_labels), (test_images, test_labels) = fashion_mnist.load_data()

        if not iid:
            train_labels_inds = train_labels.argsort()
            train_labels = train_labels[train_labels_inds[::-1]]
            train_images = train_images[train_labels_inds[::-1]]

        train_images = train_images.reshape(*train_images.shape, 1)
        test_images = test_images.reshape(*test_images.shape, 1)

    else:
        # global model build
        global_model = Sequential()
        global_model.add(Conv2D(32, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same',
                                input_shape=(32, 32, 3)))
        global_model.add(Conv2D(32, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same'))
        global_model.add(MaxPooling2D((2, 2)))
        global_model.add(Dropout(0.2))
        global_model.add(Conv2D(64, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same'))
        global_model.add(Conv2D(64, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same'))
        global_model.add(MaxPooling2D((2, 2)))
        global_model.add(Dropout(0.3))
        global_model.add(Conv2D(128, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same'))
        global_model.add(Conv2D(128, (3, 3), activation='relu', kernel_initializer='he_uniform', padding='same'))
        global_model.add(MaxPooling2D((2, 2)))
        global_model.add(Dropout(0.4))
        global_model.add(Flatten())
        global_model.add(Dense(128, activation='relu', kernel_initializer='he_uniform'))
        global_model.add(Dropout(0.5))
        global_model.add(Dense(10, activation='softmax'))
        # compile model
        opt = tf.keras.optimizers.SGD(lr=lr, momentum=0.9)
        global_model.compile(optimizer=opt, loss='sparse_categorical_crossentropy', metrics=['accuracy'])
        global_model.summary()

        # local model build
        local_model = tf.keras.models.clone_model(global_model)
        local_model.build((None, (32, 32, 3)))  # replace 10 with number of variables in input layer
        # optimizer = tf.optimizers.Adam(learning_rate=0.001)
        # local_model.compile(loss ='sparse_categorical_crossentropy', optimizer=optimize, metrics=['accuracy'])
        # K.set_value(model.optimizer.learning_rate, 0.001)
        local_model.compile(loss='sparse_categorical_crossentropy', optimizer=opt, metrics=['accuracy'])
        local_model.set_weights(global_model.get_weights())
        local_model.summary()

        init_weights = global_model.get_weights()

        class_names = ['airplane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck']
        cifar10 = tf.keras.datasets.cifar10
        (train_images, train_labels), (test_images, test_labels) = cifar10.load_data()

        train_labels = train_labels.reshape((len(train_labels),))
        test_labels = test_labels.reshape((len(test_labels),))

        if not iid:
            train_labels_inds = train_labels.argsort()
            train_labels = train_labels[train_labels_inds[::-1]]
            train_images = train_images[train_labels_inds[::-1]]
            # train_labels = train_labels.reshape((len(train_labels), 1))

        # # Transform target variable into one-hot encoding
        # train_labels = tf.keras.utils.to_categorical(train_labels, 10)
        # test_labels = tf.keras.utils.to_categorical(test_labels, 10)

    train_images = train_images / 255.0
    test_images = test_images / 255.0

    if iid:
        selection_policies_compare(global_model, local_model, train_images, train_labels, test_images, test_labels, cifar10_OR_fashion_mnist,t, num_of_clients, selection_size, time_bulks, alpha=alpha)
    else:
        non_iid_selection_policies_compare(global_model, local_model, train_images, train_labels, test_images, test_labels, cifar10_OR_fashion_mnist,t, num_of_clients, selection_size, time_bulks, alpha=alpha)


if __name__ == "__main__":

    run(cifar10_OR_fashion_mnist=False, iid=True, t=0, num_of_clients=500, selection_size=25, lr=0.006, time_bulks=20, alpha=1)     # cifar10_OR_fashion_mnist #cifar10=False, fashion_mnist=True
    run(cifar10_OR_fashion_mnist=False, iid=False, t=0, num_of_clients=500, selection_size=25, lr=0.006, time_bulks=20, alpha=1)     # cifar10_OR_fashion_mnist #cifar10=False, fashion_mnist=True
    run(cifar10_OR_fashion_mnist=True, iid=True, t=0, num_of_clients=500, selection_size=25, lr=0.0015, time_bulks=10, alpha=1)  # cifar10_OR_fashion_mnist #cifar10=False, fashion_mnist=True
    run(cifar10_OR_fashion_mnist=True, iid=False, t=0, num_of_clients=500, selection_size=25, lr=0.0015, time_bulks=10, alpha=1)  # cifar10_OR_fashion_mnist #cifar10=False, fashion_mnist=True


    # run(cifar10_OR_fashion_mnist=True, iid=True, t=0, num_of_clients=100, selection_size=10, lr=0.001,
    #     time_bulks=15)  # cifar10_OR_fashion_mnist #cifar10=False, fashion_mnist=True










