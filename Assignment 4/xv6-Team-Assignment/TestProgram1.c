#include "types.h"
#include "user.h"
#include "syscall.h"
#include "fcntl.h"
#include "stat.h"

int
main(int argc, char *argv[])
{
      int x = open("smallfile1.txt", O_CREATE|O_WRONLY|O_SFILE);
      printf(1,"Test program %d\n",x);
      char buffer[52] = {'a','b','c','d','b','c','b','c','d','b','c','d','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d','b','c','d'};
      write(x, &buffer,52);
      close (x);
      exit();
}
