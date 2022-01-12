# `Structs` (and to Some Degree `Classes`) in Assembly Language

A `struct` is a bundle of data members laid out consecutively in RAM with the restriction that each memory begins on an address that is divisible by the member's length (its *natural alignment*). This can result in internal fragmentation or *gaps* between the members.

The total size of a struct may be rounded upward so that the first member will land on its natural alignment if two `structs` of the same type were placed next to each other as in, for example, an array.

Here are some examples:

![examples](./struct01.png)

Looking at `Foo`, one might expect `a_64_bit_int` to start at offset 4. After all, `a_32_bit_int` is 4 bytes.

Here is the output produced by the above program. You'll see some unexpected values:

![output](./struct02.png)

`Line 4` shows `a_64_bit_int` starts at offset 8 rather than 4. This is because the natural alignment of an 8 byte value is on addresses that are divisible by 8.

## The First Rule of Working with `Structs`

The first rules of working with structs is that you must be sure of the offset of each data member from the beginning of the `struct`. You might need to go so far as writing a program to dump offsets just as we did above.

## After That, It's Easy

Once you are certain of the offsets of each data member, using structs in assembly language becomes quite straight forward. A data member can be found at the address corresponding to the data member's offset from the beginning of the struct.

## First Example

Let's implement this program:

![example](./struct03.png)

The `struct` has four data members in each of the common integer sizes. `Line 14` allocates a `struct` as a local variable. We will see that local variables are stored on the *stack*.

`Line 15` uses `memset()` to initialize the entire `struct` to zeros. The first argument specifies the base address of the `struct`. The second argument is interpreted as a single byte containing the value to replicate into memory. The third argument is the number of bytes to replicate.

`Line 16` is a `printf()` which prints each of the data members in the struct. In case you are not familiar with `printf()`, its first argument is a template string which tells `printf()` the type of each argument to be printed. 

* `%ld` says put a `long` here.
* `%d` says put an `int` here.
* `%hd` says put a `short` here.

The final `char` will be cast as an `int`.

Here is an assembly language version of the same program.

![example](./struct04.png)

`Lines 1` to `Line 10` contain assembler *directives*. These are commands to the assembler, not code to be assembled.

`Line 1` instructs the assembler to expose the symbol `main` to the linker. Without this directive, the linker will not be able to find `main` so the program will not link.

`Line 2` instructs the assembler to emit whatever is next at an even address.

`Line 3` says that what comes next is code.

`Line 5` through `line 9` are equivalent to `#define` in `C` and `C++`.

These lines are giving symbolic names to what otherwise would be magic numbers. In this case, the first 4 are the offsets of each data member in the `struct` and the last is the size of the `struct`.

`Line 12` uses the *store pair* of registers to memory. `sp` stands for *stack pointer*. This instruction is backing up the contents of registers `x29` and `x30` on the stack.

`Line 12` is essentially this made up `C` code:

```c
// assume long * sp;
*(--sp) = x30;
*(--sp) = x29;
```

We know this is a decrement of the stack pointer because of the value 16 is negative. We know this is a *predecrement* because of the `!` syntax.

We know this causes a dereference because of the `[` and `]`.

We use the value `16` because each `x` register is 8 bytes long and we're copying a pair of them to memory.

`Line 13` is very similar except instead of copying a pair of registers to memory, we're copying just one (`x20`). Notice though that we're still predecrementing the stack pointer by 16 and not 8. 

**This is because in the AARCH64 ISA, the stack pointer must be moved in multiples of 16.**

We aren't going to discuss why these registers are being backed up at this time - but this will be described in a future chapter. For now, suffice to say that the registers we're backup up on the stack will be restored from the stack on `Line 30` and `31`. Notice the `ldr` and `ldp` instructions appear in the mirror / reverse order for the `stp` and `str` instructions.

`Line 14` is making space for `Foo` which coincidentally enough is done on `Line 14` of the `C` code.

`Line 15` copies the current value of `sp` to `x20`. `x20` was backed up on `line 13`. We will use `x20` as the *base address* of the `struct`. All dereferences will resolve to offsets relative to this base-address.

`Line 17` through `line 20` implement `line 15` of the `C` code.

Recall that the first 8 registers are used to pass the first 8 arguments to function calls. They are used starting at register 0 in increasing order from left to right in the higher level language.

`Line 17` causes the address of `foo` on the stack to be the first argument to `memset()`. Being an address, it must be passed in an `x` register.

`Line 18` causes 0 to be the second argument to `memset()`. Because it is the second argument, it goes in the 1 register. Because the second argument of `memset()` is defined as an `int`, the `w` variant of the register is used.

`x` registers are 8 bytes wide - these are used for longs and addresses.

`w` registers are 4 bytes wide and are used for `chars`, `shorts` and `ints`.

Note that `xn` and `wn` are the same registers - the use of `x` versus `w` tells the assembler what exact machine code to generate. We tell the assembler to distinguish between `chars`, `shorts` and `ints` using instruction mnemonics.

`Line 19` puts the length of `foo` into the 2 register. We use `x` because `memset()` defines its third argument as a `size_t` which is an `unsigned long`.

`Line 20` is the function call to `memset()`.

`Lines 22` through `27` set up and call `printf()`.

`Line 22` is worth a deep dive.

On `line 36` you'll find the template string to be passed to `printf()`. The string's address is `fmt` - that is, the label allows you to refer to the string somewhere in the code. The string is a zero terminated array of bytes. The `z` in the assembler directive `.asciz` is what causes the zero termination.

`Line 22` is interesting because the `=` preceding `fmt` causes the assembler to perform some trickery. Addresses are 8 bytes wide (64 bits). **BUT** all AARCH64 instructions are 4 bytes wide (32 bits). How can you specify an 8 byte value by fitting it in an instruction that is only 4 bytes wide? Answer: The `=` causes the assembler to do the work behind the scenes to divide the address specified by `fmt` into two parts. The first part is the address of the `ldr` instruction itself. The second part is the offset of the string relative to the instruction provided the linker places the string within +/- 4 mebibytes of the instruction.

The net of this is that `x0` will get the address of the template string.

`x0` is used because it is the first parameter to `printf()`. An `x` register is used because addresses are 8 bytes wide.

`Line 23` uses `x20` as a base address. It adds `_A` to that address (on `line 5` we set `_A` to be equivalent to `0`) forming a complete address. The 8 byte memory location specified by the complete address is loaded into `x1`. We use an `x` register because the memory location being dereferences is a `long`. We use `x1` because this is the second parameter to `printf()`.

`Line 24` is similar except the value being dereferenced is at a different offset from the base address and also, it is a 4 byte `int` so a `w` register variant is used instead of `x`.

`Line 25` is similar except the value being dereferenced is at a different offset from the base address and also, it is a 2 byte `short`. `w` registers are used for `int`, `short` and `char`. We tell the assembler which of these we want by varying the `ldr` mnemonic. On `line 25` we use `ldrh` where the `h` is for *half*. A `short` is half the width of an `int`.

`Line 26` is similar again except we're using a different offset from the base register and we're using `ldrb` to specify that we want to dereference a single `b`yte.

`Line 27` is the function call to `printf()`.

`Line 29` pops the local variable `foo` off the stack. Remember we have a copy of the older value of the stack pointer in `x20`. Don't use it anymore! Once the stack pointer has been popped, consider the data that was in the popped area to be gone!

`Line 30` restores the value of `x20` to what it was when it was backed up on `line 13`. It also pops the stack by 16 bytes. This is a post increment. We know it's an increment because 16 is positive. Recall that the stack must be manipulated in multiples of 16 even though only one register is being loaded.

`Line 31` is similar except a `p`air of registers are being restored. This undoes `line 12`.

`Line 32` sets us up to return 0 from `main()`.

`Line 33` is the return from `main()`.

`Line 35` is similar to `line 3` except it says that what comes next is data, not instructions. It is important to keep data and instructions segregated so that the instruction area of memory can be marked read-only. This prevents self-modifying code. This is a good thing because permitting self-modifying code would allow all kinds of exploits for malware. This is a bad thing because writing self-modifying code was *fun*.

`Line 37` is an assembler directive that says anything found in the source file beyond this should be considered an error. It is optional.

## Relationship to `Classes`

`C++` `classes` are `structs` with some added compiler magic. Poof! Mind blown.

A `class` method is passed a hidden `this` pointer which is nothing more than the base address of the data members. So, accessing all data members in a `class` follows the exact same principles as with `struct`.

## Summary

`Structs` are accessed via offsets from the base address of the `struct` itself.

*This is how arrays also work, by the way.*
