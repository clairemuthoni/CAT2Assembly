section .data
    prompt db "Enter 5 integers separated by spaces: ", 0
    prompt_len equ $-prompt

    result_msg db "Reversed array: ", 0
    result_msg_len equ $-result_msg

section .bss
    input resb 128         ; Buffer for user input
    numbers resd 5         ; Array for 5 integers

section .text
    global _start

_start:
    ; Print the prompt to the user
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, prompt         ; Address of prompt string
    mov edx, prompt_len     ; Length of the prompt
    int 0x80                ; System call

    ; Read input from the user
    mov eax, 3              ; sys_read
    mov ebx, 0              ; stdin
    mov ecx, input          ; Address of input buffer
    mov edx, 128            ; Max size of input
    int 0x80                ; System call

    ; Convert the input string into integers
    xor esi, esi            ; esi = index for numbers array
    xor edx, edx            ; edx = current number accumulator
    mov ecx, input          ; ecx = input buffer pointer

parse_input:
    cmp byte [ecx], 0x0A    ; Check if newline (end of input)
    je reverse_array
    cmp byte [ecx], ' '     ; Check if space (delimiter)
    je store_number
    sub byte [ecx], '0'     ; Convert ASCII to integer
    imul edx, edx, 10       ; Multiply current value by 10
    add edx, dword [ecx]    ; Add new digit
    jmp next_char

store_number:
    mov [numbers + esi * 4], edx ; Store accumulated number
    inc esi                     ; Increment array index
    xor edx, edx                ; Reset number accumulator
next_char:
    inc ecx                     ; Move to next character
    jmp parse_input

reverse_array:
    ; Reverse the array in place
    mov esi, 0                  ; esi = start index (0)
    mov edi, 4                  ; edi = end index (4)

reverse_loop:
    cmp esi, edi                ; Check if indices cross
    jge display_result          ; Exit loop if done
    ; Swap numbers[esi] and numbers[edi]
    mov eax, [numbers + esi * 4]
    mov ebx, [numbers + edi * 4]
    mov [numbers + edi * 4], eax
    mov [numbers + esi * 4], ebx
    inc esi                     ; Move start index forward
    dec edi                     ; Move end index backward
    jmp reverse_loop

display_result:
    ; Print the result message
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, result_msg         ; Address of result message
    mov edx, result_msg_len     ; Length of result message
    int 0x80                    ; System call

    ; Print the reversed array
    mov esi, 0                  ; Reset index for printing
print_loop:
    mov eax, [numbers + esi * 4] ; Load number
    call print_integer           ; Print number
    inc esi                      ; Increment index
    cmp esi, 5                   ; Check if all numbers are printed
    je exit_program
    ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, " "
    mov edx, 1
    int 0x80
    jmp print_loop

print_integer:
    ; Convert integer in eax to string and print
    push eax                    ; Preserve eax
    xor ecx, ecx                ; Digit count
    xor edx, edx                ; Clear edx
    mov ebx, 10                 ; Base 10
convert_to_string:
    xor edx, edx
    div ebx                     ; Divide eax by 10
    add dl, '0'                 ; Convert remainder to ASCII
    push edx                    ; Save digit
    inc ecx                     ; Increment digit count
    test eax, eax               ; Check if quotient is 0
    jnz convert_to_string

print_digits:
    pop edx                     ; Get digit from stack
    mov [input], dl             ; Store in input buffer
    mov eax, 4                  ; sys_write
    mov ebx, 1                  ; stdout
    mov ecx, input              ; Address of digit
    mov edx, 1                  ; Length = 1
    int 0x80                    ; System call
    loop print_digits           ; Repeat for all digits

    pop eax                     ; Restore original value
    ret

exit_program:
    ; Exit the program
    mov eax, 1                  ; sys_exit
    xor ebx, ebx                ; Exit code 0
    int 0x80
