section .data
    sensor_value db 0        ; Simulated sensor value (0-255 range)
    motor_status db 0        ; Simulated motor status (0: off, 1: on)
    alarm_status db 0        ; Simulated alarm status (0: off, 1: on)

    msg_sensor db "Sensor Value: ", 0
    msg_motor_on db "Motor ON", 0
    msg_motor_off db "Motor OFF", 0
    msg_alarm_on db "ALARM TRIGGERED!", 0
    newline db 10, 0

section .bss
    input_buffer resb 4      ; Buffer for user input (simulated sensor value)

section .text
    global _start

_start:
    ; Prompt user to enter a sensor value
    mov eax, 4              ; sys_write
    mov ebx, 1              ; stdout
    mov ecx, msg_sensor     ; Address of message
    mov edx, 14             ; Length of message
    int 0x80                ; System call

    ; Read user input (simulated sensor value)
    mov eax, 3              ; sys_read
    mov ebx, 0              ; stdin
    mov ecx, input_buffer   ; Address of input buffer
    mov edx, 4              ; Max input size
    int 0x80                ; System call

    ; Convert input string to number
    xor eax, eax            ; Clear eax
    mov ecx, input_buffer   ; Address of input buffer

convert_input:
    cmp byte [ecx], 0x0A    ; Check for newline
    je check_sensor         ; Jump to sensor check
    sub byte [ecx], '0'     ; Convert ASCII to integer
    imul eax, eax, 10       ; Multiply by 10
    add eax, [ecx]          ; Add digit
    inc ecx                 ; Move to next character
    jmp convert_input

check_sensor:
    mov [sensor_value], al  ; Store sensor value (8-bit only)

    ; Determine action based on sensor value
    mov al, [sensor_value]  ; Load sensor value
    cmp al, 200             ; Check if water level is too high
    ja trigger_alarm        ; If sensor > 200, trigger alarm

    cmp al, 100             ; Check if water level is moderate
    ja motor_off            ; If 100 < sensor <= 200, turn off motor

    ; If water level is low (sensor <= 100), turn on motor
    mov byte [motor_status], 1  ; Motor ON
    mov byte [alarm_status], 0  ; Alarm OFF
    call print_motor_on
    jmp end_program

motor_off:
    ; Stop motor for moderate water level
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 0  ; Alarm OFF
    call print_motor_off
    jmp end_program

trigger_alarm:
    ; Trigger alarm for high water level
    mov byte [motor_status], 0  ; Motor OFF
    mov byte [alarm_status], 1  ; Alarm ON
    call print_alarm_on
    jmp end_program

print_motor_on:
    ; Print "Motor ON"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_motor_on
    mov edx, 8
    int 0x80
    ret

print_motor_off:
    ; Print "Motor OFF"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_motor_off
    mov edx, 9
    int 0x80
    ret

print_alarm_on:
    ; Print "ALARM TRIGGERED!"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_alarm_on
    mov edx, 17
    int 0x80
    ret

end_program:
    ; Print newline for better readability
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; Exit code 0
    int 0x80
