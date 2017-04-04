#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

#define NCHILD 30 // number of children

struct perf {
  int ctime;  // process creation time
  int ttime;  // process termination time
  int stime;  // the time the process spent in the SLEEPING state
  int retime; // the time the process spent in the READY state
  int rutime; // the time the process spent in the RUNNING state
} p;


void busy_wait(){
  int curr_tick = uptime();
  int tick = curr_tick;
  int counter =0;
  while(counter<30){
    if(uptime()!=tick){
      tick = uptime();
      counter++;
    }
  }
  exit(0);
}

void go_to_sleep(){
  int i;
  for(i=0;i<30;i++)
    sleep(1);
  exit(0);
}

void wait_and_sleep(){
  int i;
  int curr_tick = uptime();
  int tick = curr_tick;
  int counter =0;
  for(i=0;i<5;i++){
    while(counter<30){
    if(uptime()!=tick){
      tick = uptime();
      counter++;
    }
  }
    sleep(1);
  }
  exit(0);
}

/* struct printing */
void print_performance(struct perf p ,int pid){
  printf(1,"the pid is %d\n",pid );
  printf(1,"the turnaround time is %d\n",(p.ttime-p.ctime));
  printf(1,"the ttime is %d\n",p.ttime);
  printf(1,"the stime is %d\n",p.stime);
  printf(1,"the retime is %d\n",p.retime);
  printf(1,"the rutime is %d\n\n",p.rutime);

}

int
main(int argc, char *argv[])
{ 
  printf(1,"=========== Sanity Test Results: ===========\n\n");
  /*creating 10 proccesses of CPU only*/
  int i;
  int pid;
  int* status=0;
  for(i=0;i<NCHILD/3;i++){
    pid =fork();
    if(pid==0)
      busy_wait();
  }

  /*creating 10 proccesses of Blocking only*/
  for(i=0;i<NCHILD/3;i++){
    pid =fork();
    if(pid==0)
      go_to_sleep();
  }

  /*creating 10 proccesses of mixed */
  for(i=0;i<NCHILD/3;i++){
    pid =fork();
    if(pid==0)
      wait_and_sleep();
  }

  /* printing results and averages*/
  int wait=0,turnaround=0,running=0,sleep=0;;
  for(i=0;i<NCHILD;i++){
    // The parent collect the data from each child.
    int child_pid = wait_stat(status,&p);
    print_performance(p,child_pid);
    wait+=p.retime;
    turnaround+=(p.ttime-p.ctime);
    running+=p.rutime;
    sleep+=p.stime;
  }

  // compute averages
  wait=wait/NCHILD;
  turnaround=turnaround/NCHILD;
  running=running/NCHILD;
  sleep=sleep/NCHILD;

  printf(1,"=========== The avrages are ===========\n" );
  printf(1,"waiting time: %d\n",wait);
  printf(1,"turnaround time: %d\n",turnaround);
  printf(1,"running time: %d\n",running);
  printf(1,"sleeping time: %d\n",sleep);

  return 1;
}
