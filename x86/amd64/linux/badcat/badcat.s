;--------------------------------------Exports--------------------------------------;

global	_main

;--------------------------------------Imports--------------------------------------;

%include "syslinux.s"	; includes the various macros you see in the file too

;--------------------------------------Program--------------------------------------;

section	.data
	dg0:	; Messages Data Group
		.msg0:	db 'Please specify atleast one file.',0xA,0x0
		.msg0.len:	equ ($-.msg0 - 1)
		.msg1:	db 'A fatal error has occured. Please be aware this primitive program has no options. The only arguments must be valid file names.',0xA,0x0
		.msg1.len:	equ ($-.msg1 - 1)

section	.bss
	printBuf:	resb 0x400
	printBuf.len:	equ $-printBuf

section	.text
		align	16	; Read from file until buffer is full or an EOR or a fatal error is encountered
	_main:
		endbr64
		xor	eax, eax
		mov	ax, sp
		and	ax, 0xF
		neg	ax
		add	ax, 0x10
		and	ax, 0xF
		sub	sp, ax
		push	rax
		push	rbp
		mov	rbp, rsp	; Ensure 16B-alignment and push offset and base pointer

		mov	rdi, [rbp+2*8]	; Number of arguments including the number of arguments
		cmp	rdi, 1
		jbe	.nofile
		mov	rdx, rdi
		lea	rsi, [rbp+3*8]	; Pointer to an array of pointers to the strings which contain - 0.the pwd, then the arguments
		mov	ecx, 1		; Skip the pwd, which is the first pointer at rsi

		.fileLoop:
		mov	rdi, [rsi+rcx*8]
		mov	rbx, rcx		; 15 Minutes of my life wasted (after wasting an hour on figuring out the cli argument syntax) before learning that rcx and r11 are destroyed by syscalls, and should be saved. I'm keeping rcx instead of using rbx, which would be saner, so that I'm reminded of this fact everytime I read this. This is the C64 Kernal calls situation once again and I was too dumb to learn from that.
		call	_readFile		; Remember to save rcx if readFile ever changes to reflect that
		mov	rcx, rbx
		inc	rcx
		cmp	rcx, rdx
		jl	.fileLoop
		xor	eax, eax
		jmp	.exit			; Program Successful

		align	8
		.nofile:
		mov	rdx, dg0.msg0.len
		mov	rsi, dg0.msg0
		mov	edi, 2			; STDERR
		mov	eax, sys_write		; 0x1
		syscall
		xor	eax, eax		; No file isn't an error
		jmp	.exit

		align	16
		.fatalerror:
		mov	rcx, rax
		mov	rdx, dg0.msg1.len
		mov	rsi, dg0.msg1
		mov	edi, 2
		mov	eax, sys_write		; 0x1
		syscall				; We exit regardless of whether this fails or not
		mov	rax, rcx
		jmp	.exit			; Yes, no error handling/reporting for now and yes we sacrifice an additional instruction here so every other jump to exit is a little better with alignment

		align	16
		.exit:
		mov	rsp, rbp
		pop	rbp
		mov	di, ax		; Exit status is just a single byte
		pop	rax
		add	sp, ax
		mov	eax, sys_exit	; 0x3c - Load return value in rax before jumping to .exit
		syscall

;-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-;

	; _readFile
		align	16
	_readFile:				; Assumes (rsp & 0xF == 0x8) due to the return address
		endbr64
		push	rdi
		push	rsi
		push	rdx			; Only argument registers that are used in the function are saved. Rest are calee saved.
		push	rbp
		mov	rbp, rsp
		sub	rsp, 0x8		; Allocate space for fd and align

		.open:
			xor	esi, esi	; O_RDONLY (0)
			mov	eax, sys_open	; 0x2
			syscall
			ScRetCheck	.fatalerror

		mov	[rbp-8*1], rax

		.read:					; I fucked up. I fucked up. I fucked up. I though the EGAIN error meant you had a partial read and had to continue. That's why you read documentation properly people. The previous program is wrong.
			mov	edi, eax
			xor	edx, edx
			jmp	.read.loop		; One jump to avoid many, that's the philosophy here. Poingant.

			align	8
			.read.error:
			cmp	rax, EINTR		; -4
			jne	.exit			; two branches in a row on an error. Holy Shit!!

			align	8
			.read.loop:
			mov	rsi, printBuf
			mov	rdx, printBuf.len
			xor	eax, eax		; sys_read (0)
			syscall
			ScRetCheck	.read.error

			cmp	rax, 0
			je	.close			; Read Complete
			cmp	rax, rdx
			jb	.read.partial
			.read.bufferFull:
			mov	edi, 1
			mov	eax, 1			; sys_write
			syscall

			mov	rdi, [rbp-8*1]
			ScRetCheck	.fatalerror
			jmp	.read.loop

			align	8
			.read.partial.done:
			sub	rsi, printBuf		; Wtf I was subtracting 'printBuf.len' from rsi to load into rax. Thank god I didn't actually run into an error there (or maybe I would have realized the error of may ways sooner then). Genuinely stupid. I thank ye gods, for not actually having the file block and return an error or anything.
			mov	rdx, rsi
			mov	rsi, printBuf
			jmp	.read.bufferFull	; Good harvest

			align	8
			.read.partial:
			add	rsi, rax
			sub	rdx, rax
			jbe	.read.partial.done
			xor	eax, eax		; sys_read (0)
			syscall
			ScRetCheck	.read.error
			cmp	rax, 0
			je	.read.partial.done	; Too many jumps. It's driving me insane.
			jmp	.read.partial		; <strikethrough>This complicated structure is to minimize branches on the "assumed" path that shit will sort itself out first try.</strikethrough> Not complicated/quirky anymore. The universe has once again thrased me into compliance with normalcy. GG.

			align	16
		.fatalerror:				; Directly jump to Fatal Error Handling after cleanup
			mov	rsp, rbp
			pop	rbp
			add	rsp, 0x20		; Remove the ret address and register values
			jmp	_main.fatalerror	; We don't do functional programming here. Sorry.

			align	16
		.close:
			mov	eax, sys_close		; 0x3
			syscall
			ScRetCheck	.fatalerror
			xor	eax, eax
		.exit:					; Jump with return value
			mov	rsp, rbp
			pop	rbp
			pop	rdx
			pop	rsi
			pop	rdi
			ret

