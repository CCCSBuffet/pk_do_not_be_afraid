# Registers Versus Variables

It is important that you become familiar with all the different kinds and uses of registers available on the AARCH64 ISA. We'll dive into this soon. But first, it is vitally important to expand upon your notion of "variable."

## Why Registers

In most (all?) of the programming you may have done prior to learning assembly language, you've taken it for granted that variables are located somewhere in RAM. This has been a convenient fiction. In reality, virtually all interaction with a variable takes place in a register rather than in RAM. Modern processors that are not slaves to backwards compatibility have fewer and fewer instructions that operate directly upon data in RAM. This is largely because of the stupendous difference in speed at which a processor can access its registers versus the speed at which a processor can access memory.

The following two images are from the [Formulus Black Blog](https://formulusblack.com/blog/compute-performance-distance-of-data-as-a-measure-of-latency/) and are quite informative.

This image relates typical latency (delay) in gaining access to data is various places.

![Latency](./latency.png)

This says that if we liken accessing a register (which can be done at *least* once per CPU Clock Cycle) to one second, accessing memory would be like a 3.5 to 5.5 minute wait.

In the next image, the relative latencies within a computer are expressed in a different way: What is the *effective distance* of a device from the CPU expressed in terms of the *speed of light.* Here, registers can be tought of as being less than 4 inches away from the CPU. Main memory, on the other hand, would be 70 to 100 feet away.

![Latency 2](./latency2.png)

Resist the urge to cling tightly to the idea of data being only found in RAM. In order to manipulate data, they must be loaded into registers. **YOU ARE THE HUMAN!** YOU can arrange for the data you need most to be resident in registers rather than in RAM. In fact, ideally, you can organize your code and algorithms to minimize the dependence upon RAM and in some cases, you can write whole sophisticated programs using RAM for little more than a place to store string literals.

## Review of Retrieving Data from RAM

The instructions most commonly used to retrieve information from memory are `ldr` and `ldp`. The characters `ld` in these mnemonics bring to mind `load`. `ldr` is "load a register" while `ldp` is "load a pair of registers".

Both of these instructions possess many variations, only a few of which will be described here. In common to all variations of the `ldr` and `ldp` instructions are the notions of *where to fetch from* and *where to store what's been fetched*.

Like many AARCH64 instructions, the most basic form of the load instructions are read right to left as in:

```asm
    ldr    x0, [x1]
```

which means "go to the location in RAM specified by `x1` and load what's there into `x0`."

To facilitate dereferencing `structs` and for accessing `arrays`, an offset may be specified. There are significant restrictions placed on the offset because the entire instruction (including the encoding of the offset) must fit within a constant 4 byte width of all AARCH64 instructions.

Here is text from an [ARM manual](https://developer.arm.com/documentation/dui0801/h/A64-Data-Transfer-Instructions/LDR--immediate-):

```text
LDR Xt, [Xn|SP], #simm ; 64-bit general registers, Post-index
LDR Xt, [Xn|SP, #simm]! ; 64-bit general registers, Pre-index
LDR Xt, [Xn|SP{, #pimm}] ; 64-bit general registers
```

The `simm` and `pimm` text refers to various restricted offsets.

From the same manual page:

| Abbreviation | Meaning |
| ------------ | ------- |
| simm | Is the signed immediate byte offset, in the range -256 to 255. |
| pimm | Depends on the instruction variant |

32-bit general registers
Is the optional positive immediate byte offset, a multiple of 4 in the range 0 to 16380, defaulting to 0.
64-bit general registers
Is the optional positive immediate byte offset, a multiple of 8 in the range 0 to 32760, defaulting to 0.|

THIS IS NOT FINISHED.

----

So far we have restricted our discussion of registers almost exclusively to the `x` registers. These are 8 bytes wide and are used for both signed and unsigned integer operations.

![regs](./regs.png)

The above image is due to ARM and is found [here](https://documentation-service.arm.com/static/5fbd26f271eff94ef49c7018).
