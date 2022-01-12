extern void Foo(int i);
extern void Foo(double f);

void Bar()
{
	Foo(7);
	Foo(7.0);
}