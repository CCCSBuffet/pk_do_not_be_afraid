#include <stdio.h>

int main()
{
    char c = 1;
    short s = 2;
    int i = 4;
    long l = 8;

    s += (short) c;
    i += (int) s;
    l += (long) i;

    return 0;
}