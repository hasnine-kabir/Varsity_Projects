; Simple Calculator in Assembly Language
; Name: Hasnine Kabir
; ID: 0432310005101017
; Section: 6A1

.model small
.stack 100h
.data
    menu db 0Dh,0Ah, " Calculator By Hasnine Kabir", 0Dh,0Ah
         db "       ==============================", 0Dh,0Ah
         db "       1. Addition (+)", 0Dh,0Ah
         db "       2. Subtraction (-)", 0Dh,0Ah
         db "       3. Multiplication (*)", 0Dh,0Ah
         db "       4. Division (/)", 0Dh,0Ah
         db "       5. Exit", 0Dh,0Ah
         db "       Enter your choice (1-5): $"

    prompt1 db 0Dh,0Ah, "Enter 1st number: $"
    prompt2 db 0Dh,0Ah, "Enter 2nd number: $"
    resultmsg db 0Dh,0Ah, "Result: $"
    invalid db 0Dh,0Ah, "Invalid choice! Try again.", 0Dh,0Ah, "$"
    divzero db 0Dh,0Ah, "Division by zero!", 0Dh,0Ah, "$"
    thanks db 0Dh,0Ah, "Thank you for using my calculator!", 0Dh,0Ah, "$"

    num1 dw ?
    num2 dw ?
    result dw ?

    newline db 0Dh, 0Ah, "$"

.code
main proc
    mov ax, @data
    mov ds, ax

menu_loop:
    
    mov ah, 06h
    mov al, 0
    mov bh, 07h
    mov cx, 0
    mov dx, 184Fh
    int 10h

    
    lea dx, menu
    mov ah, 09h
    int 21h

    
    mov ah, 01h
    int 21h
    sub al, '1'        

    cmp al, 0
    je addition
    cmp al, 1
    je subtraction
    cmp al, 2
    je multiplication
    cmp al, 3
    je division
    cmp al, 4
    je exit_program

    
    lea dx, invalid
    mov ah, 09h
    int 21h
    jmp menu_loop

addition:
    call get_two_numbers
    mov ax, num1
    add ax, num2
    mov result, ax
    jmp show_result

subtraction:
    call get_two_numbers
    mov ax, num1
    sub ax, num2
    mov result, ax
    jmp show_result

multiplication:
    call get_two_numbers
    mov ax, num1
    imul num2          
    mov result, ax
    jmp show_result

division:
    call get_two_numbers
    cmp num2, 0
    je div_by_zero

    mov ax, num1
    cwd                
    idiv num2           
    mov result, ax
    jmp show_result

div_by_zero:
    lea dx, divzero
    mov ah, 09h
    int 21h
    call wait_enter
    jmp menu_loop

show_result:
    lea dx, resultmsg
    mov ah, 09h
    int 21h

    mov ax, result
    call print_number

    call wait_enter
    jmp menu_loop

exit_program:
    lea dx, thanks
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h

main endp


get_two_numbers proc
    lea dx, prompt1
    mov ah, 09h
    int 21h
    call read_number
    mov num1, ax

    lea dx, prompt2
    mov ah, 09h
    int 21h
    call read_number
    mov num2, ax
    ret
get_two_numbers endp


read_number proc
    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov si, 0           

get_char:
    mov ah, 01h
    int 21h
    cmp al, '-'
    je negative
    cmp al, 0Dh         
    je done_input
    cmp al, '0'
    jb get_char
    cmp al, '9'
    ja get_char

    sub al, '0'
    mov bl, al
    mov ax, cx
    mov dx, 10
    mul dx
    add ax, bx
    mov cx, ax
    jmp get_char

negative:
    mov si, 1
    jmp get_char

done_input:
    mov ax, cx
    cmp si, 1
    jne positive
    neg ax
positive:
    ret
read_number endp


print_number proc
    test ax, ax
    jge print_positive

    push ax
    mov dl, '-'
    mov ah, 02h
    int 21h
    pop ax
    neg ax

print_positive:
    mov bx, 10
    xor cx, cx

push_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz push_loop

pop_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop pop_loop

    ret
print_number endp

; Wait for Enter key

wait_enter proc
    lea dx, newline
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    ret
wait_enter endp

end main