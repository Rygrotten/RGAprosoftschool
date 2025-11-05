section .data
    prompt db 'Enter your string:', 0
    reversed_msg db 'Reversed:', 0
    newline db 10

section .bss
    buffer resb 101
    input_len resb 1

section .text
    global _start

_start:
    mov rsi, prompt	;Вывод  Enter your string
    call print_string
    call print_newline

    mov rsi, buffer	;Чтение строки
    mov rdi, input_len
    call read_string

    cmp byte [input_len], 0	;Проверка на пустую строку
    je exit

    mov rsi, buffer		;Разворот строки
    mov dil, byte [input_len]
    call reverse_string

    mov rsi, reversed_msg	;Вывод результата
    call print_string

    mov rsi, buffer
    movzx rdx, byte [input_len]
    call print_buffer
    call exit

check_syscall:
    cmp rax, 0
    jge .ok
    mov rdi, rax
    mov rax, 60
    syscall
.ok:
    ret

exit:			;Успешное завершение программы
    mov rax, 60   
    xor rdi, rdi
    syscall

print_string: 
    mov rdx, 0
.count_loop:
    cmp byte [rsi + rdx], 0
    je .print
    inc rdx
    jmp .count_loop
.print:
    mov rax, 1
    mov rdi, 1
    syscall
    call check_syscall
    ret

print_newline:	
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    call check_syscall
    ret

read_string:	
    mov rdx, 100    ; Максимальная длина
    mov rax, 0      ; read
    mov rdi, 0      ; stdin
    syscall
    call check_syscall

    mov [input_len], al	; Сохранение длины и добавление нулевого байта
    mov byte [buffer + rax], 0
    ret

reverse_string:
    test dil, dil    ; Проверка пустой строки
    jz .end
    mov rdx, rsi     ; Сохранение начала буфера
    movzx rcx, dil   ; Длина строки
    lea rsi, [rsi + rcx - 1]  ; Указатель на конец строки

.reverse_loop:
    cmp rdx, rsi
    jge .end
    mov al, [rdx]
    mov ah, [rsi]
    mov [rsi], al
    mov [rdx], ah
    inc rdx
    dec rsi
    jmp .reverse_loop

.end:
    ret

print_buffer:
    mov rax, 1
    mov rdi, 1
    syscall
    call  print_newline
    ret
