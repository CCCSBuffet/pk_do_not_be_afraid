	.arch armv8-a
	.file	"static01.c"
	.text
	.local	a_static_int
	.comm	a_static_int,4,4
	.data
	.align	2
	.type	an_initialized_static_int, %object
	.size	an_initialized_static_int, 4
an_initialized_static_int:
	.word	255
	.comm	a_global_int,4,4
	.global	an_initialized_global_int
	.align	2
	.type	an_initialized_global_int, %object
	.size	an_initialized_global_int, 4
an_initialized_global_int:
	.word	170
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
