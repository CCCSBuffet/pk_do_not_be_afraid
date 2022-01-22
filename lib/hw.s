        .global main
        .text
        .align  2

main:   stp     x29, x30, [sp, -16]!
        ldr     x0, =s 
        bl      printf
        ldp     x29, x30, [sp], 16
        mov     x0, xzr
        ret

        .section    .rodata
s:      .asciz      "hello, world\n"
        .end
