////////////////////////////////////////////////
//  by:     Dan Ben Ami - 316333079
//          Tom kessous - 206018749
///////////////////////////////////////////////
//===========   includes  ==========================
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

//===================   defines  ==========================
#define N 5
#define FIN_PROB 0.1
#define MIN_INTER_ARRIVAL_IN_NS 8000000
#define MAX_INTER_ARRIVAL_IN_NS 9000000
#define INTER_MOVES_IN_NS		100000
#define SIM_TIME 2

//=====================   structures  ==========================
typedef struct car{
    pthread_t tid;
    int corner_created;
    int born_now;
    int car_index_in_ptr_cars;
} car;

//====================  global variables  =================
int run_system = 1;                                 //1 while SIM_TIME seconds have not passed.
int circle[4][N-1] = {0};                           //Board: 1 - car, 0 - empty place
pthread_mutex_t squares_mutex[4][N-1];              //Each square in the board is protected by mutex
car* ptr_cars[4][4*(N-1)];                          //2D array for cars pointers (each row for one generator)
pthread_t car_generators_tid[4];                    //Car generators tids.

//=======================   prototypes  ==========================
void print_char(int i, int j);
void* print_board();
void free_mem();
double getMicrotime();
void lock_and_check(int corner, int square);
void* car_move(void* carptr);
int find_free_index(int corner);
void* car_generator(void* input_corner);
void* board_snapshots(void* starting_time);
int mod (int a, int b);
//========================   functions     ============================
int mod (int a, int b){
    //Compute a mod b even if a<0.
    int ret = a % b;
    if(ret < 0)
        ret+=b;
    return ret;
}

void print_char(int i, int j){
    //if square 1 print car, else blank.
    if(circle[i][j]) printf("*");
    else printf(" ");
}
void* print_board(){
    //print the board
    int i,j;
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
            if((i==0)&&(j==0)) print_char(1,0);
            else if(i==0) print_char(0,N-1-j);
            else if((i==N-1)&&(j==N-1)) print_char(3,0);
            else if(i==N-1) print_char(2,j);
            else{
                if(j==0) print_char(1,i);
                else if(j==N-1) print_char(3,N-1-i);
                else printf("@");
            }
        }
        printf("\n");
    }
}

void free_mem(){
    //free all allocated memory by malloc function
    int i,j;
    for(i=0;i<4;i++)
        for(j=0;j<4*(N-1);j++)
            if(ptr_cars[i][j]!= NULL) free(ptr_cars[i][j]);
}

double getMicrotime(){            //Returns the current time in microseconds.
    struct timeval currentTime;
    gettimeofday(&currentTime, NULL);
    return (double)currentTime.tv_sec * (int)1e6 + currentTime.tv_usec;
}

void lock_and_check(int corner, int square){
    //Lock the mutex and check if error occurred.
    if (pthread_mutex_lock(&squares_mutex[corner][square])) {
        printf("\nmutex lock has encountered a problem\n");
        free_mem();
        EXIT_FAILURE;
    }
}

void* car_move(void* carptr){
    car* curr_car = (car*)carptr;
    int next_edge = curr_car->corner_created, next_square=1, curr_square=0;
    int curr_edge = next_edge;
    curr_car->born_now = 1;
    while(run_system) {
        if((curr_car->born_now==1)&&(curr_square==1)) curr_car->born_now=0;
        nanosleep((const struct timespec[]){{INTER_MOVES_IN_NS/(int)(1e9),
                ((long)(INTER_MOVES_IN_NS % ((int)1e9)))}}, NULL);
        if(next_square==N-1){
            next_square = 0;
            next_edge = (next_edge+1) % 4;
        }
        if((next_square==1)&&(curr_car->born_now == 0)){
            if ( (double)rand()/(double)RAND_MAX <= FIN_PROB){
                circle[curr_edge][curr_square] = 0;
                ptr_cars[curr_car->corner_created][curr_car->car_index_in_ptr_cars] = NULL;
                free(curr_car);
                break;
            }
        }
        lock_and_check(next_edge,next_square);
        if(!circle[next_edge][next_square]) {
            circle[next_edge][next_square] = 1;
            circle[curr_edge][curr_square] = 0;
            curr_square = next_square;
            curr_edge = next_edge;
            next_square++;
            pthread_mutex_unlock(&squares_mutex[curr_edge][curr_square]);
        }
        else pthread_mutex_unlock(&squares_mutex[next_edge][next_square]);
    }
}

int find_free_index(int corner){
    int i;
    for(i=0;i<4*(N-1);i++)
        if(!ptr_cars[corner][i]) return i;
}

void* car_generator(void* input_corner){
    int i, error,corner=*(int*)input_corner;
    double random_time;
    while(run_system) {
        random_time = (double)rand() / (double)(RAND_MAX * (MAX_INTER_ARRIVAL_IN_NS - MIN_INTER_ARRIVAL_IN_NS))
                          + MIN_INTER_ARRIVAL_IN_NS;
        nanosleep((const struct timespec[]){{random_time/(int)(1e9),
                ((long)((int)random_time % ((int)1e9)))}}, NULL);
        lock_and_check(mod((corner - 1),4),N - 2);
        lock_and_check(corner,0);
        if ((!circle[mod((corner - 1),4)][N - 2]) && (!circle[corner][0])) {
            i = find_free_index(corner);
            ptr_cars[corner][i] = (car *) malloc(sizeof(car));
            ptr_cars[corner][i]->corner_created = corner;
            ptr_cars[corner][i]->car_index_in_ptr_cars = i;
            error = pthread_create(&ptr_cars[corner][i]->tid, NULL, &car_move,
                                   (void *)ptr_cars[corner][i]);
            if (error != 0) {
                printf("\nThread can't be created :[%s]", strerror(error));
                free_mem();
                EXIT_FAILURE;
            }
            else circle[corner][0] = 1;
        }
        pthread_mutex_unlock(&squares_mutex[corner][0]);
        pthread_mutex_unlock(&squares_mutex[mod((corner - 1),4)][N - 2]);
    }
}

void* board_snapshots(void* starting_time){
    int snapshot_num = 1;
    int time_interval = SIM_TIME*(int)1e5;
    double start_time = *(double*)starting_time;
    while(run_system){
        while(getMicrotime() < start_time+time_interval*snapshot_num);
        print_board();
        printf("\n\n");
        snapshot_num++;
    }
}

int main() {
    int i,j,error,car_gens[4]={0,1,2,3};
    double starting_time;
    pthread_t snapshot_tid;
    srand(time(NULL));

    for(i=0;i<4;i++){                   // mutexes 2D array initialize
        for(j=0;j<N-1;j++){
            if (pthread_mutex_init(&squares_mutex[i][j], NULL) != 0) {
                printf("\n mutex init has failed\n");
                return 1;
            }
        }
    }

    starting_time = getMicrotime();
    run_system = 1;

    for(i=0;i<4;i++){                           //crating threads for the car generators
        error = pthread_create(&car_generators_tid[i], NULL, &car_generator, (void*)&car_gens[i]);
        if (error != 0) {
            printf("\nThread can't be created :[%s]", strerror(error));
            free_mem();
            EXIT_FAILURE;
        }
    }

    error = pthread_create(&snapshot_tid, NULL, &board_snapshots, (void*)&starting_time);         // thread for printing the board
    if (error != 0) {
        printf("\nThread can't be created :[%s]", strerror(error));
        free_mem();
        EXIT_FAILURE;
    }

    while(getMicrotime()-starting_time < SIM_TIME*1e6);       //wait while system is running
    run_system = 0;                                             //end the system run

    for(i=0;i<4;i++) {                                      // waiting for all the running threads to finish
        for (j = 0; j < 4 * (N - 1); j++) {
            if (ptr_cars[i][j])
                pthread_join(ptr_cars[i][j]->tid, NULL);
        }
    }

    for(i=0;i<4;i++){
        pthread_join(car_generators_tid[i],NULL);
    }

    pthread_join(snapshot_tid,NULL);

    for(i=0;i<4;i++){                   // mutexes 2D array destroy
        for(j=0;j<N-1;j++){
            pthread_mutex_destroy(&squares_mutex[i][j]);
        }
    }

    free_mem();                             //freeing allocated memory

    return 0;
}
