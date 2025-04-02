section .data
msg db 'Enter two digit number:', 0xa
msg_len equ $-msg
res db 10, 'Multiplication of elements is:'
res_len equ $-res
choice db 10, 'Enter your Choice:', 0xa
    db '1. Successive Addition', 0xa
    db '2. Add and Shift method', 0xa
    db '3. Exit', 0xa
choice_len equ $-choice

section .bss
num resb 5         ; Buffer for input
num1 resb 2        ; Store first number
result resb 4      ; Store result
cho resb 2         ; Store menu choice

section .text
global _start
_start:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    
    ; Display menu
    mov rax, 1
    mov rdi, 1
    mov rsi, choice
    mov rdx, choice_len
    syscall
    
    ; Get choice
    mov rax, 0
    mov rdi, 0
    mov rsi, cho
    mov rdx, 2
    syscall
    
    cmp byte[cho], '1'
    je a
    cmp byte[cho], '2'
    je b
    jmp exit

a:  call Succe_addition
    jmp _start

b:  call Add_shift
    jmp _start

exit:
    mov rax, 60
    mov rdi, 0
    syscall

convert:
    xor rbx, rbx
    xor rcx, rcx
    xor rax, rax
    
    mov rcx, 2
    mov rsi, num
up1:
    rol bl, 4
    mov al, [rsi]
    cmp al, '9'
    jbe p1
    sub al, 7
p1: sub al, '0'
p2: add bl, al
    inc rsi
    loop up1
    ret

display:
    mov rcx, 4
    mov rdi, result
dup1:
    rol bx, 4
    mov al, bl
    and al, 0fh
    cmp al, 9
    jbe p3
    add al, 7
p3: add al, '0'
p4: mov [rdi], al
    inc rdi
    loop dup1
    
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 4
    syscall
    ret

Succe_addition:
    ; Get first number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 5
    syscall
    
    call convert
    mov [num1], bl
    
    ; Get second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 5
    syscall
    
    call convert
    xor rcx, rcx
    xor rax, rax
    mov al, [num1]
    
repet:
    add rcx, rax
    dec bl
    jnz repet
    
    mov [result], cx
    
    ; Display result
    mov rax, 1
    mov rdi, 1
    mov rsi, res
    mov rdx, res_len
    syscall
    
    mov bx, [result]
    call display
    ret

Add_shift:
    ; Get first number (fixed syscall registers)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 5
    syscall
    
    call convert
    mov [num1], bl
    
    ; Get second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 5
    syscall
    
    call convert
    xor rcx, rcx
    xor rdx, rdx
    mov dl, 8
    mov al, [num1]
    mov bl, [num]
    
p11:
    shr bl, 1
    jnc p
    add cx, ax
p:  shl ax, 1
    dec dl
    jnz p11
    
    mov [result], cx
    
    ; Display result
    mov rax, 1
    mov rdi, 1
    mov rsi, res
    mov rdx, res_len
    syscall
    
    mov bx, [result]
    call display
    ret
