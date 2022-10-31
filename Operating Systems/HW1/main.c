#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

pid_t my_fork(void);
void print_pids(FILE* fd, short unsigned int N, short unsigned int G);
void count_lines(short unsigned int G);



int main(int argc, char *argv[]){
    int N=0,G=0;
    FILE *fd = fopen("out.txt","w" );
    N = (short unsigned int)*argv[1]-'0';
    G = (short unsigned int)*argv[2]-'0';
    printf("%d %d\n",N,G);
    print_pids(fd,N, G);
    fclose(fd);
    count_lines(G);
}

pid_t my_fork (void){
    pid_t pid;
    if ((pid = fork()) > 0){
        return pid;
        wait(NULL);
    }
    else if(pid==0){
        return pid;
    }
    else{
        printf("Error occured while running a fork");
        exit(1);
    }
}

void print_pids(FILE* fd, short unsigned int N, short unsigned int G){
    int n=0,g=0;
    for(n=0;n<N;n++){
        if(g<G){
            if(my_fork() == 0){
                n=-1;
                g++;
            }
            else wait(NULL);
        }
        if(n==N-1) {
            fprintf(fd, "My pid is %d. My generation is %d\n",getpid(),g);
            if(g!=0) exit(0);
        }
    }
}

void count_lines(short unsigned int G){
    int cntr=0,i=0,args=0,g=0;
    FILE* fd = fopen("out.txt","r");
    args = fscanf(fd,"%*10c%d%*19c%d.\n",&i,&g);
    while(args==2){
        if(g==G) cntr++;
        args = fscanf(fd,"%*10c%d%*19c%d.\n",&i,&g);
        if(args!=2){
            printf("Number of lines by processes of generation %d is %d\n",G,cntr);
            if(G>0) {
                if (my_fork() > 0) wait(NULL);
                else {
                    cntr = 0;
                    G--;
                    rewind(fd);
                    args = fscanf(fd, "%*10c%d%*19c%d.\n", &i, &g);
                }
            }
        }
    }
    exit(0);
}
