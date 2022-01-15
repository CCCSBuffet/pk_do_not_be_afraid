        .global	TestAsm
        .data
        .struct 0
foo.x:  .skip   4
foo.y:  .skip   4

        .text
TestAsm:
        mov     w1, 99
        str     w1, [x0, foo.x]
        str     w1, [x0, foo.y]
        ret

        .end
