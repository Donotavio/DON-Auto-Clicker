section .data
    interval dd 1000                 ; Intervalo entre cliques em milissegundos (1 segundo)
    numClicks dd 100                 ; Número de cliques antes de parar
    clickCount dd 0                  ; Contador de cliques
    msg db 'Auto clicker finished.', 0

section .bss
    hInstance resd 1
    hWnd resd 1

section .text
    global _start
    extern Sleep, MessageBoxA, ExitProcess, GetModuleHandleA

_start:
    ; Inicializa contadores e parâmetros
    mov eax, dword [interval]
    mov ebx, dword [numClicks]

click_loop:
    ; Realiza clique do botão esquerdo
    call MouseClick

    ; Incrementa o contador de cliques
    inc dword [clickCount]

    ; Verifica se o número de cliques atingiu o máximo
    mov eax, dword [clickCount]
    cmp eax, ebx
    jge end_click

    ; Espera pelo intervalo antes do próximo clique
    push dword [interval]
    call Sleep

    ; Volta para o loop de clique
    jmp click_loop

end_click:
    ; Exibe mensagem de conclusão
    push 0
    push msg
    push 0
    push 0
    call MessageBoxA

    ; Termina o programa
    push 0
    call ExitProcess

; Rotina para realizar clique do mouse
MouseClick:
    ; Usa a função de chamada de sistema para o clique
    ; (botão esquerdo: down e up)
    push 0x04
    push 0x02
    push 0
    push 0
    call mouse_event
    ret

section .idata
    dd 0, 0, 0, 0, RVA kernel32_dll_name
    dd 0, 0, 0, 0, RVA user32_dll_name
    dd 0, 0, 0, 0, 0

kernel32_dll_name db 'KERNEL32.DLL', 0
user32_dll_name db 'USER32.DLL', 0

section .rdata
    dd 0, 0, 0, 0, 0
    dd 0, 0, 0, 0, 0
