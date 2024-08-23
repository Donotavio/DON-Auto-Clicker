section .data
    msgTimePrompt db 'Enter duration in seconds (0 for infinite): ', 0
    msgClickPrompt db 'Enter clicks per minute (use 60 for clicks per second): ', 0
    msgRunning db 'Running auto clicker...', 0
    msgFinished db 'Auto clicker finished.', 0
    duration dd 0                  ; Duração em segundos (0 = infinito)
    clicksPerMinute dd 60          ; Cliques por minuto (60 = 1 clique por segundo)
    interval dd 0                  ; Intervalo calculado entre cliques
    clickCount dd 0                ; Contador de cliques
    maxClicks dd 0                 ; Máximo de cliques permitidos (com base no tempo)

section .bss
    userInput resb 4               ; Buffer para entrada do usuário

section .text
    global _start

_start:
    ; Solicita a duração do usuário
    call PromptDuration

    ; Solicita o número de cliques por minuto
    call PromptClicksPerMinute

    ; Calcula o intervalo entre cliques (em milissegundos)
    call CalculateInterval

    ; Inicializa o contador de cliques e outros parâmetros
    mov eax, dword [interval]
    xor ecx, ecx                    ; Contador de cliques começa em 0

    ; Se o tempo for finito, calcula o número máximo de cliques
    cmp dword [duration], 0
    jne .calc_max_clicks
    mov dword [maxClicks], -1       ; Infinito (representado por -1)
    jmp click_loop

.calc_max_clicks:
    ; Calcula o número máximo de cliques permitidos dentro da duração
    mov eax, dword [duration]
    imul eax, dword [clicksPerMinute]
    cdq                             ; Extende EAX em EDX para dividir
    idiv dword [interval]
    mov dword [maxClicks], eax

click_loop:
    ; Verifica se atingiu o número máximo de cliques (se aplicável)
    cmp dword [clickCount], dword [maxClicks]
    jge end_click

    ; Realiza clique do mouse
    call MouseClick

    ; Incrementa o contador de cliques
    inc dword [clickCount]

    ; Espera pelo intervalo antes do próximo clique
    call Sleep

    ; Volta para o loop de clique
    jmp click_loop

end_click:
    ; Exibe mensagem de conclusão
    push 0
    push msgFinished
    push 0
    push 0
    call MessageBoxA

    ; Termina o programa
    push 0
    call ExitProcess

; Rotina para solicitar duração do usuário
PromptDuration:
    ; Exibe mensagem para o usuário
    push 0
    push msgTimePrompt
    push 0
    push 0
    call MessageBoxA

    ; Lê a entrada do usuário
    ; Aqui, por simplicidade, assumimos que a entrada foi recebida
    ; de alguma forma e armazenada em [userInput]
    ; Simulação de entrada:
    mov dword [userInput], 10       ; Exemplo: duração de 10 segundos

    ; Converte a entrada para número e armazena em [duration]
    mov eax, dword [userInput]
    mov dword [duration], eax
    ret

; Rotina para solicitar cliques por minuto
PromptClicksPerMinute:
    ; Exibe mensagem para o usuário
    push 0
    push msgClickPrompt
    push 0
    push 0
    call MessageBoxA

    ; Lê a entrada do usuário
    ; Aqui, por simplicidade, assumimos que a entrada foi recebida
    ; de alguma forma e armazenada em [userInput]
    ; Simulação de entrada:
    mov dword [userInput], 60       ; Exemplo: 60 cliques por minuto

    ; Converte a entrada para número e armazena em [clicksPerMinute]
    mov eax, dword [userInput]
    mov dword [clicksPerMinute], eax
    ret

; Rotina para calcular o intervalo entre cliques
CalculateInterval:
    ; Calcula o intervalo entre cliques (em milissegundos)
    ; intervalo = 60000 / cliques por minuto
    mov eax, 60000                  ; 60000 ms (1 minuto)
    cdq                             ; Extende EAX em EDX para dividir
    idiv dword [clicksPerMinute]
    mov dword [interval], eax
    ret

; Rotina para realizar clique do mouse (exemplo para Windows)
MouseClick:
    ; Usa a função de chamada de sistema para o clique
    ; (botão esquerdo: down e up)
    push 0x04
    push 0x02
    push 0
    push 0
    call mouse_event
    ret

; Rotina para sleep (multiplataforma)
Sleep:
    ; Função Sleep para Windows
    push dword [interval]
    call Sleep
    ret
