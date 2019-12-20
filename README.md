# Do Not Be Afraid

For those worrying about COMP ORG next term, assembly language is much easier to master if you just let go of your expectations.

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
* a goto

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

In this version we lose the fancy shmancy `cout` / `endl`. At this point, we're no longer C++, just C.

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
main:
	stp		x21, x30, [sp, -16]!	
	mov		x21, x1

top:
	ldr		x0, [x21], 8           // argv++, old dereferenced value in x0
	cbz		x0, bottom             // if *argv == NULL goto bottom
	bl		puts                   // puts(*argv)
	b		top                    // goto top

bottom:
	mov		x0, xzr	
	ldp		x21, x30, [sp], 16	
	ret
```

## Bottom line

<center><i>That which you resist, persists.</i></center>

The more you refuse to let go of your high level language syntactic sugar, the harder grokking assembly language will be - making this course harder than it needs to be.

Relax! Free your mind, and you'll soon see things the way they **really** are.

![matrix](./m.jpg)