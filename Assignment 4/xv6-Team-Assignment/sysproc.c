#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"

int sysCalls[23]; 
int
sys_sysnumcall(void)
{
 cprintf("\nThis system call is implemented by Tanmay Pradhan A20376280");
 cprintf("\nTotal Sys Calls-> %d",sysCalls[0]); 
 cprintf("\nFork Calls-> %d",sysCalls[1]);
 cprintf("\nExit Call->%d",sysCalls[2]);
 cprintf("\nWait Call->%d",sysCalls[3]);
 cprintf("\nPipe Call->%d",sysCalls[4]);
 cprintf("\nRead Call->%d",sysCalls[5]);
 cprintf("\nkill Call->%d",sysCalls[6]);
 cprintf("\nExec Call->%d",sysCalls[7]);
 cprintf("\nfstat Call->%d",sysCalls[8]);
 cprintf("\nChdir Call->%d",sysCalls[9]);
 cprintf("\nDup Call->%d",sysCalls[10]);
 cprintf("\nGet PID Call->%d",sysCalls[11]);
 cprintf("\nSbrk Call->%d",sysCalls[12]);
 cprintf("\nSleep Call->%d",sysCalls[13]);
 cprintf("\nUptime Call->%d",sysCalls[14]);
 cprintf("\nOpen Call->%d",sysCalls[15]);
 cprintf("\nWrite Call->%d",sysCalls[16]);
 cprintf("\nMknod Call->%d",sysCalls[17]);
 cprintf("\nunlink Call->%d",sysCalls[18]);
 cprintf("\nlink Call->%d",sysCalls[19]);
 cprintf("\nmkdir Call->%d",sysCalls[20]);
 cprintf("\nClose Call->%d",sysCalls[21]);
 cprintf("\nSysnumcall Call->%d",sysCalls[22]);
 memset(sysCalls,0,sizeof(sysCalls));
return 0; 
 
}
int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
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
