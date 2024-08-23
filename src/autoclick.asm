section .data
    msgTimePrompt db 'Enter duration in seconds (0 for infinite): ', 0
    msgClickPrompt db 'Enter clicks per minute (use 60 for clicks per second): ', 0
    msgRunning db 'Running auto clicker...', 0
    msgFinished db 'Auto clicker finished.', 0
    duration dd 0                  ; Duration in seconds (0 = infinite)
    clicksPerMinute dd 60          ; Clicks per minute (60 = 1 click per second)
    interval dd 0                  ; Calculated interval between clicks
    clickCount dd 0                ; Click counter
    maxClicks dd 0                 ; Maximum allowed clicks (based on duration)

section .bss
    userInput resb 4               ; Buffer for user input

section .text
    global _start

_start:
    ; Prompt the user for duration
    call PromptDuration

    ; Prompt the user for clicks per minute
    call PromptClicksPerMinute

    ; Calculate the interval between clicks (in milliseconds)
    call CalculateInterval

    ; Initialize the click counter and other parameters
    mov eax, dword [interval]
    xor ecx, ecx                    ; Click counter starts at 0

    ; If time is finite, calculate the maximum number of clicks
    cmp dword [duration], 0
    jne .calc_max_clicks
    mov dword [maxClicks], -1       ; Infinite (represented by -1)
    jmp click_loop

.calc_max_clicks:
    ; Calculate the maximum number of clicks allowed within the duration
    mov eax, dword [duration]
    imul eax, dword [clicksPerMinute]
    cdq                             ; Extend EAX into EDX for division
    idiv dword [interval]
    mov dword [maxClicks], eax

click_loop:
    ; Check if the maximum number of clicks has been reached (if applicable)
    cmp dword [clickCount], dword [maxClicks]
    jge end_click

    ; Perform mouse click
    call MouseClick

    ; Increment the click counter
    inc dword [clickCount]

    ; Wait for the interval before the next click
    call Sleep

    ; Return to the click loop
    jmp click_loop

end_click:
    ; Display completion message
    push 0
    push msgFinished
    push 0
    push 0
    call MessageBoxA

    ; Terminate the program
    push 0
    call ExitProcess

; Routine to prompt the user for duration
PromptDuration:
    ; Display message to the user
    push 0
    push msgTimePrompt
    push 0
    push 0
    call MessageBoxA

    ; Read user input
    ; Here, for simplicity, we assume the input has been received
    ; somehow and stored in [userInput]
    ; Input simulation:
    mov dword [userInput], 10       ; Example: 10 seconds duration

    ; Convert input to a number and store in [duration]
    mov eax, dword [userInput]
    mov dword [duration], eax
    ret

; Routine to prompt the user for clicks per minute
PromptClicksPerMinute:
    ; Display message to the user
    push 0
    push msgClickPrompt
    push 0
    push 0
    call MessageBoxA

    ; Read user input
    ; Here, for simplicity, we assume the input has been received
    ; somehow and stored in [userInput]
    ; Input simulation:
    mov dword [userInput], 60       ; Example: 60 clicks per minute

    ; Convert input to a number and store in [clicksPerMinute]
    mov eax, dword [userInput]
    mov dword [clicksPerMinute], eax
    ret

; Routine to calculate the interval between clicks
CalculateInterval:
    ; Calculate the interval between clicks (in milliseconds)
    ; interval = 60000 / clicks per minute
    mov eax, 60000                  ; 60000 ms (1 minute)
    cdq                             ; Extend EAX into EDX for division
    idiv dword [clicksPerMinute]
    mov dword [interval], eax
    ret

; Routine to perform mouse click (example for Windows)
MouseClick:
    ; Use the system call for mouse click
    ; (left button: down and up)
    push 0x04
    push 0x02
    push 0
    push 0
    call mouse_event
    ret

; Routine for sleep (cross-platform)
Sleep:
    ; Sleep function for Windows
    push dword [interval]
    call Sleep
    ret
