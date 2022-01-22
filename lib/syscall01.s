        .global main
        .equ    O_RDONLY, 0
        .text
        .align  2

main:   stp     x29, x30, [sp, -16]!
        str     x20, [sp, -16]!

        ldr     x0, =fname
        mov     w1, O_RDONLY
        bl      open
        cmp     w0, wzr
        blt     90f

        mov     w20, w0
        ldr     x0, =osucc
        bl      puts
        
        mov     w0, w20
        bl      close
        b       99f

90:     ldr     x0, =ofail
        bl      perror

99:     ldr     x20, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, xzr
        ret

        .section    .rodata
fname:  .asciz      "syscall01.s"
ofail:  .asciz      "open failed"
osucc:  .asciz      "open succeeded"

        .end
