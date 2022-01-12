#include <stdio.h>
#include <string.h>

struct Foo
{
	long  a;	// 0  length 8
	int	  b;	// 8  length 4
	short c;	// 12 length 2
	char  d;	// 14 length 1
};

int main()
{
	struct Foo foo;
	memset((void *) &foo, 0, sizeof(struct Foo));
	printf("a: %ld b: %d c: %hd d: %d\n", foo.a, foo.b, foo.c, (int) foo.d);
	return 0;
}