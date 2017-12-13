#include "types.h"
#include "user.h"
#include "syscall.h"
#include "fcntl.h"
#include "stat.h"

int
main(int argc, char *argv[])
{
      int x = open("smallfile2.txt", O_CREATE|O_WRONLY|O_SFILE);
      printf(1,"Test program %d\n",x);
      char buffer[53] = {'a','b','c','d','b','c','d','b','c','d','b','c','d','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d'};
      write(x, &buffer,53);
      close (x);
      exit();
}
