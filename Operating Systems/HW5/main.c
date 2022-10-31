////////////////////////////////////////////////
///  by:     Dan Ben Ami - 316333079
///          Tom kessous - 206018749
///////////////////////////////////////////////
///===========   includes  ==========================
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/msg.h>
#include <unistd.h>
#include <signal.h>


///===================   defines  ==========================
/// Probabilities
#define HIT_RATE 					0.5
#define WR_RATE 					0.5

/// System properties
#define N 5
#define USED_SLOTS_TH 3

/// Times
#define SIM_TIME 					2	//in seconds
#define TIME_BETWEEN_SNAPSHOTS  100000000 	//in ns
#define MEM_WR_T 				1000		//in ns
#define HD_ACCS_T 				100000  	//in ns
#define INTER_MEM_ACCS_T 		10000	    //in ns


/// msg types
#define WR_req 1
#define RD_req 2
#define MMU_Ack 3
#define HD_req 4
#define HD_Ack 5



///=====================   structures  ==========================
typedef struct message {
    long type;
    char chr;  // 1=proc1, 2=proc2, 3=mmu, 4=HD
} msg;

typedef struct memory {
    int valid[N];
    int dirty[N];
    int valid_cnt;
    int dirty_cnt;
    int clock_ptr;
} memory;
///====================  global variables  =================
int msgs_Qs[4];         //[proc1, proc2, MMU, HD]
pid_t pids[4];
int run_system;
memory mem;
pthread_mutex_t mem_lock;
pthread_cond_t mmu_cond;
pthread_cond_t evicter_cond;
pthread_t tids[3];

///=======================   prototypes  ==========================
void process(char proc_num);
void init();
int open_queue(key_t keyval);
void my_msgsnd(int queue,const char proc_num, long type);
msg my_msgrcv(int qid,int type);
pid_t my_fork();
void create_processes();
void terminate_mmu_from_mmu();
void hit_case(msg* rcv_msg_ptr);
void mmu_main();
void my_lock(pthread_mutex_t *mutex);
void my_unlock(pthread_mutex_t *mutex);
void my_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
void my_cond_signal(pthread_cond_t *cond);
void printer();
void HD();
void evicter();
void my_ptherad_create(pthread_t *tid, void* func);
void kill_them_all();
void mmu();
void terminate_mmu_from_father();
void print_mem();                       ///DEBUGGGGG

///========================   functions     ============================

int main() {
    init();
    create_processes();
    return 0;
}


void process(char proc_num){
///This function simulate a process that invoke memory accesses every INTER_MEM_ACCS_T ns by requesting from the MMU.
    int iter_cnt=0;
    srand(time(0));
    int max_iters = (int)((SIM_TIME*1e10)/INTER_MEM_ACCS_T);   //Wait 10 times the SIM_TIME (endless loop for our purposes)
    while(iter_cnt < max_iters) {
        nanosleep((const struct timespec[]) {{INTER_MEM_ACCS_T / (int) (1e9),
                                                     ((long) (INTER_MEM_ACCS_T % ((int) 1e9)))}}, NULL);
        iter_cnt++;
        if ((double) rand() / (double) RAND_MAX <= WR_RATE) {
            //Invoke write operation
            my_msgsnd(msgs_Qs[2], proc_num, WR_req);
        } else {
            //Invoke read operation
            my_msgsnd(msgs_Qs[2], proc_num, RD_req);
        }
        my_msgrcv(msgs_Qs[(int)(proc_num-'1')],MMU_Ack);
//        printf("Proc %d got ACK.\n",(int)(proc_num-'0'));
    }
}


int open_queue( key_t keyval ){
    int qid;
    if((qid = msgget( keyval, IPC_CREAT | 0666 )) == -1){
        printf("ERROR while open Queue.");
        perror("IPC error: msgget"); exit(1);    }
    return qid;
}


void init() {
    int queue = 0;
    key_t key;

    /// create queues
    for (queue = 0; queue < 4; queue++) {
        if ((key = ftok("/tmp", 'a'+queue)) == (key_t) -1) {
            perror("IPC error: ftok");
            exit(1);
        }
        msgs_Qs[queue] = open_queue(key);
//        printf("ID: %d Q: %d\n",queue,msgs_Qs[queue]);      //DEBUG
    }
}


void create_processes(){
    int i;
    pid_t pid;
    for(i=0;i<4;i++){
        pid = my_fork();
        if(!pid){
            switch (i) {
                case 0:
                    process('1');
                    break;
                case 1:
                    process('2');
                    break;
                case 2:
                    signal(SIGKILL, terminate_mmu_from_father);
                    mmu();
                    break;
                case 3:
                    HD();
                    break;
                default:
                    break;
            }
            break;
        }
        else if(i==3){                   //Father process
            pids[i] = pid;
            signal(SIGKILL,kill_them_all);
            sleep(SIM_TIME);
            kill_them_all();
            printf("Successfully finished sim");
        }
        else pids[i] = pid;
    }
//    printf("AFTER FOR!\n");
}


void kill_them_all() {
    int j=0;
    for(j=0;j<4;j++) {
        kill(pids[j],SIGKILL);
        wait(NULL);
        msgctl(msgs_Qs[j],IPC_RMID,NULL);
    }
}


void my_msgsnd(int queue,const char proc_num, long type){
    msg send_msg;
    send_msg.chr = proc_num;
    send_msg.type = type;
//    printf("my_msgsnd:\n proc_num = %c\n type = %ld\n\n",proc_num,type);                //DEBUG
    if(msgsnd(queue, &send_msg, sizeof(send_msg.chr), 0) == -1){
        perror("IPC error in msgsnd");
        kill_them_all();
    }
}


msg my_msgrcv(int qid,int type){
    msg recieved_msg;
//    printf("my_msgrcv:\n type = %d\n",type);                //DEBUG
    if(msgrcv(qid,&recieved_msg,sizeof(recieved_msg.chr),type,0) == -1){
        perror("IPC error in msgrcv");
        kill_them_all();
    }
//    printf("recieved_msg:\n recieved_msg.chr = %c\n recieved_msg.chr = %ld\n\n",recieved_msg.chr,recieved_msg.type);
    return recieved_msg;
}


pid_t my_fork(){
    pid_t pid;
    if((pid = fork())== -1 ){
        perror("fork failed");
        kill_them_all();
    }
    return pid;
}


void mmu(){
    mem.clock_ptr = 0;
    mem.valid_cnt = 0;
    mem.dirty_cnt =0;
    for(int i =0; i<N;i++) {
        mem.valid[i] = 0;
        mem.dirty[i] = 0;
    }
    if(pthread_mutex_init(&mem_lock,NULL)){
        perror("Mutex init failed");
        terminate_mmu_from_mmu();
    }
    if(pthread_cond_init(&evicter_cond,NULL)){
        perror("Cond init failed");
        terminate_mmu_from_mmu();
    }
    if(pthread_cond_init(&mmu_cond,NULL)){
        perror("Cond init failed");
        terminate_mmu_from_mmu();
    }
    run_system = 1;
    my_ptherad_create(&tids[0],(void*) mmu_main);
    my_ptherad_create(&tids[1],(void*) evicter);
    my_ptherad_create(&tids[2],(void*) printer);
    sleep(SIM_TIME);
    run_system = 0;
}


void mmu_main(){
    msg rcv_msg;
    int hit_miss;   //hit=0, miss=1
    srand(time(0));
    while(run_system){
        rcv_msg = my_msgrcv(msgs_Qs[2],-2);  //recieve all messages except HD_Ack type
//        printf("mmu rcv_msg: chr = %c    type = %ld\n", rcv_msg.chr,rcv_msg.type);              //DEBUG
//        print_mem();
        if(!mem.valid_cnt) {         //Page fault - empty memory
//            printf("MEMORY EMPTY\n");
            my_msgsnd(msgs_Qs[3],'m',HD_req);
            my_msgrcv(msgs_Qs[2], HD_Ack);
            if(rcv_msg.type == WR_req) {                    //write when mem empty
                nanosleep((const struct timespec[]) {{MEM_WR_T / (int) (1e9),
                                                             ((long) (MEM_WR_T % ((int) 1e9)))}}, NULL);
            }
            my_lock(&mem_lock);
            if(rcv_msg.type == WR_req) {
                mem.dirty_cnt++;
                mem.dirty[0] = 1;
            }
            mem.valid_cnt++;
            mem.valid[0] = 1;
            mem.clock_ptr = 0;
            my_unlock(&mem_lock);
            my_msgsnd(msgs_Qs[(int)(rcv_msg.chr - '1')], 'm', MMU_Ack);
//            printf("mmu sent ACK to %d\n",(int)(rcv_msg.chr - '0'));
        }
        else{           //memory is not empty
            hit_miss = (float)rand()/(float)RAND_MAX < HIT_RATE ? 0:1;
            if(!hit_miss) hit_case(&rcv_msg);       //hit
            else{       //miss
//                printf("MISS\n");
                if(mem.valid_cnt == N) {        //memory is full
                    my_lock(&mem_lock);
                    my_cond_signal(&evicter_cond);
                    my_cond_wait(&mmu_cond, &mem_lock);
                    my_unlock(&mem_lock);
                }
                my_msgsnd(msgs_Qs[3],'m', HD_req);
                my_msgrcv(msgs_Qs[2], HD_Ack);
                my_lock(&mem_lock);
                if(rcv_msg.type == WR_req) {
                    mem.dirty_cnt++;
                    mem.dirty[(mem.clock_ptr + mem.valid_cnt) % N] = 1;
                }
                mem.valid[(mem.clock_ptr + mem.valid_cnt) % N] = 1;
                mem.valid_cnt++;
                my_unlock(&mem_lock);
                my_msgsnd(msgs_Qs[(int) (rcv_msg.chr - '1')], 'm', MMU_Ack);
//                printf("mmu sent ACK to %d\n",(int)(rcv_msg.chr - '0'));
            }
        }
    }
}


void hit_case(msg* rcv_msg_ptr){
    int idx;
//    printf("HIT\n");
    if ((*rcv_msg_ptr).type == RD_req) {
        my_msgsnd(msgs_Qs[(int) ((*rcv_msg_ptr).chr - '1')], 'm', MMU_Ack);  //read
//        printf("mmu sent ACK to %d\n",(int)((*rcv_msg_ptr).chr - '0'));
    }
    else {          //write
        nanosleep((const struct timespec[]) {{MEM_WR_T / (int) (1e9),
                                                     ((long) (MEM_WR_T % ((int) 1e9)))}}, NULL);
        my_lock(&mem_lock);
        idx = (mem.clock_ptr+rand() % mem.valid_cnt) % N;
        mem.dirty_cnt = (mem.dirty[idx] == 1 )? mem.dirty_cnt : mem.dirty_cnt+1;
        mem.dirty[idx] = 1;
        my_unlock(&mem_lock);
        my_msgsnd(msgs_Qs[(int) ((*rcv_msg_ptr).chr - '1')], 'm', MMU_Ack);
//        printf("mmu sent ACK to %d\n",(int)((*rcv_msg_ptr).chr - '0'));

    }
}


void evicter(){
//    printf("Hello i am VICTOR\n");
    while(run_system) {
        my_lock(&mem_lock);
        my_cond_wait(&evicter_cond,&mem_lock);
        my_unlock(&mem_lock);
//        printf("evicter woke up and valid cnt = %d\n",mem.valid_cnt);
        while(mem.valid_cnt >= USED_SLOTS_TH){
            if(!mem.valid_cnt) break;   //relevant just in case USED_SLOTS_TH=1
            if(mem.dirty[mem.clock_ptr]) {
                my_msgsnd(msgs_Qs[3],'m', HD_req);
                my_msgrcv(msgs_Qs[2], HD_Ack);
            }
            my_lock(&mem_lock);
            mem.dirty_cnt = (mem.dirty[mem.clock_ptr]== 1) ? mem.dirty_cnt-1 : mem.dirty_cnt;
            mem.dirty[mem.clock_ptr] = 0;
            mem.valid[mem.clock_ptr] = 0;
            mem.valid_cnt--;
            mem.clock_ptr = (mem.clock_ptr + 1) % N;
            my_cond_signal(&mmu_cond);
            my_unlock(&mem_lock);
//            printf("Mem after evicter:\n");
//            print_mem();
        }
    }
}


void my_lock(pthread_mutex_t *mutex){
    if(pthread_mutex_lock(mutex)){
        perror("Mutex lock failed");
        terminate_mmu_from_mmu();
    }
}


void my_unlock(pthread_mutex_t *mutex){
    if(pthread_mutex_unlock(mutex)){
        perror("Mutex unlock failed");
        terminate_mmu_from_mmu();
    }
}


void my_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex){
    if(pthread_cond_wait(cond, mutex)){
        perror("cond wait failed");
        terminate_mmu_from_mmu();
    }
}


void my_cond_signal(pthread_cond_t *cond){
    if(pthread_cond_signal(cond)){
        perror("cond signal failed");
        terminate_mmu_from_mmu();
    }
}


void printer(){
    int i,mem_state;
    int valid[N], dirty[N];
    while(run_system) {
        my_lock(&mem_lock);
        memcpy(dirty, mem.dirty, sizeof(int) * N);
        memcpy(valid, mem.valid, sizeof(int) * N);
        my_unlock(&mem_lock);
        for (i = 0; i < N; i++) {
            if ((valid[i]) && (!dirty[i])) mem_state = '0';
            else if (valid[i]) mem_state = '1';
            else mem_state = '-';
            printf("%d|%c\n", i, mem_state);
        }
        printf("\n\n");
        nanosleep((const struct timespec[]) {{TIME_BETWEEN_SNAPSHOTS / (int) (1e9),
                                                     ((long) (TIME_BETWEEN_SNAPSHOTS % ((int) 1e9)))}}, NULL);
    }
}


void HD(){
    msg rcv_msg;
    int iter_cnt=0;
    int max_iters = (int)((SIM_TIME*1e10)/HD_ACCS_T);   //Wait 10 times the SIM_TIME (endless loop for our purposes)
    while(iter_cnt < max_iters){
        rcv_msg = my_msgrcv(msgs_Qs[3],HD_req);
        nanosleep((const struct timespec[]) {{HD_ACCS_T / (int) (1e9),
                                                     ((long) (HD_ACCS_T % ((int) 1e9)))}}, NULL);
        iter_cnt++;
        my_msgsnd(msgs_Qs[2],'h',HD_Ack);
    }
}


void my_ptherad_create(pthread_t *tid, void* func){
    int error;
    error = pthread_create(tid, NULL, func, NULL);
    if (error != 0) {
        printf("\nThread can't be created :[%s]", strerror(error));
        terminate_mmu_from_mmu();
    }
}


void terminate_mmu_from_mmu(){
    run_system = 0;
    pthread_mutex_destroy(&mem_lock);
    pthread_cond_destroy(&evicter_cond);
    pthread_cond_destroy(&mmu_cond);
    kill(getppid(),SIGKILL);
}


void terminate_mmu_from_father(){
    if(run_system) {
        run_system = 0;
        pthread_mutex_destroy(&mem_lock);
        pthread_cond_destroy(&evicter_cond);
        pthread_cond_destroy(&mmu_cond);
    }
    kill(getpid(),SIGKILL);
}


void print_mem(){
    int i,mem_state,clk;
    int valid[N], dirty[N];
    my_lock(&mem_lock);
    for (i = 0; i < N; i++) {
        dirty[i] = mem.dirty[i];
        valid[i] =  mem.valid[i];
        clk = mem.clock_ptr;
    }
//    memcpy(dirty, mem.dirty, sizeof(int) * N);
//    memcpy(valid, mem.valid, sizeof(int) * N);
    my_unlock(&mem_lock);
    printf("clock ptr: %d\n",clk);
    for (i = 0; i < N; i++) {
        if ((valid[i]) && (!dirty[i])) mem_state = '0';
        else if (valid[i]) mem_state = '1';
        else mem_state = '-';
        printf("%d|%c\n", i, mem_state);
    }
    printf("\n\n");
}





