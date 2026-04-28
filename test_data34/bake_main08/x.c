#include <stdio.h>

void func1();                   // in y.c or z.c

int main(){
  printf("running func1\n");
  func1();
  return 0;
}
