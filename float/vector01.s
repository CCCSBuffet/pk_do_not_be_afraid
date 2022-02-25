        .text
        .align  4
        .global main

//  This example demonstrates 4 concepts.
//  1. Loading 4 floats from memory.
//  2. A NEON (SIMD) operation on all four simultaneously.
//  3. Up-conversion from single to double precision.
//  4. Passing floats to a "C" function (printf in this case)

main:   str     x30, [sp, -16]!
        ldr     x7, =fa                     // get base address of array
        ldr     q0, [x7], 16                // load up all 4 fa
        ldr     q1, [x7], 16                // load up all 4 fb
        fadd    v7.4s, v0.4s, v1.4s         // NEON add of all 4 floats
        ldr     x0, =fmt

        // printf only prints double precision floats.  After extracting
        // a single precision float from the vector register, it must be
        // converted to double precision - fortunately, this can be done
        // in place. In C, the compiler performs the cast.

        // NOTE! - NOTE! - NOTE! - NOTE! - NOTE! - NOTE! - NOTE! - NOTE!
        // Notice the first float parameter  is going  in the 0 register
        // not the 1  register which you  might think  would be the case
        // since the  first  float  parameter is the SECOND parameter to
        // printf. This is true in general - sequence of float registers
        // starts counting at 0 THEN increases as you would expect.

        mov     s0, v7.s[0]                 // extract 1st float
        fcvt    d0, s0                      // cast to double
        mov     s1, v7.s[1]                 // same for 2nd float
        fcvt    d1, s1                      // etc
        mov     s2, v7.s[2]                 //
        fcvt    d2, s2                      //
        mov     s3, v7.s[3]                 //
        fcvt    d3, s3                      //
        bl      printf                      // print

        ldr     x30, [sp], 16
        mov     w0, wzr
        ret

        .data
fa:     .single 1.0, 2.0, 3.0, 4.0          // array of 4 floats used as srca
fb:     .single 100.0, 101.0, 102.0, 103.0  // array of 4 floats used as srcb

        .section    .rodata
fmt:    .asciz      "%f %f %f %f\n"

        .end
