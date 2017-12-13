#include "types.h"
#include "user.h"
#include "syscall.h"
#include "fcntl.h"
#include "stat.h"

int
main(int argc, char *argv[])
{
      int x = open("smallfile.txt", O_CREATE|O_WRONLY|O_SFILE);
      printf(1,"Test program %d\n",x);
      char buffer[5] = {'a','b','c','d','b'};
      write(x, &buffer,5);
      close (x);
      exit();
}
