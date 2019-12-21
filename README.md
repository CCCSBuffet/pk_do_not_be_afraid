# Do Not Be Afraid

For those worrying about CSC 2510 next term, assembly language is much easier to master if you let go of your expectations.

## V1

This program enumerates `argv`, printing each entry. It does not use a for loop counting over `argc`. Rather, it leverages the fact that `argv` is a `NULL` terminated array.

```c++
#include <iostream>

using namespace std;

int main(int argc, char * argv[]) {
	while (*argv) {
		cout << *(argv++) << endl;
	}
	return 0;
}
```

## V2

In this version, we lose the `while` loop, replacing it with:

* a label
* an `if`
* a goto (this might be the only time you'll see goto used!)

```c++
#include <iostream>

using namespace std;

int main(int argc, char * argv[]) {
	top:
		if (*argv) {
			cout << *(argv++) << endl;
			goto top;
		}
	return 0;
}
```

## V3

In this version we lose the `cout` / `endl`. At this point, we're no longer C++, just C.

```c
#include <stdio.h>

int main(int argc, char * argv[]) {
	top:
		if (*argv) {
			puts(*(argv++));
			goto top;
		}
	return 0;
}
```

## V4

In this version we have no brackets at all (except enclosing `main`).

This version is just about assembly language!

```c
#include <stdio.h>

int main(int argc, char * argv[]) {
	top:
		if (*argv == NULL)
			goto bottom;
		puts(*(argv++));
		goto top;

	bottom:
		return 0;
}
```

## V5

Here is the same code expressed in ARM V8 assembly language.

```text
	.global		main
main:
	stp		x21, x30, [sp, -16]!   // push onto stack
	mov		x21, x1                // argc -> x0, argv -> x1

top:
	ldr		x0, [x21], 8           // argv++, old dereferenced value in x0
	cbz		x0, bottom             // if *argv == NULL goto bottom
	bl		puts                   // puts(*argv)
	b		top                    // goto top

bottom:
	ldp		x21, x30, [sp], 16     // pop from stack
	mov		x0, xzr	               // return 0
	ret
```

Of interest are the lines between `top` and `bottom` - notice how naturally the assembly language flows from the high level language. It is also interesting how braces can become labels and branches. 

## Bottom line

*That which you resist, persists.*

CSC 2510 will be much easier if you relax and keep an open mind.

Free your mind, and you'll soon see things the way they **really** are.

![matrix](./m.jpg)
