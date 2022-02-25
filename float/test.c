#include <stdio.h>

void Foo() 
{
    volatile float f = 1.0f;
    printf("%f\n", f);
}