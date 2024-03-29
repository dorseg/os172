#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void) // Ass1: task 2.1
{
  int status;
  if(argint(0, &status) < 0)
    return -1;
  exit(status);
  return 0;  // not reached
}

int
sys_wait(void) // Ass1: task 2.2
{
  int* status;
  if(argint(0, (int*)&status) < 0)
    return -1;
  return wait(status);
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_priority(void)
{
  int pr;
  if(argint(0, &pr) < 0)
    return -1;
  priority(pr);
  return 0;
}

int sys_policy(void)
{
  int pl;
  if(argint(0, &pl) < 0)
    return -1;
  policy(pl);
  return 0;
}

int sys_wait_stat(void)
{
  int *status;
  struct perf* performance;
  if(argint(0, (int*)&status) < 0)
    return -1;
  if(argint(1, (int*)&performance) < 0)
    return -1;
  return wait_stat(status, performance);
}

