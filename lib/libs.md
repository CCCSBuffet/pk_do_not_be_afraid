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

## Making System Calls

Asking the OS to perform services for us is done by making system calls.
There are two ways of making system calls:

1) making them directly
2) making them via a stubbed proxy

The second way is identical to calling user-land library functions.

Here is an example:

