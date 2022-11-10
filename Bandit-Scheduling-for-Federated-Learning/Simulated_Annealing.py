
import numpy as np
from itertools import combinations
import matplotlib.pyplot as plt
import random
import time
from scipy.signal import savgol_filter


Alpha = 0.1
num_of_clients = 500
selection_size = 10


class Client:
    ''' Client object represent a client in the FL training process, each client holds a data and labels, the server
     holds the g function value, the ucb, the counter of the participation and the id of every client'''
    def __init__(self,num, ucb=100000, g=0, data=[0], labels=0, num_of_observations = 0):
        # -------------------------- inside client -----------------------------------------
        self.data = data
        self.labels = labels
        # -------------------------- in the server -----------------------------------------
        self.num = num  # ID i.e. idx in all_clients list
        self.u_time = 1 # sampled mean 1/iter times
        self.ucb = ucb
        self.g = g
        self.num_of_observations = num_of_observations
        self.data_size = np.shape(data)[0]

    def update_u_noo(self, tau, cs_ucb=False):
        if cs_ucb:
            self.u_time = (self.u_time * self.num_of_observations + (1 - tau)) / (self.num_of_observations + 1)
        else:
            self.u_time = (self.u_time * self.num_of_observations + (1 / tau)) / (self.num_of_observations + 1)
        self.num_of_observations += 1

    def update_ucb_g(self, t, selection_size, num_of_clients, iid=True, all_data_size = 60000, beta=1):
        if self.num_of_observations != 0:
            self.ucb = self.u_time + np.sqrt((selection_size+1)*np.log(t)/self.num_of_observations)
        if iid:
            self.g = (selection_size/num_of_clients - self.num_of_observations/t)**beta * np.sign(selection_size/num_of_clients - self.num_of_observations/t)
        else:
            self.g = (selection_size * self.data_size / all_data_size - self.num_of_observations / t)**beta * np.sign(selection_size * self.data_size / all_data_size - self.num_of_observations / t)


class Selection:
    ''' Selection object represent a selection of "size" clients'''
    def __init__(self, num_of_clients, size, clients_lst, alpha=Alpha, cs_ucb=False):
        self.num_of_clients = num_of_clients        # number of clients in total
        self.selection_size = size                  # number of clients in selection
        self.clients_lst = clients_lst              # list of clients in selection
        min_ucb_idx = np.argmin([client.ucb for client in clients_lst])  # idx in clients_lst of min ucb client
        min_g_idx = np.argmin([client.g for client in clients_lst])  # idx in clients_lst of min f client
        # if cs_ucb:
        #     self.energy = clients_lst[min_ucb_idx].ucb + alpha / size * sum([client.g for client in clients_lst])
        # else:
        self.energy = clients_lst[min_ucb_idx].ucb + (alpha / 0.1) * (1 / size) * sum([client.g for client in clients_lst])     #energy is function of min normalized time which is 0.1
        self.clients_nums = [client.num for client in clients_lst] # list of client numbers (indexes in all_clients list)
        self.min_ucb_client_num = clients_lst[min_ucb_idx].num
        self.min_f_client_num = clients_lst[min_g_idx].num


def generate_clients(num_of_clients):
    ''' make random clients for the simulated annealing comparison '''
    all_clients = []
    for i in range(num_of_clients):
        clients_vals = np.random.uniform(0,1,2)
        all_clients.append(Client(i,clients_vals[0], clients_vals[1]))
    return all_clients


def simulated_annealing_A(all_clients, num_of_clients, selection_size, iters, alpha=Alpha, return_history=False, climb_iters=5, return_idxes=False):
    ''' simulated annealing for the naive neighborhood design, where selections that differ in only one clients are
     neighbors.
    complexity: maintain the minimums - O(selection_size), SA iter - O(selection_size) '''
    initial_client_idxes = np.random.choice(num_of_clients, selection_size, replace=False)
    selection = Selection(num_of_clients, selection_size,
                          [all_clients[initial_client_idxes[i]] for i in range(selection_size)],
                          alpha=alpha)  # initial random selection
    k = 1
    cntr1 = 0
    cntr2 = 0
    cntr3 = 0
    history = [0] * (iters + num_of_clients * climb_iters - 1)
    while k < iters + num_of_clients * climb_iters:
        history[k - 1] = selection.energy
        k += 1
        new_client_num = np.random.choice(num_of_clients)  # new client num
        while new_client_num in selection.clients_nums:
            new_client_num = (new_client_num + 1) % num_of_clients
        new_clients_nums = selection.clients_nums.copy()
        new_clients_nums.pop(np.random.choice(selection.selection_size))
        new_clients_nums = new_clients_nums + [new_client_num]
        new_selection = Selection(num_of_clients, selection_size,
                                  [all_clients[new_clients_nums[i]] for i in range(selection_size)])
        T = 1-((k+1)/500000)**0.03    #2/np.log(k) # 1-((k+1)/iters)**0.03        # 2/np.log(k)  # 1- ((k+1)/iters)**0.5     #1-(k+1)/iters #1/np.log(k)
        if selection.energy < new_selection.energy:
            cntr1 += 1
            selection = new_selection
        elif np.e ** ((new_selection.energy - selection.energy) / T) > random.uniform(0, 1) and k < iters:
            cntr2 += 1
            selection = new_selection
        else:
            cntr3 += 1
    print("best_energy of SA_A:", selection.energy)
    print(cntr1, cntr2, cntr3)
    if return_idxes:
        return selection.clients_nums
    elif return_history:
        return history
    return selection.energy


def simulated_annealing_B(all_clients, num_of_clients, selection_size, iters, alpha=Alpha, return_history=False, climb_iters=5, return_idxes=False, save_max = False):
    ''' simulated annealing for the naive neighborhood design, where selections s2 is neighbor of selection s1 iff they
     differ in only one client, and this client is the minimum g or minimum ucb among all clients in s1 (not symmetric).
        complexity: maintain the minimums - O(selection_size), SA iter - O(selection_size) '''
    initial_client_idxes = np.random.choice(num_of_clients, selection_size, replace=False)
    selection = Selection(num_of_clients, selection_size, [all_clients[initial_client_idxes[i]] for i in range(selection_size)], alpha=alpha)  # initial random selection
    k = 1
    cntr1=0
    cntr2=0
    cntr3=0
    history = [0] * (iters + num_of_clients * climb_iters-1)
    max_energy = -num_of_clients*1000000
    max_idxes = []
    while k < iters + num_of_clients * climb_iters:
        history[k-1] = selection.energy
        k += 1
        new_client_num = np.random.choice(num_of_clients)  #new client num
        while new_client_num in selection.clients_nums:
            new_client_num = (new_client_num+1) % num_of_clients
        new_clients_nums = selection.clients_nums.copy()+[new_client_num]
        if bool(random.getrandbits(1)):
            new_clients_nums.remove(selection.min_ucb_client_num)
        else:
            new_clients_nums.remove(selection.min_f_client_num)
        new_selection = Selection(num_of_clients, selection_size, [all_clients[new_clients_nums[i]] for i in
                                                                   range(selection_size)], alpha=alpha)
        T = 1-((k+1)/5000)**0.02  #2/np.log(k)    #1- ((k+1)/iters)**0.5     #1-(k+1)/iters
        if selection.energy < new_selection.energy:
            cntr1 += 1
            selection = new_selection
        elif np.e**((new_selection.energy - selection.energy)/T) > random.uniform(0,1) and k < iters:
            cntr2 += 1
            selection = new_selection
        else:
            cntr3 += 1
        if save_max and selection.energy>max_energy:
            max_energy = selection.energy
            max_idxes = selection.clients_nums
    print("best_energy of SA_B:", selection.energy)
    print(cntr1, cntr2, cntr3)
    if return_idxes:
        if save_max:
            return max_idxes
        return selection.clients_nums
    elif return_history:
        return history
    if save_max:
        return max_energy
    return selection.energy


def simulated_annealing_C(all_clients, num_of_clients, selection_size, iters, alpha=Alpha, return_history=False, climb_iters=5, return_idxes=False, save_max = False):
    ''' simulated annealing for the naive neighborhood design, where selections s1 and s2 are neighbors iff they
     differ in only one client, and this client is the minimum g or minimum ucb among all clients in s1 or s2 (symmetric).
        complexity: maintain the minimums - O(selection_size), SA iter - O(selection_size) '''
    initial_client_idxes = np.random.choice(num_of_clients, selection_size, replace=False)
    selection = Selection(num_of_clients, selection_size, [all_clients[initial_client_idxes[i]] for i in range(selection_size)], alpha=alpha)  # initial random selection
    k = 1
    cntr1=0
    cntr2=0
    cntr3=0
    g_sorted_lst = sorted(all_clients, key=lambda client: client.g, reverse=True)
    ucb_sorted_lst = sorted(all_clients, key=lambda client: client.ucb, reverse=True)
    max_energy = -num_of_clients * 1000000
    max_idxes = []
    history = [0] * (iters + num_of_clients * climb_iters-1)
    while k < iters + num_of_clients * climb_iters:
        history[k-1] = selection.energy
        k += 1
        # number_of_clients_with_bigger_g = g_sorted_lst.index(all_clients[selection.min_f_client_num])
        # number_of_clients_with_bigger_ucb = ucb_sorted_lst.index(all_clients[selection.min_ucb_client_num])

        new_client_num = np.random.choice(num_of_clients)  #new client num
        while new_client_num in selection.clients_nums:
            new_client_num = (new_client_num+1) % num_of_clients
        new_clients_nums = selection.clients_nums.copy()+[new_client_num]
        if bool(random.getrandbits(1)):
            if all_clients[new_client_num].ucb > all_clients[selection.min_ucb_client_num].ucb:
                new_clients_nums.remove(selection.min_ucb_client_num)
            else:
                new_clients_nums.remove(selection.clients_nums[np.random.choice(selection_size)])
        else:
            if all_clients[new_client_num].g > all_clients[selection.min_ucb_client_num].g:
                new_clients_nums.remove(selection.min_f_client_num)
            else:
                new_clients_nums.remove(selection.clients_nums[np.random.choice(selection_size)])
        new_selection = Selection(num_of_clients, selection_size, [all_clients[new_clients_nums[i]] for i in
                                                                   range(selection_size)], alpha=alpha)

        T =  1-((k+1)/500000)**0.03    #2/np.log(k) #1-((k+1)/iters)**0.03       #2/np.log(k)   #2/np.log(k)    #1- ((k+1)/iters)**0.5     #1-(k+1)/iters
        if selection.energy < new_selection.energy:
            cntr1 += 1
            selection = new_selection
        elif np.e**((new_selection.energy - selection.energy)/T) > random.uniform(0,1) and k < iters:
            cntr2 += 1
            selection = new_selection
        else:
            cntr3 += 1
        if save_max and selection.energy>max_energy:
            max_energy = selection.energy
            max_idxes = selection.clients_nums
    print("best_energy of SA_C:", selection.energy)
    print(cntr1, cntr2, cntr3)
    if return_idxes:
        if save_max:
            return max_idxes
        return selection.clients_nums
    elif return_history:
        return history
    if save_max:
        return max_energy
    return selection.energy



def find_max_brute_force(num_of_clients, selection_size, all_clients, return_idxes=False, alpha = Alpha):
    ''' finding the selection with the maximum energy among all the (num_of_clients choose selection_size) possible
    selections, returns the maximum selection's clients indexes or the maximum selection's energy '''
    max_energy = 0
    idxes = []
    for clients in combinations(all_clients,selection_size):
        s = Selection(num_of_clients, selection_size, list(clients), alpha=alpha)
        if s.energy > max_energy:
            max_energy = s.energy
            idxes = [client.num for client in list(clients)]
    if return_idxes:
        return idxes
    print("max_energy:", max_energy)
    return max_energy


def compare_A_to_B(rounds):
    ''' generate random clients and compare the A and B SA simulations for given "rounds".
    print which was better and for how many rounds'''
    cntr_A_better = 0
    cntr_eq = 0
    cntrs = [0,0,0]
    for i in range(rounds):
        all_clients = generate_clients(num_of_clients)
        print("round", i+1,":")
        energy_C = simulated_annealing_C(all_clients, num_of_clients, selection_size, 2000)
        energy_A = simulated_annealing_A(all_clients, num_of_clients, selection_size, 2000)
        energy_B = simulated_annealing_B(all_clients, num_of_clients, selection_size, 2000)
        # if energy_A > energy_B:
        #     cntr_A_better += 1
        # if energy_A == energy_B:
        #     cntr_eq += 1

        if energy_A > energy_C:
            cntr_A_better += 1
        if energy_A == energy_C:
            cntr_eq += 1
        energies = [energy_A, energy_B, energy_C]
        max_e = max(energies)
        for i in range(3):
            if energies[i] == max_e:
                cntrs[i] += 1
    # print("\n\nA was better:", cntr_A_better,"/",rounds, "\nA and B equals:", cntr_eq,"/",rounds, "\nB was better:", rounds-cntr_A_better-cntr_eq,"/",rounds)
    print("\n\nA was best:", cntrs[0],"/",rounds, "\nB was best:", cntrs[1],"/",rounds, "\nC was best:", cntrs[2],"/",rounds)
    print("\n\nA was better:", cntr_A_better,"/",rounds, "\nA and C equals:", cntr_eq,"/",rounds, "\nC was better:", rounds-cntr_A_better-cntr_eq,"/",rounds)


def time_and_result_compare_B_C_naivesearch(num_of_clients,selection_size):
    ''' compare the SA_A, SA_B, naive search for finding the selection with maximum energy,
    print the time each alg was taken and the energy of the maximum selection it found'''
    all_clients = generate_clients(num_of_clients)

    start = time.time()
    energy = simulated_annealing_C(all_clients, num_of_clients, selection_size, 1000, save_max=True)
    print("SA_A took:", time.time() - start)

    start = time.time()
    energy = simulated_annealing_B(all_clients, num_of_clients, selection_size, 1000, save_max=True)
    print("SA_B took:", time.time() - start)

    start = time.time()
    find_max_brute_force(num_of_clients, selection_size, all_clients)
    print("brute_force took:", time.time()-start)


def compare_SA_times(long_iters, short_iters, rounds):
    ''' comparison of SA_B with different anount of iterations (long_iters vs short_iters), the comparison is done for
     "rounds" rounds'''
    long_better_cntr = 0
    eq_cntr = 0
    for i in range(rounds):
        all_clients = generate_clients(num_of_clients)
        energy_history1 = simulated_annealing_B(all_clients, num_of_clients, selection_size, long_iters,
                                                return_history=False)
        energy_history2 = simulated_annealing_B(all_clients, num_of_clients, selection_size, short_iters, return_history=False)
        if energy_history1 > energy_history2:
            long_better_cntr += 1
        elif energy_history1 == energy_history2:
            eq_cntr += 1
    print("long is better:", long_better_cntr,"\nlong and short equals:", eq_cntr, "\nshort is better:", rounds-eq_cntr-long_better_cntr)


def SA_with_learning_curve(iters, climb_iters=0, rounds = 10):
    ''' saves and plots the energy of the current selection through the SA running iterations, the curve is averaged over the
     results of "rounds" runs'''
    all_clients = generate_clients(num_of_clients)
    energy_history_lst = np.zeros((rounds, iters + num_of_clients * climb_iters - 1))
    for i in range(rounds):
        energy_history_lst[i] = np.array(simulated_annealing_A(all_clients, num_of_clients, selection_size, iters,
                                                  return_history=True, climb_iters=climb_iters))
    energy_history = np.average(energy_history_lst,axis=0)
    energy_history = np.concatenate((energy_history[:10],savgol_filter(energy_history, 1 + iters // 30, 2)[10:]))
    plt.plot(np.arange(iters+climb_iters*num_of_clients - 1), energy_history, label="SA with naive neighborhoods")
    energy_history_lst = np.zeros((rounds, iters + num_of_clients * climb_iters - 1))
    for i in range(rounds):
        energy_history_lst[i] = np.array(simulated_annealing_C(all_clients, num_of_clients, selection_size, iters,
                                                               return_history=True, climb_iters=climb_iters))
    energy_history = np.average(energy_history_lst, axis=0)
    energy_history = np.concatenate((energy_history[:10],savgol_filter(energy_history, 1 + iters // 30, 2)[10:]))
    plt.plot(np.arange(iters + climb_iters * num_of_clients - 1), energy_history, label="SA with proposed neighborhoods")
    plt.legend()
    plt.title("Energy as a function of iterations of SA with selection of "+str(selection_size)+" out of "+str(num_of_clients)+"\n")
    plt.xlabel("iterations")
    plt.ylabel("energy")
    plt.savefig('SA_graphs/run_of_SA.png', dpi=1000)
    plt.show()


if __name__ == "__main__":

    time_and_result_compare_B_C_naivesearch(24,6)

    # compare_A_to_B(20)


    # compare_SA_times(10000, 1000, 20)

    # SA_with_learning_curve(150000, rounds=40, climb_iters=0)



































