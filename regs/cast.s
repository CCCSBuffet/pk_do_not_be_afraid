	.arch armv8-a
	.file	"cast.c"
// GNU C17 (Ubuntu 9.3.0-17ubuntu1~20.04) version 9.3.0 (aarch64-linux-gnu)
//	compiled by GNU C version 9.3.0, GMP version 6.2.0, MPFR version 4.0.2, MPC version 1.1.0, isl version isl-0.22.1-GMP

// GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
// options passed:  -imultiarch aarch64-linux-gnu cast.c -mlittle-endian
// -mabi=lp64 -fverbose-asm -fasynchronous-unwind-tables
// -fstack-protector-strong -Wformat -Wformat-security
// -fstack-clash-protection
// options enabled:  -fPIC -fPIE -faggressive-loop-optimizations
// -fassume-phsa -fasynchronous-unwind-tables -fauto-inc-dec -fcommon
// -fdelete-null-pointer-checks -fdwarf2-cfi-asm -fearly-inlining
// -feliminate-unused-debug-types -ffp-int-builtin-inexact -ffunction-cse
// -fgcse-lm -fgnu-runtime -fgnu-unique -fident -finline-atomics
// -fipa-stack-alignment -fira-hoist-pressure -fira-share-save-slots
// -fira-share-spill-slots -fivopts -fkeep-static-consts
// -fleading-underscore -flifetime-dse -flto-odr-type-merging -fmath-errno
// -fmerge-debug-strings -fomit-frame-pointer -fpeephole -fplt
// -fprefetch-loop-arrays -freg-struct-return
// -fsched-critical-path-heuristic -fsched-dep-count-heuristic
// -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
// -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
// -fsched-stalled-insns-dep -fschedule-fusion -fsemantic-interposition
// -fshow-column -fshrink-wrap-separate -fsigned-zeros
// -fsplit-ivs-in-unroller -fssa-backprop -fstack-clash-protection
// -fstack-protector-strong -fstdarg-opt -fstrict-volatile-bitfields
// -fsync-libcalls -ftrapping-math -ftree-cselim -ftree-forwprop
// -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
// -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop
// -ftree-reassoc -ftree-scev-cprop -funit-at-a-time -funwind-tables
// -fverbose-asm -fzero-initialized-in-bss -mfix-cortex-a53-835769
// -mfix-cortex-a53-843419 -mglibc -mlittle-endian
// -momit-leaf-frame-pointer -mpc-relative-literal-loads

	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #16	//,,
	.cfi_def_cfa_offset 16
// cast.c:5:     char c = 1;
	mov	w0, 1	// tmp97,
	strb	w0, [sp, 1]	// tmp97, c
// cast.c:6:     short s = 2;
	mov	w0, 2	// tmp98,
	strh	w0, [sp, 2]	// tmp98, s
// cast.c:7:     int i = 4;
	mov	w0, 4	// tmp99,
	str	w0, [sp, 4]	// tmp99, i
// cast.c:8:     long l = 8;
	mov	x0, 8	// tmp100,
	str	x0, [sp, 8]	// tmp100, l
// cast.c:10:     s += (short) c;
	ldrb	w0, [sp, 1]	// tmp101, c
	and	w1, w0, 65535	// _1, tmp101
	ldrh	w0, [sp, 2]	// s.0_2, s
	add	w0, w1, w0	// tmp102, _1, s.0_2
	and	w0, w0, 65535	// _3, tmp102
	strh	w0, [sp, 2]	// tmp103, s
// cast.c:11:     i += (int) s;
	ldrsh	w0, [sp, 2]	// _4, s
// cast.c:11:     i += (int) s;
	ldr	w1, [sp, 4]	// tmp105, i
	add	w0, w1, w0	// tmp104, tmp105, _4
	str	w0, [sp, 4]	// tmp104, i
// cast.c:12:     l += (long) i;
	ldrsw	x0, [sp, 4]	// _5, i
// cast.c:12:     l += (long) i;
	ldr	x1, [sp, 8]	// tmp107, l
	add	x0, x1, x0	// tmp106, tmp107, _5
	str	x0, [sp, 8]	// tmp106, l
// cast.c:14:     return 0;
	mov	w0, 0	// _13,
// cast.c:15: }
	add	sp, sp, 16	//,,
	.cfi_def_cfa_offset 0
	ret	
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
