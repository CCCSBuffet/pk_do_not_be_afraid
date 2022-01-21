# Gentle Introduction to ARM V8 Assembly Language

## Attribution

This work is created by Perry Kivolowitz, Professor and Chair of Computer Science at Carthage College. It is copyright © 2021 and may be freely
shared for educational purposes.

## Overview

These documents are designed for readers who are familiar with `C` or `C++`. Each
document bridges the reader's understanding of the higher level language to the
corresponding assembly language.

The `AARCH64` ISA is used. That is, the assembly language used is that of the 64 bit ARM processor.

Assembly language text books typically cover the MIPS ISA because it has been around forever and isn't x86. We consider the MIPS processor as having 1.5 feet in the dustbin of history.

A few texts cover the x86. We consider the x86 an abominable mass of poodles jumping through hoops to allow the modern to coexist with the ancient. Poodles jumping through hoops is best viewed on youtube, not in a text book.

The ARM V8 ISA (AARCH64) is current *and* reasonable.

Linux `calling conventions` are used. That is, the assembly language is designed to be run on Linux machines. Even though Macintosh M1 machines are `AARCH64`, the conventions they use are specific to the Mac - big surprise.

## Part 1 - Bridging Common Language Constructs

Some might argue this makes a strange choice of initial chapters. To many, Part 2's material will make more sense to come first. Our choice of putting this material first is born from the desire to bridge the higher level language concepts you already know to the underlying technology. **Then** we'll go into details hopefully having broken through the common fear of assembly language.

| Chapter | Description |
| ------- | ----------- |
| [Hello World](./hello_world/helloworld.md) | Demonstrates how close `C` is to assembly language |
| [if](./if/if.md) | Demonstrates implementation of both `if` and `if` / `else` |
| [while](./while/while.md) | Demonstrates implementation of a `while` loop |
| [for](./for/for.md) | Demonstrates implementation of a `for` loop |
| [Function Calls and Returns](./func/func.md) | Demonstrates implementation of function calls and returns |
| [Structs](./struct/structs.md) | Demonstrates use of `struct` and by extension, `class` |
| [Braces](./braces/braces.md) | Focuses on how braces translate into assembly language |
| [Interop](./interop/interop.md) | Calling assembly language from C and C++ |
| [`static` and Global Variables](./static/static.md) | How `static` variables are stored |

## Part 2 - Details on Registers and their Usage

All the action happens in the registers. Bottom line is that the variables you are accustomed to using in a higher level language are artificial constructs layered on top of the processor's registers. Understanding this is key to understanding assembly language programming.

| Chapter | Description |
| ------- | ----------- |
| [Concept of Registers](./regs/regs.md) | What are registers? |
| [Registers Versus Variables](./regs/regvar.md) | Thinking differently about your variables |
| [What Registers Must be Backed Up and Why](./regs/backup.md) | Constraints placed on register use |
| [`ldr`](./regs/ldr.md) | Review and amplification of the `ldr` instructions and by extension, the `str` instructions - with a number of programming examples |
| [Register Widths](./regs/widths.md) | Demonstrated with examples and a `gdb` session plus a discussion on *endianness* |
| Floating Point Registers | No written |
| Scratch Registers | Not written |
| Push and Pop of Registers | Not written |
