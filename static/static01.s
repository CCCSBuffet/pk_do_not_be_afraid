	.arch armv8-a
	.file	"static01.c"
	.text
	.data
	.align	2
	.type	a_static_int, %object
	.size	a_static_int, 4
a_static_int:
	.word	3
	.align	2
	.type	an_initialized_static_int, %object
	.size	an_initialized_static_int, 4
an_initialized_static_int:
	.word	255
	.comm	filby,128,8
	.comm	a_global_int,4,4
	.global	an_initialized_global_int
	.align	2
	.type	an_initialized_global_int, %object
	.size	an_initialized_global_int, 4
an_initialized_global_int:
	.word	170
	.global	foo
	.section	.rodata
	.align	2
	.type	foo, %object
	.size	foo, 4
foo:
	.word	1
	.align	2
	.type	far, %object
	.size	far, 4
far:
	.word	2
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
