section .data
    clickInterval dd 1000          ; Intervalo entre cliques (1000ms = 1 segundo)
    mouse_event db 0x20, 0x00, 0x00, 0x00, 0x00
    leftDown dd 0x02               ; Constante para o clique do botão esquerdo (down)
    leftUp dd 0x04                 ; Constante para o clique do botão esquerdo (up)
    exitMsg db 'Auto clicker finished', 0

section .text
    global _start

_start:
    ; Loop de auto click
    click_loop:
        ; Chamada para o clique do botão esquerdo (down)
        mov eax, 0x07              ; Código da função de sistema 'Sleep'
        mov ebx, leftDown          ; Argumento para a função de clique (botão down)
        int 0x80                   ; Interrupção de sistema

        ; Chamada para o clique do botão esquerdo (up)
        mov eax, 0x07              ; Código da função de sistema 'Sleep'
        mov ebx, leftUp            ; Argumento para a função de clique (botão up)
        int 0x80                   ; Interrupção de sistema

        ; Espera pelo intervalo antes do próximo clique
        mov eax, 0x07              ; Código da função de sistema 'Sleep'
        mov ebx, clickInterval     ; Passa o intervalo de espera em milissegundos
        int 0x80                   ; Interrupção de sistema

        jmp click_loop             ; Repete o loop de clique

    ; Código para terminar o programa
    exit:
        mov eax, 1                 ; Código para função de saída do programa
        xor ebx, ebx               ; Código de saída 0 (sucesso)
        int 0x80                   ; Interrupção de sistema para sair

