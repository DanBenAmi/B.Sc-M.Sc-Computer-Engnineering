
from Simulated_Annealing import *
import os
import pickle
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from scipy.special import comb


def make_data(num_datapoints=70000, num_features=10, save=False, letter=""):
    ''' Saving data of num_datapoints with num_features on each data point and one
     dimensional prediction to each datapoint '''
    X = np.random.random((num_datapoints, num_features))
    Y = X @ np.array([i/num_features for i in range(num_features)]) + np.ones(num_datapoints) * np.sqrt(2) + np.random.randn(num_datapoints)/2
    data = np.concatenate((X, Y.reshape(len(X),1)), axis=1)
    if save:
        np.savetxt("multi_features_data"+letter+str(num_datapoints)+".csv", data, delimiter=",")
    return data[:num_datapoints//7*6], data[num_datapoints//7*6:]


def make_clients(num_of_clients, train_X, train_Y):
    ''' gets arrays that each vector in the first dimension is the data+label, and returns
     a list of Client objects with the data and labels inside each client'''
    all_clients = [0] * num_of_clients
    num_datapoints = len(train_Y)
    for i in range(num_of_clients):
        all_clients[i] = Client(i, 10000, 10000, train_X[num_datapoints//num_of_clients*i:num_datapoints//num_of_clients*(i+1),:], train_Y[num_datapoints//num_of_clients*i:num_datapoints//num_of_clients*(i+1)], 0)
    return all_clients


def make_clients_non_iid(train_X, train_Y, num_of_clients, data_size_gama_teta=1000):
    ''' receive arrays of data and labels and returns list of clients with the data divided in a non iid way, i.e. each client
          has different amount of data points. '''
    data_idx = 0
    all_clients = []
    for j in range(num_of_clients):
        client_data_size = max(min(np.shape(train_Y)[0]-data_idx-1, int(np.random.gamma(1, data_size_gama_teta) /
                                            data_size_gama_teta * (np.shape(train_Y)[0]) / num_of_clients + 1)), 1)
        client_data = train_X[data_idx:data_idx+client_data_size]
        client_labels = train_Y[data_idx:data_idx+client_data_size]
        all_clients.append(Client(j, 10000, 10000, client_data, client_labels, 0))
        if client_data_size != 1:
            data_idx += client_data_size
        np.random.shuffle(all_clients)
    for j in range(num_of_clients):
        all_clients[j].num = j
    return all_clients


def init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=0, cs_ucb=False):
    ''' initialize the clients in all_clients list '''
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


def train_selection(global_model, local_model, clients_lst, selection_size, clients_dists, num_trainings, cs_ucb=False):
    ''' execute the FL stages of "model distribute", model local update, "model upload" and model aggregation.
    recieve: global_model = the Global model,
    local_model = replica of the global model for local update
    clients_lst = list of the clients in the selection
    clients_expected_times = list of the cliets expected iter times in the selection '''
    new_coef = global_model.coef_ * 0
    new_intercept = 0
    iter_time = 0
    # print("global ", global_model.coef_, global_model.intercept_)
    for i in range(selection_size):
        train_client(local_model, clients_lst[i], global_model.coef_, global_model.intercept_, num_trainings=num_trainings, ideal=False) #TODO check if the local weights chanfe after the function return
        new_coef += local_model.coef_
        new_intercept += local_model.intercept_
        time = min([1, max([0.05, clients_dists[i][0] + np.random.randn() * clients_dists[i][1]])])
        clients_lst[i].update_u_noo(time, cs_ucb)
        if time > iter_time:
            iter_time = time
    global_model.coef_ = (global_model.coef_ * num_trainings + new_coef / selection_size) / (num_trainings+1)
    global_model.intercept_ = (global_model.intercept_ * num_trainings + new_intercept / selection_size) / (num_trainings+1)
    return iter_time


def train_client(local_model, client, theta=0, bias=0, epochs=1, ideal=True, num_trainings=10):
    ''' train the local model with specific client on its local data'''
    if ideal:
        local_model.fit(client.data, client.labels)
    else:
        lr = 0.001 #5/(num_trainings**0.5+100)
        for j in range(epochs):
            Y_pred = client.data @ theta + bias  # The current predicted value of Y subset
            D_theta = (-2 / client.data_size) * (client.labels - Y_pred) @ client.data  # Derivative wrt theta
            D_bias = (-2 / client.data_size) * sum(client.labels - Y_pred)  # Derivative wrt bias
            theta = theta - lr * D_theta  # Update theta
            bias = bias - lr * D_bias  # Update bias
        local_model.coef_ = theta
        local_model.intercept_ = bias


def update_clients_ucb_g(client_lst, t, selection_size, num_of_clients, iid = True, all_data_size=60000):
    ''' update each client's UCB and g function from the client_lst '''
    for client in client_lst:
        client.update_ucb_g(t, selection_size, num_of_clients, iid, all_data_size, beta=2)


def calc_regret(all_clients, all_clients_dists, selection_size, alpha, sel_idxes):
    ''' receives the list of all clients, their distributions, the selection size, the alpha (for the reward
     calculation), and the indexes of a specific selection, finding the maximum energh selection and returning the
      difference between the maxumum energy and the received selection energy- i.e. the immediate regret. '''
    if comb(len(all_clients), selection_size) > 300000:
        print("too complex for calculate the regret")
        exit(1)
    sel_energy = min([1/all_clients_dists[j][0] for j in sel_idxes]) + (alpha / 0.1) * (1 / selection_size) * sum([all_clients[j].g for j in sel_idxes])
    max_energy = -np.inf
    for clients in combinations(all_clients, selection_size):
        clients = list(clients)
        client_nums = [client.num for client in clients]
        sel_rate = min([1/all_clients_dists[j][0] for j in client_nums])
        energy = sel_rate + (alpha / 0.1) * (1 / selection_size) * sum([client.g for client in clients])
        if energy > max_energy:
            max_energy = energy
            best_idxes = client_nums
    print('sel expeced energy: ', sel_energy, "sel idxes =", sel_idxes)
    print('best expeced energy: ', max_energy, "best idxes =", best_idxes)
    return max_energy - sel_energy


def BSFL(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_X, test_Y,
         total_time=1, alpha=50, t=0, iid=True):
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
    time_left = total_time
    time = []
    loss = []
    regret = []
    last_eval_time = time_left+3
    num_trainings = 0
    tmp_t=t

    # Initializing
    for t in range(num_of_clients // selection_size):  # RR for 1 epoch
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, np.arange(t * selection_size,
                                                               (t + 1) * selection_size)))
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in np.arange(t * selection_size,
                                                               (t + 1) * selection_size)], selection_size,
                                [all_clients_dists[j] for j in np.arange(t * selection_size, (t + 1) * selection_size)], num_trainings) #TODO check if the local weights chanfe after the function return
        num_trainings += 1
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time-time_left)
            print("\n\nglobal model in iteration", t, " with ",time_left," time left:\nloss: ", loss[-1], "\nregret: ", regret[-1], "\n\n")

    t += 1
    if num_of_clients % selection_size != 0:  # last RR selection in case of num_of_clients % selection_size != 0
        start = t * selection_size
        end = (start + selection_size) % num_of_clients
        idxes = np.concatenate((np.arange(start, num_of_clients), np.arange(0, end)))
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, idxes))
        iter_time = train_selection(global_model, [all_clients[j] for j in idxes], selection_size,
                        [all_clients_dists[j] for j in idxes], num_trainings)
        num_trainings += 1
        time_left -= iter_time

        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                  "\nregret: ", regret[-1], "\n\n")
        t += 1

    t = tmp_t + int(np.ceil(num_of_clients/selection_size))
    update_clients_ucb_g(all_clients, t, selection_size, num_of_clients, iid, all_data_size=len(train_Y))
    # main loop
    while time_left > 0:
        # selection training
        print("real rate:", [1/dist[0] for dist in all_clients_dists])  # for check
        print("u_time:", [client.u_time for client in all_clients])  # for check
        print("ucb extra:", [(client.ucb - client.u_time) for client in all_clients])  # for check
        print("ucb:", [client.ucb for client in all_clients])  # for check
        print("g:", [client.g for client in all_clients])  # for check
        print("num of observations:", [client.num_of_observations for client in all_clients])  # for check
        selection_idxes = find_max_brute_force(num_of_clients, selection_size, all_clients,
                                                return_idxes=True, alpha=alpha)
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, selection_idxes))
        print("chosen clients:", selection_idxes)
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size,
                                    [all_clients_dists[j] for j in selection_idxes], num_trainings)
        num_trainings += 1
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                  "\nregret: ", regret[-1], "\n\n")

        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t, selection_size, num_of_clients, iid, all_data_size=len(train_Y))

    regret = [sum(regret[:i+1]) for i in range(len(regret))]
    return time, loss, regret, [client.num_of_observations for client in all_clients]


def cs_ucb(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_X,
           test_Y, alpha=50, total_time=None, optimal_genie = False, t=0):
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
    regret = []
    num_trainings = 0
    tmp_t = t
    last_eval_time = time_left+3
    optimal_genie_idxes = np.argsort([expect for expect, var in all_clients_dists])[:selection_size]
    if not optimal_genie:
        # Initializing
        for t in range(num_of_clients // selection_size):  # RR for 1 epoch
            regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, np.arange(t * selection_size,
                                                                                             (t + 1) * selection_size)))
            iter_time = train_selection(global_model, local_model, [all_clients[j] for j in np.arange(t * selection_size,
                         (t + 1) * selection_size)], selection_size, [all_clients_dists[j] for j in np.arange(t *
                          selection_size, (t + 1) * selection_size)],num_trainings, cs_ucb=True)
            num_trainings += 1

            time_left -= iter_time
            # global model evaluation
            #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
            if last_eval_time > time_left + 2:
                last_eval_time = time_left
                preds_test = global_model.predict(test_X)
                loss.append(mean_squared_error(preds_test, test_Y))
                time.append(total_time - time_left)
                print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                      "\nregret: ", regret[-1], "\n\n")
        t += 1
        if num_of_clients % selection_size != 0:    # last RR selection in case of num_of_clients % selection_size != 0
            start = t * selection_size
            end = (start + selection_size) % num_of_clients
            idxes = np.concatenate((np.arange(start, num_of_clients), np.arange(0, end)))
            regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, idxes))
            iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                            [all_clients_dists[j] for j in idxes], num_trainings, cs_ucb=True)
            num_trainings += 1
            time_left -= iter_time
            # global model evaluation
            #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
            if last_eval_time > time_left + 2:
                last_eval_time = time_left
                preds_test = global_model.predict(test_X)
                loss.append(mean_squared_error(preds_test, test_Y))
                time.append(total_time - time_left)
                print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                      "\nregret: ", regret[-1], "\n\n")
            t += 1

        t = tmp_t + int(np.ceil(num_of_clients / selection_size))
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients, all_data_size=len(train_Y))
    elif optimal_genie and t == 0:
        t = 1

    # main loop
    while time_left > 0:
        # selection training
        if optimal_genie:
            selection_idxes = optimal_genie_idxes
        else:
            print("ucb:", [client.ucb for client in all_clients])  # for check
            print("num of observations:", [client.num_of_observations for client in all_clients])  # for check
            sorted_ucbs = sorted(all_clients, key=lambda client: client.ucb, reverse=True)
            selection_idxes = [client.num for client in sorted_ucbs[:selection_size]]
        print("chosen clients:", selection_idxes)
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, selection_idxes))
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size,
                                    [all_clients_dists[j] for j in selection_idxes], num_trainings, cs_ucb=True)
        num_trainings += 1
        time_left -= iter_time
        # global model evaluation
        #if t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                  "\nregret: ", regret[-1], "\n\n")
        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients, all_data_size=len(train_Y))

    regret = [sum(regret[:i+1]) for i in range(len(regret))]
    return time, loss, regret,  [client.num_of_observations for client in all_clients]


def cs_ucb_q(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_X,
           test_Y, total_time=None, t=1, alpha=50):
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
    regret = []
    num_trainings = 0
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
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, selection_idxes))
        print("ucb:", [client.ucb for client in all_clients])  # for check
        print("num of observations:", [client.num_of_observations for client in all_clients])  # for check
        print("chosen clients:", selection_idxes)
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in selection_idxes],
                                    selection_size, [all_clients_dists[j] for j in selection_idxes], num_trainings, cs_ucb=True)
        num_trainings += 1
        b = np.zeros((num_of_clients))
        b[selection_idxes] = 1
        time_left -= iter_time
        # update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t, selection_size=1, num_of_clients=num_of_clients, all_data_size=len(train_Y))
        # global model evaluation
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                  "\nregret: ", regret[-1], "\n\n")

    regret = [sum(regret[:i+1]) for i in range(len(regret))]
    return time, loss, regret, [client.num_of_observations for client in all_clients]



def save_loss_reg(time, loss, regret, name, dir_name):
    ''' saving the loss_list, regret_list and the times_list in "dir_name" directory'''
    with open(dir_name+'/'+name+'_loss', 'wb') as fp:
        pickle.dump(loss, fp)
    with open(dir_name+'/'+name+'_regret', 'wb') as fp:
        pickle.dump(regret, fp)
    with open(dir_name+'/'+name+'_time', 'wb') as fp:
        pickle.dump(time, fp)
    plt.figure(0)
    plt.plot(time, loss, label=name)
    plt.figure(1)
    plt.plot(np.arange(len(regret)), regret, label=name)


def Random_selection_train(global_model, local_model, all_clients, all_clients_dists, num_of_clients, selection_size, test_X,
                           test_Y, alpha=50, total_time=None, iid=True, t=0):
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
    regret = []
    num_trainings = 0
    last_eval_time = time_left+3
    while time_left > 0:
        # selection training
        if iid:
            idxes = np.random.choice(num_of_clients,selection_size,replace=False)
        else:
            all_clients_size = np.array([client.data_size for client in all_clients])
            idxes = np.random.choice(num_of_clients, selection_size, replace=False, p=all_clients_size/np.sum(all_clients_size))
        regret.append(calc_regret(all_clients, all_clients_dists, selection_size, alpha, idxes))
        iter_time = train_selection(global_model, local_model, [all_clients[j] for j in idxes], selection_size,
                                    [all_clients_dists[j] for j in idxes], num_trainings)
        num_trainings += 1
        time_left -= iter_time

        # global model evaluation
        #t % int(np.ceil(num_of_clients//selection_size/15)) == 0: #TODO delete afterwards
        if last_eval_time > time_left + 2:
            last_eval_time = time_left
            preds_test = global_model.predict(test_X)
            loss.append(mean_squared_error(preds_test, test_Y))
            time.append(total_time - time_left)
            print("\n\nglobal model in iteration", t, " with ", time_left, " time left:\nloss: ", loss[-1],
                  "\nregret: ", regret[-1], "\n\n")

        #update the clients vals
        t += 1
        update_clients_ucb_g(all_clients, t + 1, selection_size, num_of_clients, all_data_size=len(train_Y))

    regret = [sum(regret[:i+1]) for i in range(len(regret))]
    return time, loss, regret


def selection_policies_compare(global_model, local_model, train_X, train_Y, test_X,
                               test_Y, t=0, num_of_clients=20, selection_size=5, time_bulks=30, alpha=50):
    ''' recieving global model and local model, and compare the FL training process under 3 different selection
         policies: BSFL, cs-ucb, Random selection. The training process is done for the scenario where the data is divided
          iid and balanced between the clients and the training is done with the train_data+train_labels and test_data+
          test_labels.'''
    all_clients = make_clients(num_of_clients, train_X, train_Y)
    all_clients_dists = np.concatenate((np.random.uniform(low=[0.85, 0], high=[0.9, 0.05], size=(     # TODO change the dists to totally random try diff dits to emphasize our advantage over random selection
    num_of_clients//5, 2)), np.random.uniform(low=[0.05, 0], high=[0.1, 0.05], size=(
    num_of_clients-num_of_clients//5, 2))))  # distributions N(E,sigma) time after normalization by t_max
    np.random.shuffle(all_clients_dists)                # TODO delete later.. done for enphasize the advantage over RR
    # all_clients_dists = np.random.uniform(low=[0.1, 0], high=[0.9, 0.05], size=(num_of_clients, 2))

    dir_name = 'results/lin_reg/iid/' + str(num_of_clients) + '_' + str(selection_size) + '_t=' + str(t) + '_data=' + str(len(train_Y)+len(test_Y)) + '_alpha='+str(alpha) + '_time_bulks='+str(time_bulks)
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
    global_model.coef_, global_model.intercept_ = global_model.coef_*0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_*0, 0


    time, loss, regret, num_of_observations_lst = BSFL(global_model, local_model, all_clients,
                                                       all_clients_dists, num_of_clients,
                                                       selection_size, test_X, test_Y,
                                                       total_time=total_time, alpha=alpha, t=t)
    save_loss_reg(time, loss, regret, 'BSFL', dir_name)
    with open(dir_name + '/BSFL_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t, cs_ucb=True)
    global_model.coef_, global_model.intercept_ = global_model.coef_ * 0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_ * 0, 0

    time, loss, regret, num_of_observations_lst = cs_ucb(global_model, local_model, all_clients,
                         all_clients_dists, num_of_clients, selection_size, test_X, test_Y,alpha=alpha,
                                                         total_time=total_time, optimal_genie=False, t=t)
    save_loss_reg(time, loss, regret, 'cs_ucb', dir_name)
    with open(dir_name + '/cs_ucb_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.coef_, global_model.intercept_ = global_model.coef_ * 0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_ * 0, 0

    time, loss, regret = Random_selection_train(global_model, local_model, all_clients, all_clients_dists,
                    num_of_clients, selection_size, test_X, test_Y, alpha=alpha, total_time=total_time, t=t)
    save_loss_reg(time, loss, regret, 'Random_selection', dir_name)

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
    plt.title("Regret "+dir_name)
    plt.xlabel('iterations')
    plt.ylabel('regret')
    plt.savefig(dir_name + '/' + 'regret_selections', dpi=1000)
    plt.show()
    plt.figure(0)
    plt.show()


def non_iid_selection_policies_compare(global_model, local_model, train_X, train_Y, test_X, test_Y, t=0, num_of_clients=500, selection_size=25, time_bulks=20, alpha=50):
    ''' recieving global model and local model, and compare the FL training process under 3 different selection
             policies: BSFL, cs-ucb-q, Random selection. The training process is done for the scenario where the data is divided
              non iid and imbalanced between the clients and the training is done with the train_data+train_labels and test_data+
              test_labels.'''
    all_clients = make_clients_non_iid(train_X, train_Y, num_of_clients)
    all_clients_dists = np.concatenate((np.random.uniform(low=[0.85, 0], high=[0.9, 0.05], size=( # TODO change the dists to totally random try diff dits to emphasize our advantage over random selection
        num_of_clients // 5, 2)), np.random.uniform(low=[0.05, 0], high=[0.1, 0.05], size=(
        num_of_clients - num_of_clients // 5, 2))))  # distributions N(E,sigma) time after normalization by t_max
    np.random.shuffle(all_clients_dists)  # TODO delete later.. done for enphasize the advantage over RR
    # all_clients_dists = np.random.uniform(low=[0.1, 0], high=[0.9, 0.05], size=(num_of_clients, 2))

    dir_name = 'results/lin_reg/non_iid/'+ str(num_of_clients) + '_' + str(selection_size) + '_t=' + str(t) + '_data=' + str(len(train_Y)+len(test_Y)) + '_alpha='+str(alpha) + '_time_bulks='+str(time_bulks)
    os.mkdir(path=dir_name)
    total_time = 1 + num_of_clients // selection_size * time_bulks
    # total_time = 2
    print([client.data_size for client in all_clients])
    print([dist[0] for dist in all_clients_dists])


    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.coef_, global_model.intercept_ = global_model.coef_ * 0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_ * 0, 0

    time, loss, regret, num_of_observations_lst = BSFL(global_model, local_model, all_clients,
                                                       all_clients_dists, num_of_clients,
                                                       selection_size, test_X, test_Y, iid=False,
                                                       total_time=total_time, alpha=alpha, t=t)
    save_loss_reg(time, loss, regret, 'BSFL', dir_name)
    with open(dir_name + '/BSFL_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t, cs_ucb=True)
    global_model.coef_, global_model.intercept_ = global_model.coef_ * 0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_ * 0, 0

    time, loss, regret, num_of_observations_lst = cs_ucb_q(global_model, local_model, all_clients,
                                                         all_clients_dists, num_of_clients, selection_size, test_X,
                                                         test_Y, alpha=alpha,
                                                         total_time=total_time, t=t)
    save_loss_reg(time, loss, regret, 'cs_ucb_q', dir_name)
    with open(dir_name + '/cs_ucb_q_num_of_observations_lst', 'wb') as fp:
        pickle.dump(num_of_observations_lst, fp)

    init_clients(all_clients, all_clients_dists, selection_size, num_of_clients, t=t)
    global_model.coef_, global_model.intercept_ = global_model.coef_ * 0, 0
    local_model.coef_, local_model.intercept_ = global_model.coef_ * 0, 0

    time, loss, regret = Random_selection_train(global_model, local_model, all_clients, all_clients_dists,
                                                num_of_clients, selection_size, test_X, test_Y, iid=False, alpha=alpha,
                                                total_time=total_time, t=t)
    save_loss_reg(time, loss, regret, 'Random_selection', dir_name)


    with open(dir_name+'/all_clients_dists', 'wb') as fp:
        pickle.dump(all_clients_dists, fp)
    with open(dir_name+'/all_clients_data_sizes', 'wb') as fp:
        pickle.dump([client.data_size for client in all_clients], fp)

    plt.figure(0)
    plt.legend()
    plt.title("Loss " + dir_name)
    plt.xlabel('latency')
    plt.ylabel('loss')
    plt.savefig(dir_name + '/' + 'loss_selections', dpi=1000)
    plt.figure(1)
    plt.legend()
    plt.title("Regret " + dir_name)
    plt.xlabel('iterations')
    plt.ylabel('regret')
    plt.savefig(dir_name + '/' + 'regret_selections', dpi=1000)
    plt.show()
    plt.figure(0)
    plt.show()



num_features = 10
num_datapoints = 2800

train, test = make_data(num_datapoints, num_features)
train_X, train_Y = train[:,:num_features], train[:,num_features]
test_X, test_Y = test[:,:num_features], test[:,num_features]

global_model = LinearRegression()
global_model.fit(train_X[:2,:],train_Y[:2])     # for initial the coef and intercept later

local_model = LinearRegression()
local_model.fit(train_X[:2,:],train_Y[:2])     # for initial the coef and intercept later

# selection_policies_compare(global_model, local_model, train_X, train_Y, test_X,
#                                test_Y, t=0, num_of_clients=20, selection_size=5, time_bulks=20, alpha=1)
non_iid_selection_policies_compare(global_model, local_model, train_X, train_Y, test_X,
                               test_Y, t=0, num_of_clients=20, selection_size=5, time_bulks=20, alpha=200)

print("done")





