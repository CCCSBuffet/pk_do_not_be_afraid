        .global main
        .equ    O_RDONLY, 0
        .text
        .align  2

main:   stp     x29, x30, [sp, -16]!
        str     x20, [sp, -16]!         // x20 used to buffer FD

        ldr     x0, =fname
        mov     w1, O_RDONLY
        bl      open                    // use stub to make system call
        cmp     w0, wzr                 // a bad return is negative
        blt     90f                     // if bad, skip over the good

        mov     w20, w0                 // preserve FD
        ldr     x0, =osucc              // print a success message
        bl      puts
        
        mov     w0, w20                 // restore FD
        bl      close                   // use stub to make system call
        b       99f                     // skip over else code

90:     ldr     x0, =ofail              // print an error message
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
