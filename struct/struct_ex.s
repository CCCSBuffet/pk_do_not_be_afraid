        .global main
        .align  2
        .text

        .equ    _A, 0
        .equ    _B, 8
        .equ    _C, 12
        .equ    _D, 14
        .equ    _Z, 16

main:	
        stp     x29, x30, [sp, -16]!
        str     x20, [sp, -16]!
        sub     sp, sp, 16
        mov     x20, sp
        
        mov     x0, x20
        mov     w1, wzr
        mov     x2, _Z
        bl      memset

        ldr     x0, =fmt
        ldr     x1, [x20, _A]
        ldr     w2, [x20, _B]
        ldrh    w3, [x20, _C]
        ldrb    w4, [x20, _D]
        bl      printf

        add     sp, sp, 16
        ldr     x20, [sp], 16
        ldp     x29, x30, [sp], 16
        mov     x0, xzr
        ret

        .data
fmt:    .asciz  "a: %ld b: %d c: %hd d: %d\n"
        .end
