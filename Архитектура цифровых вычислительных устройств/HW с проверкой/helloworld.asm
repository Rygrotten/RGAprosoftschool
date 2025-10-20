global _start				;

section .data				;
	message db "Hello world!", 10;
	length equ $ - message;
	error db "Error", 10;
	errlength equ $ - error;

section .text;
_start:
	mov rax, 1;
	mov rdi, 1;
	mov rsi, message;
	mov rdx, length;
	syscall;

	cmp rax, -1;
	jng laberror;

	mov rax, 60;
	syscall;

laberror:
	mov rax, 1;
	mov rdi, 1;
	mov rsi, error;
	mov rdx, errlength;
	syscall
	
	mov rax, 60;
	syscall;
