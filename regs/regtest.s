	.arch armv8-a
	.file	"regtest.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"%ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n"
	.text
	.align	2
	.global	Foo
	.type	Foo, %function
Foo:
.LFB23:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, 32]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 32
	ldr	x8, [sp, 56]
	str	x8, [sp, 24]
	ldr	x8, [sp, 48]
	str	x8, [sp, 16]
	str	x7, [sp, 8]
	str	x6, [sp]
	mov	x7, x5
	mov	x6, x4
	mov	x5, x3
	mov	x4, x2
	mov	x3, x1
	mov	x2, x0
	adrp	x1, .LC0
	add	x1, x1, :lo12:.LC0
	mov	w0, 1
	bl	__printf_chk
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE23:
	.size	Foo, .-Foo
	.align	2
	.global	Bar
	.type	Bar, %function
Bar:
.LFB24:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	ldr	x2, [x1, 8]
	ldr	x1, [x1]
	bl	Bum
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE24:
	.size	Bar, .-Bar
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
