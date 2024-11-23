section .data
    prompt db "Enter a number: ", 0
    pos_msg db "The number is POSITIVE.", 10, 0
    neg_msg db "The number is NEGATIVE.", 10, 0
    zero_msg db "The number is ZERO.", 10, 0

section .bss
    input resb 10         ; buffer to store user input

global _start

section .text
_start:
    ; Prompt user for input
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, prompt       ; pointer to message
    mov edx, 15           ; length of message
    int 0x80              ; call kernel

    ; Read user input
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; file descriptor: stdin
    mov ecx, input        ; pointer to input buffer
    mov edx, 10           ; max number of bytes to read
    int 0x80              ; call kernel

    ; Convert ASCII input to integer
    mov eax, 0            ; clear eax (accumulator)
    mov esi, input        ; point to input buffer

convert_to_int:
    movzx ebx, byte [esi] ; load byte from buffer
    cmp bl, 10            ; check if newline (Enter key)
    je check_value        ; if newline, jump to check_value

    sub bl, '0'           ; convert ASCII to integer
    imul eax, eax, 10     ; multiply eax by 10 (shift left)
    add eax, ebx          ; add the digit to eax

    inc esi               ; move to next character in buffer
    jmp convert_to_int    ; loop back

check_value:
    cmp eax, 0            ; check if number is zero
    je print_zero         ; if zero, jump to print_zero
    jl print_negative     ; if less than zero, jump to print_negative

    ; If it's not zero or negative, it must be positive
    jmp print_positive

print_positive:
    ; Print "POSITIVE" message
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, pos_msg      ; pointer to message
    mov edx, 23           ; length of message
    int 0x80              ; call kernel
    jmp exit              ; unconditional jump to exit

print_negative:
    ; Print "NEGATIVE" message
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, neg_msg      ; pointer to message
    mov edx, 23           ; length of message
    int 0x80              ; call kernel
    jmp exit              ; unconditional jump to exit

print_zero:
    ; Print "ZERO" message
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, zero_msg     ; pointer to message
    mov edx, 18           ; length of message
    int 0x80              ; call kernel

exit:
    ; Exit program
    mov eax, 1            ; syscall: sys_exit
    xor ebx, ebx          ; return code 0
    int 0x80              ; call kernel
