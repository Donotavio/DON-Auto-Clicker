section .data
    interval dd 1000             ; Intervalo entre cliques em milissegundos (1 segundo)
    numClicks dd 100             ; Número de cliques antes de parar
    clickCount dd 0              ; Contador de cliques
    osType db 0                  ; Tipo de sistema operacional: 1 = Windows, 2 = Linux/MacOS

section .text
    global _start

_start:
    ; Detecta o sistema operacional em tempo de execução (simplificado)
    ; Nota: Em um caso real, você pode usar uma flag de compilação para escolher o bloco correto
    call DetectOS

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
    call Sleep

    ; Volta para o loop de clique
    jmp click_loop

end_click:
    ; Termina o programa
    call Exit

; Rotina para detectar o sistema operacional
DetectOS:
    ; Exemplo simples: você poderia implementar detecção mais complexa
    ; Aqui, assumimos 1 para Windows e 2 para Linux/MacOS
    ; Use bandeiras de compilação para definir manualmente se necessário
    mov eax, osType
    cmp eax, 0
    jne .already_detected
    ; Detectar sistema operacional
    ; Para este exemplo, ajustaremos manualmente a variável osType
    mov byte [osType], 1  ; 1 para Windows
    ; mov byte [osType], 2  ; 2 para Linux/MacOS (descomente para mudar)
.already_detected:
    ret

; Rotina para realizar clique do mouse (multiplataforma)
MouseClick:
    mov al, [osType]
    cmp al, 1
    je .windows_click
    cmp al, 2
    je .linux_macos_click
    ret

.windows_click:
    ; Usa a função de chamada de sistema para o clique no Windows
    push 0x04
    push 0x02
    push 0
    push 0
    call mouse_event
    ret

.linux_macos_click:
    ; Usa xdotool (Linux/MacOS) para simular o clique
    ; Precisa de xdotool instalado
    mov eax, 0x80              ; sys_execve para Linux/MacOS
    push 0
    push dword command_string  ; Comando "xdotool click 1"
    push dword command_name    ; Comando "xdotool"
    call eax
    ret

command_string db 'click 1', 0
command_name db '/usr/bin/xdotool', 0

; Rotina para sleep (multiplataforma)
Sleep:
    mov al, [osType]
    cmp al, 1
    je .windows_sleep
    cmp al, 2
    je .linux_macos_sleep
    ret

.windows_sleep:
    ; Função Sleep para Windows
    push dword [interval]
    call Sleep
    ret

.linux_macos_sleep:
    ; Função nanosleep para Linux/MacOS
    mov eax, 0x80              ; sys_nanosleep para Linux/MacOS
    mov ebx, sleep_time
    int 0x80
    ret

sleep_time:
    dq 1                       ; Defina o tempo de espera aqui (simplificado)

; Rotina para sair do programa (multiplataforma)
Exit:
    mov al, [osType]
    cmp al, 1
    je .windows_exit
    cmp al, 2
    je .linux_macos_exit
    ret

.windows_exit:
    ; Saída para Windows
    push 0
    call ExitProcess
    ret

.linux_macos_exit:
    ; Saída para Linux/MacOS
    mov eax, 1
    xor ebx, ebx
    int 0x80
    ret
