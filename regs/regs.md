# Registers Versus Variables

It is important that you become familiar with all the different kinds and uses of registers available on the AARCH64 ISA. We'll dive into this soon. But first, it is vitally important to expand upon your notion of "variable."

## Why Registers

In most (all?) of the programming you may have done prior to learning assembly language, you've taken it for granted that variables are located somewhere in RAM. This has been a convenient fiction. In reality, virtually all interaction with a variable takes place in a register rather than in RAM.

What you think of as:

```c++
x = x + 1;
```

is really:

```text
1. load the address of x into a register
2. dereference the register to get the value of x into another register
3. add one to it
4. use the address previously loaded to store the value back to RAM 
```

Modern processors that are not slaves to backwards compatibility have fewer and fewer instructions that operate directly upon data in RAM. This is largely because of the stupendous difference in speed at which a processor can access its registers versus the speed at which a processor can access memory.

The following two images are from the [Formulus Black Blog](https://formulusblack.com/blog/compute-performance-distance-of-data-as-a-measure-of-latency/) and are quite informative.

This image relates typical latency (delay) in gaining access to data in various places.

![Latency](./latency.png)

This says that if we liken accessing a register (which can be done at *least* once per CPU Clock Cycle) to one second, accessing memory would be like a 3.5 to 5.5 minute wait.

In the next image, the relative latencies within a computer are expressed in a different way: What is the *effective distance* of a device from the CPU expressed in terms of the *speed of light.* Here, registers can be tought of as being less than 4 inches away from the CPU. Main memory, on the other hand, would be 70 to 100 feet away.

![Latency 2](./latency2.png)

Resist the urge to cling tightly to the idea of data being only found in RAM. 

In order to manipulate data, the data must be loaded into registers. **YOU ARE THE HUMAN!** With planning and forethought YOU can arrange for the data you need most to be resident in registers rather than in RAM. In fact, ideally, you can organize your code and algorithms to minimize the dependence upon RAM and in some cases, you can write whole sophisticated programs using RAM for little more than a place to store string literals.

## Review of Retrieving Data from RAM

The instructions most commonly used to retrieve information from memory are `ldr` and `ldp`. The characters `ld` in these mnemonics bring to mind `load`. `ldr` is "load a register" while `ldp` is "load a pair of registers".

Both of these instructions possess many variations, only a few of which will be described here. In common to all variations of the `ldr` and `ldp` instructions are the notions of *where to fetch from* and *where to store what's been fetched*.

Like many AARCH64 instructions, the most basic form of the load instructions are read right to left as in:

```asm
    ldr    x0, [x1]
```

which means "go to the location in RAM specified by `x1` and load what's there into `x0`."

To facilitate dereferencing `structs` and for accessing `arrays`, an offset may be specified.

There are significant restrictions placed on the offset because the entire instruction (including the encoding of the offset) must fit within a constant 4 byte width of all AARCH64 instructions.

Here is text from an [ARM manual](https://developer.arm.com/documentation/dui0801/h/A64-Data-Transfer-Instructions/LDR--immediate-):

```text
1) LDR Xt, [Xn|SP{, #pimm}] ; 64-bit general registers
2) LDR Xt, [Xn|SP], #simm ; 64-bit general registers, Post-index
3) LDR Xt, [Xn|SP, #simm]! ; 64-bit general registers, Pre-index
```

These say you can load an `x` register (for simplicity we have ignored `w` registers) by dereferencing another `x` register or the stack pointer (i.e. `[Xn|SP]`).

Line 1 says you can *optionally* specify an offset.

Lines 2 and 3 says you can specify a *change* to the dereferenced register either before the actual fetch or after.

Assume `ptr` is a pointer to a `long`.

Line 2 corresponds to: `*(ptr++)`. Line 3 corresponds to: `*(++ptr)`.

Concerning the restrictions placed on the offsets:

* `simm` can be in the range of -256 to 255 (10 bite signed value).
* `pimm` can be in the range of 0 to 32760 in multiples of 8.

## Array Indexing 1 - Wasteful

Consider this code to sum up the values in an array:

```c
long Sum(long * values, long length)                                    /* 1 */
{                                                                       /* 2 */
    long sum = 0;                                                       /* 3 */
    for (long i = 0; i < length; i++)                                   /* 4 */
    {                                                                   /* 5 */
        sum += values[i];                                               /* 6 */
    }                                                                   /* 7 */
    return sum;                                                         /* 8 */
}                                                                       /* 9 */
```

We're not going to translate this to assembly language. Instead, we will call out how inefficient this code is. Notice we're using the index variable `i` for nothing more than traipsing through the array. This is fantastically inefficient (in this case).

## Array Indexing 2 - More Efficiently

Consider the following code that performs the same function:

```c
long Sum(long * values, long length)                                    /* 1 */
{                                                                       /* 2 */
    long sum = 0;                                                       /* 3 */
    long * end = values + length;                                       /* 4 */
    while (values < end)                                                /* 5 */
    {                                                                   /* 6 */
        sum += *(values++);                                             /* 7 */
    }                                                                   /* 8 */
    return sum;                                                         /* 9 */
}                                                                       /* 10 */
```

Notice we don't use an index variable any longer. Instead, we use the pointer itself for both the dereferencing *and* to tell us when to stop the loop.

`values` begins as the address of the first `long` in the array. On `line 4` we leverage *address arithmetic* to determine where to stop. `end` gets the address of the `long` just beyond the end of the array. When we get there, we stop.

Here is a hand translation of the above `C` code:

```asm
    .global Sum                                                         // 1 
    .text                                                               // 2 
    .align  2                                                           // 3 
                                                                        // 4 
//  x0 is the pointer to data                                           // 5 
//  x1 is the length and is reused as `end`                             // 6 
//  x2 is the sum                                                       // 7 
//  x3 is the current dereferenced value                                // 8 
                                                                        // 9 
Sum:                                                                    // 10 
    mov     x2, xzr                                                     // 11 
    add     x1, x0, x1, lsl 3                                           // 12 
    b       2f                                                          // 13 
                                                                        // 14 
1:  ldr     x3, [x0], 8                                                 // 15 
    add     x2, x2, x3                                                  // 16 
2:  cmp     x0, x1                                                      // 17 
    blt     1b                                                          // 18 
                                                                        // 19 
    mov     x0, x2                                                      // 20 
    ret                                                                 // 21 
                                                                        // 22 
    .end                                                                // 23 
```

Recall that `Sum(long * values, long length)` means that `x0` has the address of the first long in the array.

* We know it's an `x` register because it is an address.
* We know it is the `0` register because it is the first argument.

`x1` contains `length`. 

* We know it is an `x` register because it is a `long`.
* We know it is the `1` register because it is the second argument.

`Line 12` is the first really interesting line. It implements `line 4` of the higher level language. That is:

```c
    long * end = values + length;
```

is implemented as:

```asm
    add     x1, x0, x1, lsl 3 
```

We are performing address arithmetic on `longs`. Each `long` is 8 bytes wide. `x1, lsl 3` means "before adding the value of `x1` to `x0`, multiple `x1` by 8." Eight is 2 raised to the power of 3. `lsl 3` means shift left by 3 bits ... shifting is a fast way of integer multiplication (and division) by powers of 2.

`Line 13` is the branch to the *bottom* of the loop where the decision code is written. We saw how this can save an instruction [here](../../for/for.md).

`Line 15` is the `ldr` instruction which performs not only the load (dereference) but also the *post increment* of the pointer.

```c
    sum += *(values++);                                                 /* 7 */
```

is implemented by both `lines 15` and `16` in the assembly language.

```asm
1:  ldr     x3, [x0], 8                                                 // 15 
    add     x2, x2, x3                                                  // 16 
```

----

So far we have restricted our discussion of registers almost exclusively to the `x` registers. These are 8 bytes wide and are used for both signed and unsigned integer operations.

![regs](./regs.png)

The above image is due to ARM and is found [here](https://documentation-service.arm.com/static/5fbd26f271eff94ef49c7018).
