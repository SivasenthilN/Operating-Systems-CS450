#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <malloc.h>
#include <stdint.h>
#define MAXARGS 10

typedef struct cmdStack 
{
    int top;
    char *cmd[MAXARGS];
}
cmdStack;


void push(cmdStack *cmdStk, char *cmd)
{
    if(cmdStk -> top < MAXARGS -1)
    {
        cmdStk->top = cmdStk->top + 1;
        cmdStk->cmd[cmdStk->top] = cmd;
    }
    else    
    {
        fprintf(stderr,"MAXARGS limit reached");
    }
}

char* pop(cmdStack cmdStk)
{
    if(cmdStk.top<0)
   {
      printf("Stack empty\n");
      return 0;
   }
   return cmdStk.cmd[cmdStk.top];
}

int
getcmd(char *buf, int nbuf)
{
  
  if (isatty(fileno(stdin)))
    fprintf(stdout, "$ ");
  memset(buf, 0, nbuf);
  fgets(buf, nbuf, stdin);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

void parsecmd(char *buf)
{
    
    cmdStack cmdStk;
    cmdStk.top = -1;
    //fprintf(stderr,"%s", buf);
    char cmd[100]="";
    int cmdPointer =0;
    strcpy(cmd," ");
    char *tempCmd = buf;
    int i;
    while(*tempCmd !='\0')
	{
       //fprintf(stderr,"%c\n", buf[i]);
       if(*tempCmd == '(')
	{
            push(&cmdStk, cmd);
            memset(cmd,0,sizeof(cmd));
        }
        else if(*tempCmd == ')' )
	{
            //fprintf(stderr ,"Inside Pop exec");
            char *execCmd = pop(cmdStk);
            //fprintf(stderr ,"%d",*execCmd);
            system(execCmd);
        }
        else 
	{
            //cmd[cmdPointer]=buf[i];
            //cmdPointer++;
            fprintf(stderr ,"%s\n",cmd);
            fprintf(stderr ,"%s\n",&tempCmd[0]);
            strcat(cmd,(char *)&tempCmd[0]);
            //fprintf(stderr ,"%s\n",cmd);
            
        }
        tempCmd++;
    }
}

int main(void)
{
  static char buf[100];
  int fd, r;

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0)
	{
    		if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
		{
      // Chdir has no effect on the parent if run in the child.
      			buf[strlen(buf)-1] = 0;  // chop \n
      			if(chdir(buf+3) < 0)
       			 fprintf(stderr, "cannot cd %s\n", buf+3);
      			continue;
    		}
	    //fprintf(stderr,"%s", buf);
	   // system(buf);
	    //if(fork1() == 0)
	      //runcmd(parsecmd(buf));
		system(buf);		
		wait(&r);
		
		return 0;
		//parsecmd(buf);		 		
  		// wait(&r);
  	}
exit(0);
}
