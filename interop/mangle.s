	.arch armv8-a
	.file	"mangle.cpp"
	.text
	.align	2
	.global	_Z3Barv
	.type	_Z3Barv, %function
_Z3Barv:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	w0, 7
	bl	_Z3Fooi
	fmov	d0, 7.0e+0
	bl	_Z3Food
	nop
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	_Z3Barv, .-_Z3Barv
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
