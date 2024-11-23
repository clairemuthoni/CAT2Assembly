section .data
    prompt db "Enter a number: ", 0
    prompt_len equ $-prompt
    result_msg db "Factorial: ", 0
    result_msg_len equ $-result_msg

section .bss
    input resb 16        ; Buffer for input
    number resd 1        ; Store the input number

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov ecx, prompt      ; Address of prompt
    mov edx, prompt_len  ; Length of prompt
    int 0x80             ; System call

    ; Read user input
    mov eax, 3           ; sys_read
    mov ebx, 0           ; stdin
    mov ecx, input       ; Address of input buffer
    mov edx, 16          ; Max size of input
    int 0x80             ; System call

    ; Convert input string to integer
    xor eax, eax         ; Clear eax
    xor edx, edx         ; Clear edx
    mov ecx, input       ; Address of input buffer

parse_input:
    cmp byte [ecx], 0x0A ; Check for newline
    je factorial_call    ; End of input, jump to factorial calculation
    sub byte [ecx], '0'  ; Convert ASCII to integer
    imul eax, eax, 10    ; Multiply current value by 10
    add eax, [ecx]       ; Add new digit
    inc ecx              ; Move to next character
    jmp parse_input

factorial_call:
    mov [number], eax    ; Store the input number

    ; Call the factorial subroutine
    mov eax, [number]    ; Load number into eax
    push eax             ; Push argument onto the stack
    call factorial       ; Call the subroutine
    add esp, 4           ; Clean up stack (remove argument)

    ; Print the result message
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov ecx, result_msg  ; Address of result message
    mov edx, result_msg_len ; Length of result message
    int 0x80             ; System call

    ; Print the result (eax contains the factorial)
    call print_integer   ; Print the result

    ; Exit the program
    mov eax, 1           ; sys_exit
    xor ebx, ebx         ; Exit code 0
    int 0x80             ; System call

factorial:
    ; Compute factorial using recursion
    push ebp             ; Save base pointer
    mov ebp, esp         ; Set up stack frame
    push ebx             ; Save registers
    push ecx
    push edx

    mov eax, [ebp+8]     ; Get the argument (n) from the stack
    cmp eax, 1           ; Check if n <= 1
    jle factorial_base   ; If yes, return 1

    dec eax              ; n = n - 1
    push eax             ; Push (n-1) onto the stack
    call factorial       ; Recursive call
    add esp, 4           ; Clean up stack (remove argument)

    mov ebx, [ebp+8]     ; Get n again from the stack
    imul eax, ebx        ; Multiply n * factorial(n-1)
    jmp factorial_return

factorial_base:
    mov eax, 1           ; Base case: factorial(1) = 1

factorial_return:
    pop edx              ; Restore registers
    pop ecx
    pop ebx
    pop ebp              ; Restore base pointer
    ret                  ; Return to caller

print_integer:
    ; Convert integer in eax to string and print
    push eax             ; Preserve eax
    xor ecx, ecx         ; Clear digit counter
    xor edx, edx         ; Clear edx
    mov ebx, 10          ; Divisor for base 10

convert_to_string:
    xor edx, edx         ; Clear remainder
    div ebx              ; Divide eax by 10
    add dl, '0'          ; Convert remainder to ASCII
    push edx             ; Save ASCII character
    inc ecx              ; Increment digit count
    test eax, eax        ; Check if quotient is 0
    jnz convert_to_string

print_digits:
    pop edx              ; Get digit from stack
    mov [input], dl      ; Store in input buffer
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov ecx, input       ; Address of digit
    mov edx, 1           ; Length of digit
    int 0x80             ; System call
    loop print_digits    ; Repeat for all digits

    pop eax              ; Restore original value of eax
    ret

