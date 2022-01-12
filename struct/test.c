#include <stdio.h>

struct Foo
{
	int x;
	int y;
};

extern void TestAsm(struct Foo *);

void Test(struct Foo * f)
{
	f->x = f->y = 99;
}

int main()
{
	struct Foo foo;

	TestAsm(&foo);
	printf("%d %d\n", foo.x, foo.y);
	return 0;
}