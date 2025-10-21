global _start				;

section .data				;
	message db "Hello world!", 10;
	length equ $ - message;
	fname db "HW_out.txt";

section .text;
_start:
	mov rax, 2;
	mov rdi, fname;
	mov rsi, 577;
	mov rdx, 420;
	syscall;

	mov rbx, rax;

	mov rax, 1;
	mov rdi, rbx;
	mov rsi, message;
	mov rdx, length;
	syscall;

	mov eax, 3;
	mov edi, ebx;
	syscall;

	mov rax, 60;
	syscall;

