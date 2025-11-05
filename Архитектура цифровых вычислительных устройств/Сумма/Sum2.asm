section .data
    msg1    db 'Enter 1 number: '	;Сообщение для первого числа
    len1    equ $ - msg1
    msg2    db 'Enter 2 number: '	;Сообщение для второго числа
    len2    equ $ - msg2
    msg3    db 'Answer: '		;Сообщение для ответа
    len3    equ $ - msg3
    newline db 10			

section .bss
    buffer1 resb 16
    buffer2 resb 16
    result  resb 16
    num1    resq 1
    num2    resq 1
    res_str resb 16
    res_len resq 1

section .text
    global _start

_start:
    mov rsi, msg1	;Ввод первого числа
    mov rdx, len1	
    call print_string
    
    mov rsi, buffer1	
    mov rdx, 16
    call read_string
    call string_to_int
    mov [num1], rax

    mov rsi, msg2	;Ввод второго числа
    mov rdx, len2
    call print_string
    
    mov rsi, buffer2
    mov rdx, 16
    call read_string
    call string_to_int
    mov [num2], rax

    mov rax, [num1]	;Сложение чисел
    mov rbx, [num2]
    call add_numbers
    
    call int_to_string
    
    mov rsi, msg3	;Вывод результата
    mov rdx, len3
    call print_string
    
    mov rsi, res_str
    mov rdx, [res_len]
    call print_string
    
    mov rsi, newline
    mov rdx, 1
    call print_string
    
    mov rax, 60		;Выход без ошибки
    xor rdi, 0 
    syscall

check_syscall:		;Подпрограмма проверки системного вызова
    cmp rax, 0
    jge .ok
    mov rdi, rax
    mov rax, 60
    syscall
.ok:
    ret

print_string:		;Вывод строки
    mov rax, 1
    mov rdi, 1
    syscall
    call check_syscall
    ret

read_string:		;Чтение строки
    mov rax, 0
    mov rdi, 0
    syscall
    call check_syscall
    ret

string_to_int:
    xor rax, rax	;Обнуляем регистр, в котором будет хранится число
    xor rcx, rcx	;Удаляем информацию о знаке
    mov bl, [rsi]	;Проверка первого символа строки на минус
    cmp bl, '-'
    jne .convert	;Если не минус - перевод
    inc rsi		;Пропускаем минус
    inc rcx		;Ставим отрицательный флаг

.convert:
    movzx rdx, byte [rsi];Текущий символ
    cmp dl, 10		;Проверка на конец строки
    je .done
    imul rax, 10	;Умножаем число на 10
    sub rdx, '0'
    add rax, rdx	;Добавляем цифру к числу
    inc rsi		;Переход к следующему символу
    jmp .convert

.done:
    test rcx, rcx	;Проверка на знак
    jz .positive
    neg rax

.positive:
    ret

int_to_string:
    mov rdi, res_str	;Начало буфера
    mov byte [rdi], 0	
    mov rbx, 10		;Делитель
    
    test eax, eax	;Проверка знака
    jns .positive
    neg rax		;Обрабатываем отрицательность
    mov byte [rdi], '-'
    inc rdi

.positive:
    mov r8, rdi		;Сохраняем начало строки
    
.convert_loop:
    xor rdx, rdx	;Освобождаем rdx
    div rbx		;rbx - частное, rdx - остаток
    add dl, '0'		;Цифра в символ
    mov [rdi], dl	;добавляем символ в строку
    inc rdi
    test rax, rax	;Проверяем число
    jnz .convert_loop
    
    mov byte [rdi], 0	;Завершаем строку
    
    mov rsi, r8		;Переворачиваем строку
    mov rcx, rdi
    sub rcx, rsi
    dec rdi
    
.reverse:
    cmp rsi, rdi
    jge .reverse_done
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp .reverse

.reverse_done:
    mov rdi, res_str	;Вычисляем длину
    call string_length
    mov [res_len], eax
    ret

string_length:
    xor rax, rax		;Обнуление счётчика длины
.loop:
    cmp byte [rdi + rax], 0	;Проверка на конец строки
    je .done			
    inc rax			;Увеличение счётчика
    jmp .loop
.done:
    ret

add_numbers:
    add rax, rbx
    ret
