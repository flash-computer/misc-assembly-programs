
;--------------------------------------Exports--------------------------------------;

global	_bsprintf

;--------------------------------------Exports--------------------------------------;

%macro	@LoadNextIntArgument	0	; Uses rdi as the argument counter
	push	rbx
	lea	rbx, [rbp+0x10+8*rdi]		; First argument
	cmp	rdi, 3
	jb	%%fetch
	add	rbx, 8
	%%fetch:
	mov	rax, [rbx]
	inc	rdi
	pop	rbx
%endmacro

;--------------------------------------Program--------------------------------------;

section	.text

	; Simplistic bounded sprintf clone. Only deals with integer, character and string values. For personal use only, does not comply with the C standard. posix-AMD64 calling convention ;
	; rax.uint64 charsWritten <- _bsprintf <- (rdi.uint64 buffer, rsi.uint64 bufLen, rdx.uint64 fmtStr, ..variadic#..) ;
		align	16
	_bsprintf:
		.entry:
		endbr64
		push	r9
		push	r8
		push	rcx				; Only for easy access to the arguments
		push	rbx
		push	rbp
		mov	rbp, rsp
		sub	rsp, 0x60

			%define	buffer	[rbp-8*1]	; 8 bytes
		mov	rbx, rdi
		mov	buffer, rdi
		xor	edi, edi			; Argument counter

			%define	bufLen	[rbp-8*2]	; 8 bytes
		mov	bufLen, rsi

			%define	fmtStr	[rbp-8*3]	; 8 bytes
		mov	fmtStr, rdx

			%define internalBuf	[rbp-8*3-1]
		mov	internalBuf, byte 0x00
			%define procControl	[rbp-0x60]

		.primaryLoop:
			xor	eax, eax
			cmp	rsi, 1
			je	.writeChar
			jb	.exit			; ...has the memory gone? Are you feeling numb?
			mov	al, [rdx]
			inc	rdx
			cmp	al, byte 0x25	; '%'
			je	.format
		.writeChar:
			mov	[rbx], al
			inc	rbx
			dec	rsi
			cmp	al, byte 0x0
			je	.exit
			jmp	.primaryLoop

			align	8
		.format.int:
			mov	procControl, word 0x2001	; Sets byte [rsp-0x81] to 0x20 and byte [rsp-0x82] to 00
			jmp	._decIntProc

			align	8
		.format.long.int:
			mov	procControl, word 0x4001	; 8A because once inside ._decIntProc, that would become rsp-0x82, which would just barely be inside the red zone
			jmp	._decIntProc

			align	8
		.format.char:
			@LoadNextIntArgument			; Wasting 7 bytes per character :gigachad:
			mov	[rbx], al
			inc	rbx
			dec	rsi
			jmp	.primaryLoop

		.format.str:
			@LoadNextIntArgument
			jmp	._copyStr

			align	8
		.format.long.uInt:
		mov	procControl, word 0x4000
		jmp	._decIntProc

			align	8
		.format.long.hex:				; These are distributed this way to appease the static bp algorithm by the way.
		mov	procControl, word 0x4004
		jmp	._binIntProc

			align	8
		.format.long.bin:
		mov	procControl, word 0x4001
		jmp	._binIntProc

			align	8
		.format.long.oct:
		mov	procControl, word 0x4003
		jmp	._binIntProc

			align	8
		.format:
			mov	al, [rdx]
			inc	rdx
			.format.cases:
				cmp	al, byte 0x00
				je	.writeChar
				cmp	al, byte 0x25		; '%'
				je	.writeChar
				cmp	al, byte 0x64		; 'd'
				je	.format.int
				cmp	al, byte 0x69		; 'i'
				je	.format.int
				cmp	al, byte 0x73		; 's'
				je	.format.str
				cmp	al, byte 0x63		; 'c'
				je	.format.char
				cmp	al, byte 0x75		; 'u'
				je	.format.uInt
				cmp	al, byte 0x78		; 'x'
				je	.format.hex
				cmp	al, byte 0x58		; 'X'
				je	.format.hex
				cmp	al, byte 0x62		; 'b'
				je	.format.bin
				cmp	al, byte 0x6f		; 'o'
				je	.format.oct
				cmp	al, byte 0x70		; 'p'
				je	.format.long.hex
				cmp	al, byte 0x6c		; 'l'
				jne	.primaryLoop
				.format.long:
					mov	al, [rdx]
					inc	rdx
					.format.long.cases:
						cmp	al, byte 0x00
						je	.writeChar
						cmp	al, byte 0x64		; 'ld'
						je	.format.long.int
						cmp	al, byte 0x69		; 'li'
						je	.format.long.int
						cmp	al, byte 0x75		; 'lu'
						je	.format.long.uInt
						cmp	al, byte 0x78		; 'lx'
						je	.format.long.hex
						cmp	al, byte 0x58		; 'lX'
						je	.format.long.hex
						cmp	al, byte 0x62		; 'lb'
						je	.format.long.bin
						cmp	al, byte 0x6f		; 'lo'
						je	.format.long.oct
						jmp	.primaryLoop

			align	8
		.format.hex:
		mov	procControl, word 0x2004	; These 2s are completely useless btw. If I passes 0x0004 or 0x0104 or 0x9004, it'd still work. Just here for style
		jmp	._binIntProc

			align	8
		.format.bin:
		mov	procControl, word 0x2001
		jmp	._binIntProc

			align	8
		.format.oct:
		mov	procControl, word 0x2003
		jmp	._binIntProc

			align	8
		.format.uInt:
		mov	procControl, word 0x2000
		jmp	._decIntProc

		; Copy routine, just copies string from to target buffer until null byte encountered or buffer runs out of space ;
		._copyStr:
			mov	r11, rax
			._copyStr.loop:
				mov	al, [r11]
				inc	r11
				cmp	al, 0
				je	.primaryLoop
				cmp	rsi, 1
				je	._copyStr.end
				mov	[rbx], al
				inc	rbx
				dec	rsi
				jmp	._copyStr.loop
			._copyStr.end:
				mov	[rbx], byte 0x00	; When you can't even say, my name....
				dec	rsi
				jmp	.exit

		; Binary Processing Routine, processes numbers with a exponent of two radix, bit 6 of al must be 1 , procControl[0] <= 8 ;
				align	16
		._binIntProc:
			push	rbx
			push	rdx
			mov	r11, rcx

			xor	ebx, ebx
			xor	edx, edx

			mov	r12w, word procControl
			mov	bx, r12w
			and	bx, 0x4000
			xor	bx, 0x4000		; I love whoever wrote this. Such a sharp little shithead, this guy. I bet he's a real kicker to hang around with an totally not the greatest asshole alive :clueless:
			shr	bx, 0x9
			not	rdx
			mov	cl, bl
			shr	rdx, cl

			xor	ecx, ecx	; clear r11
			and	al, 0x60	; Alphabet mask
			mov	cl, al
			shl	cx, 0x8

			@LoadNextIntArgument
			and	rax, rdx		; And that my friend, is how you minimize branches.

			xor	ebx, ebx
			xor	edx, edx
			mov	bl, r12b

			._binIntProc.loadMask:
			shl	dx, 0x1
			or	dx, 0x1
			dec	bl
			jnz	._binIntProc.loadMask	; I mean, it works? Surely you can afford running a short shitty loop like this.

			mov	cl, r12b

			mov	bx, r12w
			lea	r12, internalBuf

			._binIntProc.loop:
				dec	r12
				mov	bl, al					; ALERT: bh still contains a non zero value. If the code has to change with a use for bh, keep that in mind
				and	bl, dl
					._binIntProc.write:
					or	bl, 0x30
					cmp	bl, 0x3a
					jl	._binIntProc.write.commit	; div v/s jl. Which one of these is ultimate faster between this and the decimal routine, I wonder?
					and	bl, 0x7
					dec	bl
					or	bl, ch
					._binIntProc.write.commit:
					mov	[r12], byte bl
				shr	rax, cl
				jnz	._binIntProc.loop

		._binIntProc.exit:
			mov	rax, r12
			mov	rcx, r11
			pop	rdx
			pop	rbx
			jmp	._copyStr
		._binIntProc.ENDSUB:


		; Decimal Processing Routine, processes numbers with radix 10 ;
			align	16
		._decIntProc:
			push	rdx
			mov	r11, rcx

			mov	cx, word procControl
			@LoadNextIntArgument
			test	rcx, 0x1
			jnz	._decIntProc.int
			and	rcx, 0x4000
			shr	cx, 0x9
			xor	r12d, r12d
			not	r12d
			shr	r12, cl
			and	rax, r12

			._decIntProc.init:
			lea	r12, internalBuf
			mov	rcx, 0xa

			._decIntProc.loop:
				dec	r12
				xor	edx, edx
				div	rcx
				or	dl, 0x30		; This used to be 'al, 0x30', I have poor documentation reading skillz, and even worse memory.
				mov	[r12], byte dl
				cmp	rax, 0
				jnz	._decIntProc.loop
		._decIntProc.fin:
			mov	cx, word procControl
			test	cx, 0x10
			jz	._decIntProc.exit
			dec	r12
			mov	[r12], byte 0x2D
		._decIntProc.exit:
			mov	rcx, r11
			mov	rax, r12
			pop	rdx
			jmp	._copyStr

			._decIntProc.int:
				test	rcx, 0x4000
				jnz	._decIntProc.long
				xor	eax, 0
				cmp	eax, 0
				jge	._decIntProc.init	; And this, my friend, is how they come back to strangle you
				mov	procControl, byte 0x11
				neg	eax
				jmp	._decIntProc.init

			._decIntProc.long:
				cmp	rax, 0
				jge	._decIntProc.init
				mov	procControl, byte 0x11
				neg	rax
				jmp	._decIntProc.init
		._decIntProc.ENDSUB:

			align	16
		.exit:
		sub	rsi, bufLen
		mov	rax, rsi
		not	rax			; rax = bufferLen - rsi - 1
			%undef	internalBuf
		mov	rdx, fmtStr
			%undef	fmtStr
		mov	rsi, bufLen
			%undef	bufLen
		mov	rdi, buffer
			%undef	buffer
		mov	rsp, rbp
		pop	rbp
		pop	rbx
		add	rsp, 0x18
		ret
		.ENDFN:

