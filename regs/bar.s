	.arch armv8-a
	.file	"bar.c"
	.text
	.align	2
	.p2align 3,,7
	.global	Foo
	.type	Foo, %function
Foo:
.LFB0:
	.cfi_startproc
	and	w1, w1, 255
	add	w0, w1, w0, uxtb
	ret
	.cfi_endproc
.LFE0:
	.size	Foo, .-Foo
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
