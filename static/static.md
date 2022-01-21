# `static`, Globals and `const` Globals

## Background on the `static` Keyword

The keyword `static` denotes a persistant name that is not visible outside its current scope.

A `static` global is not visible outside the file it is defined in.

A `static` local variable is persistant across function calls and is not known outside the function.

A `static` function is known only within the file in which it is defined.

A `static` method is a little different: it is known within a `class` or `struct` and may also be known outside the `class` or `struct` but is not associated with a specific instance of the `class` or `struct`.

## `static` is "Default" for Symbols

To the degree to which the `static` keyword means to keep hidden, all symbols are hidden within the file in which they are defined unless they appear on a `.global` directive.

We have seen, for example, that your assembly language program will not link properly unless `main` is marked as `.global` as on `line 25` of the program below.

## `.bss`, `.rodata` and `.data`

Consider the following program:

```asm
        //                                                              // 1 
        // .bss area is initialized  to 0 when the program begins       // 2 
        // running. The section does not occupy space in the exe.       // 3 
        //                                                              // 4 
                                                                        // 5 
        .bss                                                            // 6 
array:  .space  32                                                      // 7 
foo:    .word   0, 0, 0, 0                                              // 8 
                                                                        // 9 
        //                                                              // 10 
        // .rodata stands for read-only data - i.e. consts.             // 11 
        //                                                              // 12 
                                                                        // 13 
        .section    .rodata                                             // 14 
s1:     .asciz      "Ghis is a string"                                  // 15 
                                                                        // 16 
        //                                                              // 17 
        // .data is for all other data defined at compile time.         // 18 
        //                                                              // 19 
                                                                        // 20 
        .data                                                           // 21 
s2:     .asciz      "Ghis is a string"                                  // 22 
                                                                        // 23 
        .text                                                           // 24 
        .global     main                                                // 25 
                                                                        // 26 
main:   // Attempt to correct s2.                                       // 27 
        mov         w0, 'T'                                             // 28 
        ldr         x1, =s2                                             // 29 
        strb        w0, [x1]                                            // 30 
        // Attempt to correct s1.                                       // 31 
        ldr         x1, =s1                                             // 32 
        strb        w0, [x1]                                            // 33 
        ret                                                             // 34 
                                                                        // 35 
        .end                                                            // 36 
```

`Line 6` introduces a `.bss` or `Block Started by Symbol` section. Data specified within the `.bss` will be initialized to zero as the program is loaded into memory prior to the start of its execution. An assembler error is generated if you try to initialize anything in the `.bss` with a value other than zero.

`Line 7` arranges for 32 bytes to be set aside prior to program start. It will be initialized to 0.

`Line 8` arranges for 4 `ints` to be set aside prior to program start. The 4 is decided by how many comma separated zeros appear here. If any value other than zero was entered, it would have caused an assembler error.

`Line 14` starts a `.rodata` section. Any data declared in a `.rodata` section is *read-only*, in other words: `const` in `C++`. We'll test this as part of this program's code.

`Line 15` defines a read-only zero-terminated ASCII string. Oh, too bad! Looks like we have a typo in the string - we'll try to patch it in memory. Hint: we will fail.

`Line 21` starts a `.data` section. Data which is initialized to non-zero and which is not read-only is found here.

`Line 22` defines another null-terminated string and it looks like we have the same typo. We'll try to patch this value as well.

Let's turn to `gdb` and explore our program:

```text
(gdb) b main
Breakpoint 1 at 0x750: file static02.s, line 28.
(gdb) p/x &array
$1 = 0x11022
(gdb) p/x &foo
$2 = 0x11042
(gdb) p (void*)&foo - (void*)&array
$3 = 32
```

Upon launching `gdb` we set a breakpoint at `main()` so that execution pauses.

Next, let's take a look at the data we set aside in the `.bss` section. We subtract the address of `array` from the address of `foo` to confirm that `array` is indeed 32 bytes long. You can enter very complex expressions into `gdb` and it will probably do the right thing.

```text
(gdb) x/s &s2
0x11010:    "Ghis is a string"
```

Above, we confirm that the string `s2` has a typo.

Let's run the program and try to correct the typo using code.

```text
(gdb) run
Starting program: ./a.out 
Breakpoint 1, main () at static02.s:28
28          mov         w0, 'T'
(gdb) n
29          ldr         x1, =s2
(gdb) n
30          strb        w0, [x1]
(gdb) n
32          ldr         x1, =s1
(gdb) x/s &s2
0xaaaaaaabb010: "This is a string"
```

We put a `T` into `w0`. Next, we load the address of `s2` and store the `T` into that first byte. Finally, we confirm we corrected the typo and indeed, all is well.

Since that worked so well, let's correct the typo in `s1` using the same technique.

```text
(gdb) n
33          strb        w0, [x1]
(gdb) n

Program received signal SIGSEGV, Segmentation fault.
main () at static02.s:33
33          strb        w0, [x1]
(gdb) 
```

This time, the program has crashed. The crash is because `s1` is sitting in memory that has been tagged as being *read-only*.

## Listing Generated by the Assembler

At this moment, let's introduce the listings that can be generated by the assembler:

```text
static > as -al static02.s
AARCH64 GAS  static02.s             page 1


   1                        //
   2                        // .bss area is initialized  to 0 when the program begins
   3                        // running. The section does not occupy space in the exe.
   4                        //
   5                
   6                        .bss
   7 0000 00000000  array:  .space  32 
   7      00000000 
   7      00000000 
   7      00000000 
   7      00000000 
   8 0020 00000000  foo:    .word   0, 0, 0, 0
   8      00000000 
   8      00000000 
   8      00000000 
   9                
  10                        //
  11                        // .rodata stands for read-only data - i.e. consts.
  12                        //
  13                
  14                        .section    .rodata
  15 0000 47686973  s1:     .asciz      "Ghis is a string"
  15      20697320 
  15      61207374 
  15      72696E67 
  15      00
  16                
  17                        //
  18                        // .data is for all other data defined at compile time.
  19                        //
  20                
  21                        .data
  22 0000 47686973  s2:     .asciz      "Ghis is a string"
  22      20697320 
  22      61207374 
  22      72696E67 
  22      00
  23                
  24                        .text
  25                        .global     main
  26                
  27                main:   // Attempt to correct s2.
  28 0000 800A8052          mov         w0, 'T'
  29 0004 A1000058          ldr         x1, =s2
  30 0008 20000039          strb        w0, [x1]
  31                        // Attempt to correct s1.
  32 000c A1000058          ldr         x1, =s1
  33 0010 20000039          strb        w0, [x1]
  34 0014 C0035FD6          ret
  35                
  36 0018 00000000          .end
  36      00000000 
  36      00000000 
  36      00000000 
```

A few fun things here include noting the 0x20 difference between `foo` and `array` corresponding to the `32` bytes being set aside for `array`. Also, note the null termination of strings `s1` and `s2`.
