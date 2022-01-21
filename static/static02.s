        //
        // .bss area is initialized  to 0 when the program begins
        // running. The section does not occupy space in the exe.
        //

        .bss
array:  .space  32 
foo:    .word   0, 0, 0, 0

        //
        // .rodata stands for read-only data - i.e. consts.
        //

        .section    .rodata
s1:     .asciz      "Ghis is a string"

        //
        // .data is for all other data defined at compile time.
        //

        .data
s2:     .asciz      "Ghis is a string"

        .text
        .global     main

main:   // Attempt to correct s2.
        mov         w0, 'T'
        ldr         x1, =s2
        strb        w0, [x1]
        // Attempt to correct s1.
        ldr         x1, =s1
        strb        w0, [x1]
        ret

        .end
