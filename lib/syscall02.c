#include <stdio.h>
#include <fcntl.h>

int main()
{
    int fd = open("syscall01.s", O_RDONLY);
    if (fd < 0)
        goto err;
        
    puts("open succeeded");
    goto bottom;

err:
    perror("open failed");

bottom:
    return 0;
}
