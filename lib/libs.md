# Calling `C` Libraries and Functions

[Here](../interop/interop.md) we saw how to call assembly language functions from `C` and `C++`. Now, let's go in the opposite direction. Calling `C` functions from assembly language. It is possible, but harder, to call `C++` from assembly language. The added difficulty associated with `C++` is largely due to something called [name mangling](../static/static.md).

## Two Most Common Libraries

By default, programs are linked with the standard `C` runtime. The `C` runtime is a large library of frequently used functions described in chapter 3 of the Unix manuals.

Also, `system calls` are also frequently made. These are requests to the Operating System to perform some action on our behalf. The `C` runtime is made up of standard user level functions. System calls, on the other hand leave user-land and enter kernel space for their implementation. System calls are largely documented in chapter 2 of the Unix manuals.

A detailed discussion of system calls is best left for a book on OS internals and while we may get into details, we aren't likely to go into much detail at this time.

### Calling the `C` Runtime

As indicated, when programs are built they are linked with the `C` runtime by default. Functions from the `C` runtime can simply be called using the `bl` instruction.

Here's a first example:

```asm
        .global main                                                    // 1 
        .text                                                           // 2 
        .align  2                                                       // 3 
                                                                        // 4 
main:   stp     x29, x30, [sp, -16]!                                    // 5 
        ldr     x0, =s                                                  // 6 
        bl      printf                                                  // 7 
        ldp     x29, x30, [sp], 16                                      // 8 
        mov     x0, xzr                                                 // 9 
        ret                                                             // 10 
                                                                        // 11 
        .section    .rodata                                             // 12 
s:      .asciz      "hello, world\n"                                    // 13 
        .end                                                            // 14 
```

`Line 5` and `8` are necessary to preserve `x30` in particular. `x30` is the `link register` which stores the address we need to return to as a consequence of the `ret` instruction. This is discussed at length [here](../regs/backup.md).

The link register must be preserved and restored because our function is itself calling another function (`printf()`). The `bl` on `line 7` will overwrite the address we received in `x30` with the address of `line 8`. If we did not backup and restore the link register, we would crash in this case.

Here is how the program is built - notice how linking with the `C` runtime is by default:

```text
lib > gcc hw.s
lib > ./a.out
hello, world
lib > 
```

### Why No Header Files?

You might be wondering why we were simply able to refer to `printf()` without the need to `include` a header file. The core purpose of include files is to establish *signatures* of functions, classes, structs and external globals. Signatures are used to enforce type checking. As there is no type checking in assembly language (other than you!), header files aren't needed per se. The linker is responsible for ensuring there exists a target for every symbol.

## Making System Calls

Asking the OS to perform services for us is done by making system calls.
There are two ways of making system calls:

1) making them directly
2) making them via a stubbed proxy or wrapper

The second way is identical to calling user-land library functions and is how higher level languages make system calls.

Here is an example calling a stub or user-land wrapper function:

```asm
        .global main                                                    // 1 
        .equ    O_RDONLY, 0                                             // 2 
        .text                                                           // 3 
        .align  2                                                       // 4 
                                                                        // 5 
main:   stp     x29, x30, [sp, -16]!                                    // 6 
        str     x20, [sp, -16]!         // x20 used to buffer FD        // 7 
                                                                        // 8 
        ldr     x0, =fname                                              // 9 
        mov     w1, O_RDONLY                                            // 10 
        bl      open                    // use stub to make system call // 11 
        cmp     w0, wzr                 // a bad return is negative     // 12 
        blt     90f                     // if bad, skip over the good   // 13 
                                                                        // 14 
        mov     w20, w0                 // preserve FD                  // 15 
        ldr     x0, =osucc              // print a success message      // 16 
        bl      puts                                                    // 17 
                                                                        // 18 
        mov     w0, w20                 // restore FD                   // 19 
        bl      close                   // use stub to make system call // 20 
        b       99f                     // skip over else code          // 21 
                                                                        // 22 
90:     ldr     x0, =ofail              // print an error message       // 23 
        bl      perror                                                  // 24 
                                                                        // 25 
99:     ldr     x20, [sp], 16                                           // 26 
        ldp     x29, x30, [sp], 16                                      // 27 
        mov     x0, xzr                                                 // 28 
        ret                                                             // 29 
                                                                        // 30 
        .section    .rodata                                             // 31 
fname:  .asciz      "syscall01.s"                                       // 32 
ofail:  .asciz      "open failed"                                       // 33 
osucc:  .asciz      "open succeeded"                                    // 34 
                                                                        // 35 
        .end                                                            // 36 
```

The above program attempts to open a file (hard coded to be the name of the source code for the program itself). The two system calls used are `open()` and `close()`. However, this code doesn't directly make the system calls but rather, calls wrapper found in the runtime. These wrappers set up the system call by ensuring certain values are placed into certain registers before causing the transition from user land to kernel land.

Here is the identical program written in deconstructed `C`:

```c
#include <stdio.h>                                                      // 1 
#include <fcntl.h>                                                      // 2 
                                                                        // 3 
int main()                                                              // 4 
{                                                                       // 5 
    int fd = open("syscall01.s", O_RDONLY);                             // 6 
    if (fd < 0)                                                         // 7 
        goto err;                                                       // 8 
                                                                        // 9 
    puts("open succeeded");                                             // 10 
    goto bottom;                                                        // 11 
                                                                        // 12 
err:                                                                    // 13 
    perror("open failed");                                              // 14 
                                                                        // 15 
bottom:                                                                 // 16 
    return 0;                                                           // 17 
}                                                                       // 18 
```

## Crossing into Kernel Space

System calls are implemented by "the system" i.e. the OS.

In order to reach inside the OS there must be a transition from user-land to kernel space. This is done using a special trap instruction which on the AARCH64 ISA is `svc` (as in "service"). The user-land wrapper performs certain bookkeeping prior to causing the trap. It is the bookkeeping that will inform the OS's trap handler what service the user program is requesting.

Over time, layers and layers of cruft have piled up in the Linux kernel. What started out as a system designed for simplicity (Unix) has become exactly what the creators of Unix abhored the most. To the current point, we demonstrate how the system call `close()` is actually made under the hood rather than showing `open()` which has been improved so much we'll avoid it.

```asm
        mov     w0, w20                 // restore FD into w0
        mov     x8, 57                  // select "close"
        svc     0                       // trap!
        b       99f                     // skip over else code
```

Notice how `x8` is used to specify to the OS which system call we desire its help in executing. This is set up prior to calling `svc` with the value of 0. Restated:

* `svc` instruction causes a trap into the operating system
* `0` specifies we are making a system call
* `w8` specifies **which** system call

[Here](https://marcin.juszkiewicz.com.pl/download/tables/syscalls.html) is a handy site for looking up system call numbers. Whereever you see a system call number of `-1` it typically means: "*we couldn't leave well enough alone and felt compelled to put our own ego driven mark on what people smarter than us did before*."
