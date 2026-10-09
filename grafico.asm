; ============================================================================
; PROGRAMA DE DEMONSTRAÇÃO GRÁFICA 
; ----------------------------------------------------------------------------
; Atualizações:
; - 10/05/2007: Correção de erro de arredondamento na rotina 'line'.
; - 10/2009: Adicionadas funções 'circle' e 'full_circle' por Jefferson Moro.
; - 09/2026: Comentários adicionados e ajuste na função 'plot_xy' para origem 
;            no canto superior esquerdo
; ============================================================================

segment code
..start:
    ; ------------------------------------------------------------------------
    ; INICIALIZAÇÃO DOS REGISTRADORES DE SEGMENTO E PILHA
    ; ------------------------------------------------------------------------
    mov     ax, data
    mov     ds, ax
    mov     ax, stack
    mov     ss, ax
    mov     sp, stacktop

    ; ------------------------------------------------------------------------
    ; SALVAR MODO DE VÍDEO ATUAL (Para restaurar ao finalizar o programa)
    ; ------------------------------------------------------------------------
    mov     ah, 0Fh             ; Captura modo de vídeo atual
    int     10h
    mov     [modo_anterior], al ; Salva o modo retornado em AL

    ; ------------------------------------------------------------------------
    ; ALTERAR MODO DE VÍDEO PARA GRÁFICO (VGA 640x480 - 16 Cores)
    ; ------------------------------------------------------------------------
    mov     al, 12h             ; Modo 12h: 640x480 pixels, 16 cores
    mov     ah, 00h             ; Configura modo de vídeo
    int     10h

    ; ------------------------------------------------------------------------
    ; DESENHO DE RETAS (Função 'line')
    ; Parâmetros na pilha: PUSH x1, PUSH y1, PUSH x2, PUSH y2
    ; ------------------------------------------------------------------------
;    mov     byte [cor], magenta

;    Reta 1
;    mov     ax, 20
;    push    ax                  ; x1 = 20
;    mov     ax, 400
;    push    ax                  ; y1 = 400
;    mov     ax, 620
;    push    ax                  ; x2 = 620
;    mov     ax, 400
;    push    ax                  ; y2 = 400
;    call    line

    ; ------------------------------------------------------------------------
    ; DESENHO DE CÍRCULOS E CÍRCULOS PREENCHIDOS
    ; Parâmetros na pilha: PUSH xc, PUSH yc, PUSH raio
    ; ------------------------------------------------------------------------

;    mov     byte [cor], azul
;    mov     ax, 200
;    push    ax                  ; xc = 200
;    mov     ax, 200
;    push    ax                  ; yc = 200
;    mov     ax, 100
;    push    ax                  ; r  = 100
;    call    circle



    ; ------------------------------------------------------------------------
    ; ESCRITA DE TEXTO COLORIDO NA TELA
    ; ------------------------------------------------------------------------
;    mov     cx, 14              ; Número de caracteres da mensagem ('Funcao Grafica')
;    mov     bx, 0               ; Índice do caractere
;    mov     dh, 0               ; Linha inicial (0-29)
;    mov     dl, 30              ; Coluna inicial (0-79)
;    mov     byte [cor], azul

;l4:
;    call    cursor              ; Posiciona o cursor em (dh, dl)
;    mov     al, [bx + mens]     ; Carrega o caractere atual
;    call    caracter            ; Desenha o caractere com a cor atual
;    inc     bx                  ; Avança para o próximo caractere
;    inc     dl                  ; Avança a coluna do cursor
;    inc     byte [cor]          ; Alterna a cor para o próximo caractere
;    loop    l4





l1:

    mov byte [cor], amarelo

    mov     ax, 0
    push    ax
    mov     ax, 0
    push    ax
    mov     ax, 639
    push    ax
    mov     ax, 0
    push    ax
    call    line

l2:

    mov     ax, 639
    push    ax
    mov     ax, 0
    push    ax
    mov     ax, 639
    push    ax
    mov     ax, 479
    push    ax
    call    line

l3:

    mov     ax, 639
    push    ax
    mov     ax, 479
    push    ax
    mov     ax, 0
    push    ax
    mov     ax, 479
    push    ax
    call    line

l4:

    mov     ax, 0
    push    ax
    mov     ax, 479
    push    ax
    mov     ax, 0
    push    ax
    mov     ax, 0
    push    ax
    call    line

c1:

    mov     byte [cor], vermelho

    mov     ax, 319
    push    ax
    mov     ax, 239
    push    ax
    mov     ax, 5
    push    ax
    call    full_circle


luup:

    mov     byte [cor], preto
    call    full_circle 

    inc centrox
    cmp 0
    jmp
    cmp 
    verificar:








    ; ------------------------------------------------------------------------
    ; FINALIZAÇÃO DO PROGRAMA
    ; ------------------------------------------------------------------------
    mov     ah, 08h             ; Aguarda pressionar uma tecla 
    int     21h

    mov     ah, 00h             ; Restaura o modo de vídeo original
    mov     al, [modo_anterior]
    int     10h

    mov     ah, 4ch           ; Finaliza o programa e retorna ao DOS
    int     21h

    ; ============================================================================
    ; PROCEDIMENTOS AUXILIARES E GRÁFICOS
    ; ============================================================================

    ; ----------------------------------------------------------------------------
    ; ROTINA: cursor
    ; Descrição: Define a posição do cursor de texto na tela.
    ; Entradas: DH = Linha (0-29), DL = Coluna (0-79)
    ; ----------------------------------------------------------------------------
    cursor:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp

        mov     ah, 2               ; Interrupção para definir a posição do cursor
        mov     bh, 0               ; Página de vídeo 0
        int     10h

        pop     bp
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        ret

    ; ----------------------------------------------------------------------------
    ; ROTINA: caracter
    ; Descrição: Imprime um caractere no local atual do cursor com cor personalizada.
    ; Entradas: AL = Caractere ASCII, Variavel 'cor' = Cor do caractere
    ; ----------------------------------------------------------------------------
    caracter:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp

        mov     ah, 9               ; Interrupção para escrever caracter
        mov     bh, 0               ; Página de vídeo   0
        mov     cx, 1               ; Quantidade de repetições do caractere
        mov     bl, [cor]           ; Atributo de cor
        int     10h

        pop     bp
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        ret

    ; ----------------------------------------------------------------------------
    ; ROTINA: plot_xy
    ; Descrição: Desenha um ponto (pixel) na tela nas coordenadas (X, Y).
    ; Parâmetros via Pilha:
    ;   [bp+6] -> Coordenada X (0-639)
    ;   [bp+4] -> Coordenada Y (0-479)
    ; Entrada implícita: Variável 'cor'
    ; ----------------------------------------------------------------------------
    plot_xy:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ah, 0ch             ; Interrupção para desenhar um pixel 
        mov     al, [cor]           ; Cor do pixel
        mov     bh, 0               ; Página de vídeo 0
        mov     cx, [bp+6]          ; Coordenada X
        mov     dx, [bp+4]          ; Coordenada Y (BIOS usa DX para Y)
        int     10h

        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        pop     bp
        ret     4                   ; Limpa 4 bytes de parâmetros da pilha

    ; ----------------------------------------------------------------------------
    ; ROTINA: circle
    ; Descrição: Desenha o contorno de um círculo usando o algoritmo do Ponto Médio.
    ; Parâmetros via Pilha:
    ;   [bp+8] -> Coordenada X do centro (xc)
    ;   [bp+6] -> Coordenada Y do centro (yc)
    ;   [bp+4] -> Raio (r)
    ; ----------------------------------------------------------------------------
    circle:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+8]          ; AX = xc
        mov     bx, [bp+6]          ; BX = yc
        mov     cx, [bp+4]          ; CX = r

        ; Plotagem dos 4 pontos cardeais extremos do círculo
        mov     dx, bx
        add     dx, cx              ; Topo: (xc, yc + r)
        push    ax
        push    dx
        call    plot_xy

        mov     dx, bx
        sub     dx, cx              ; Base: (xc, yc - r)
        push    ax
        push    dx
        call    plot_xy

        mov     dx, ax
        add     dx, cx              ; Direita: (xc + r, yc)
        push    dx
        push    bx
        call    plot_xy

        mov     dx, ax
        sub     dx, cx              ; Esquerda: (xc - r, yc)
        push    dx
        push    bx
        call    plot_xy

        ; Variáveis de decisão do algoritmo do Ponto Médio
        mov     di, cx
        sub     di, 1               ; di = d = r - 1 (variável de decisão)
        mov     dx, 0               ; DX = x = 0. CX já é a variável y = r

    stay:
        mov     si, di
        cmp     si, 0
        jg      inf                 ; Se d > 0, decrementa Y (ponto inferior)

        ; Atualização de 'd' para o passo horizontal (E)
        mov     si, dx
        sal     si, 1               ; 2 * x
        add     si, 3               ; 2 * x + 3
        add     di, si              ; d = d + 2*x + 3
        inc     dx                  ; x++
        jmp     plotar

    inf:
        ; Atualização de 'd' para o passo diagonal (SE)
        mov     si, dx
        sub     si, cx              ; x - y
        sal     si, 1               ; 2 * (x - y)
        add     si, 5               ; 2 * (x - y) + 5
        add     di, si              ; d = d + 2*(x - y) + 5
        inc     dx                  ; x++
        dec     cx                  ; y--

    plotar:
        ; Plotagem simétrica nos 8 octantes:
        mov     si, dx
        add     si, ax
        push    si                  ; xc + x
        mov     si, cx
        add     si, bx
        push    si                  ; yc + y
        call    plot_xy             ; Octante 2

        mov     si, ax
        add     si, dx
        push    si                  ; xc + x
        mov     si, bx
        sub     si, cx
        push    si                  ; yc - y
        call    plot_xy             ; Octante 7

        mov     si, ax
        add     si, cx
        push    si                  ; xc + y
        mov     si, bx
        add     si, dx
        push    si                  ; yc + x
        call    plot_xy             ; Octante 1

        mov     si, ax
        add     si, cx
        push    si                  ; xc + y
        mov     si, bx
        sub     si, dx
        push    si                  ; yc - x
        call    plot_xy             ; Octante 8

        mov     si, ax
        sub     si, dx
        push    si                  ; xc - x
        mov     si, bx
        add     si, cx
        push    si                  ; yc + y
        call    plot_xy             ; Octante 3

        mov     si, ax
        sub     si, dx
        push    si                  ; xc - x
        mov     si, bx
        sub     si, cx
        push    si                  ; yc - y
        call    plot_xy             ; Octante 6

        mov     si, ax
        sub     si, cx
        push    si                  ; xc - y
        mov     si, bx
        sub     si, dx
        push    si                  ; yc - x
        call    plot_xy             ; Octante 5

        mov     si, ax
        sub     si, cx
        push    si                  ; xc - y
        mov     si, bx
        add     si, dx
        push    si                  ; yc + x
        call    plot_xy             ; Octante 4

        cmp     cx, dx              ; Enquanto y >= x continua no loop
        jb      fim_circle
        jmp     stay

    fim_circle:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        pop     bp
        ret     6                   ; Limpa 6 bytes da pilha

    ; ----------------------------------------------------------------------------
    ; ROTINA: full_circle
    ; Descrição: Desenha um círculo preenchido traçando linhas verticais
    ;            entre os pontos simétricos da circunferência.
    ; Parâmetros via Pilha:
    ;   [bp+8] -> Coordenada X do centro (xc)
    ;   [bp+6] -> Coordenada Y do centro (yc)
    ;   [bp+4] -> Raio (r)
    ; ----------------------------------------------------------------------------
    full_circle:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+8]          ; AX = xc
        mov     bx, [bp+6]          ; BX = yc
        mov     cx, [bp+4]          ; CX = r

        ; Linha vertical central: de (xc, yc - r) até (xc, yc + r)
        mov     si, bx
        sub     si, cx
        push    ax
        push    si                  ; (xc, yc - r)
        mov     si, bx
        add     si, cx
        push    ax
        push    si                  ; (xc, yc + r)
        call    line

        mov     di, cx
        sub     di, 1               ; di = r - 1
        mov     dx, 0               ; x = 0, y = r

    stay_full:
        mov     si, di
        cmp     si, 0
        jg      inf_full

        mov     si, dx
        sal     si, 1
        add     si, 3
        add     di, si
        inc     dx
        jmp     plotar_full

    inf_full:
        mov     si, dx
        sub     si, cx
        sal     si, 1
        add     si, 5
        add     di, si
        inc     dx
        dec     cx

    plotar_full:
        ; Traça linhas verticais conectando os pontos simétricos dos octantes
        mov     si, ax
        add     si, cx
        push    si
        mov     si, bx
        sub     si, dx
        push    si
        mov     si, ax
        add     si, cx
        push    si
        mov     si, bx
        add     si, dx
        push    si
        call    line

        mov     si, ax
        add     si, dx
        push    si
        mov     si, bx
        sub     si, cx
        push    si
        mov     si, ax
        add     si, dx
        push    si
        mov     si, bx
        add     si, cx
        push    si
        call    line

        mov     si, ax
        sub     si, dx
        push    si
        mov     si, bx
        sub     si, cx
        push    si
        mov     si, ax
        sub     si, dx
        push    si
        mov     si, bx
        add     si, cx
        push    si
        call    line

        mov     si, ax
        sub     si, cx
        push    si
        mov     si, bx
        sub     si, dx
        push    si
        mov     si, ax
        sub     si, cx
        push    si
        mov     si, bx
        add     si, dx
        push    si
        call    line

        cmp     cx, dx
        jb      fim_full_circle
        jmp     stay_full

    fim_full_circle:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        pop     bp
        ret     6

    ; ----------------------------------------------------------------------------
    ; ROTINA: line
    ; Descrição: Desenha uma reta entre (x1, y1) e (x2, y2) utilizando
    ;            uma variação do algoritmo de Bresenham.
    ; Parâmetros via Pilha:
    ;   [bp+10] -> x1
    ;   [bp+8]  -> y1
    ;   [bp+6]  -> x2
    ;   [bp+4]  -> y2
    ; ----------------------------------------------------------------------------
    line:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+10]         ; AX = x1
        mov     bx, [bp+8]          ; BX = y1
        mov     cx, [bp+6]          ; CX = x2
        mov     dx, [bp+4]          ; DX = y2

        cmp     ax, cx
        je      line2               ; DeltaX == 0 (Linha estritamente vertical)
        jb      line1               ; Se x1 < x2, mantém ordem
        xchg    ax, cx              ; Se x1 > x2, troca os pontos para desenhar da esquerda p/ direita
        xchg    bx, dx
        jmp     line1

    line2:                          ; Trata linhas verticais (DeltaX = 0)
        cmp     bx, dx
        jb      line3
        xchg    bx, dx              ; Garante y1 < y2

    line3:                          ; Loop de desenho da linha vertical
        push    ax
        push    bx
        call    plot_xy
        cmp     bx, dx
        jne     line31
        jmp     fim_line
    line31:
        inc     bx
        jmp     line3

    line1:                          ; Calcula deltax e deltay quando deltax != 0
        push    cx
        sub     cx, ax
        mov     [deltax], cx
        pop     cx

        push    dx
        sub     dx, bx
        ja      line32
        neg     dx                  ; dx = |y2 - y1|
    line32:
        mov     [deltay], dx
        pop     dx

        push    ax
        mov     ax, [deltax]
        cmp     ax, [deltay]
        pop     ax
        jb      line5               ; Se DeltaY > DeltaX, inclinação alta (passo em Y)

        ; --- Caso 1: Varredura principal em X (DeltaX >= DeltaY) ---
        push    cx
        sub     cx, ax
        mov     [deltax], cx
        pop     cx

        push    dx
        sub     dx, bx
        mov     [deltay], dx
        pop     dx

        mov     si, ax              ; SI = x atual

    line4:
        push    ax
        push    dx
        push    si
        sub     si, ax              ; dx_atual = (x - x1)
        mov     ax, [deltay]
        imul    si                  ; AX = (x - x1) * deltay
        mov     si, [deltax]        ; Fator de arredondamento: deltax / 2
        shr     si, 1

        cmp     dx, 0               ; Ajusta arredondamento baseado no sinal do produto
        jl      ar1
        add     ax, si
        adc     dx, 0
        jmp     arc1
    ar1:
        sub     ax, si
        sbb     dx, 0
    arc1:
        idiv    word [deltax]       ; Y_calculado = ((x - x1) * deltay) / deltax
        add     ax, bx              ; Y_final = y1 + Y_calculado
        pop     si

        push    si                  ; X
        push    ax                  ; Y
        call    plot_xy

        pop     dx
        pop     ax
        cmp     si, cx
        je      fim_line
        inc     si
        jmp     line4

        ; --- Caso 2: Varredura principal em Y (DeltaY > DeltaX) ---
    line5:
        cmp     bx, dx
        jb      line7
        xchg    ax, cx
        xchg    bx, dx

    line7:
        push    cx
        sub     cx, ax
        mov     [deltax], cx
        pop     cx

        push    dx
        sub     dx, bx
        mov     [deltay], dx
        pop     dx

        mov     si, bx              ; SI = y atual

    line6:
        push    dx
        push    si
        push    ax
        sub     si, bx              ; dy_atual = (y - y1)
        mov     ax, [deltax]
        imul    si                  ; AX = (y - y1) * deltax
        mov     si, [deltay]        ; Fator de arredondamento
        shr     si, 1

        cmp     dx, 0
        jl      ar2
        add     ax, si
        adc     dx, 0
        jmp     arc2
    ar2:
        sub     ax, si
        sbb     dx, 0
    arc2:
        idiv    word [deltay]       ; X_calculado = ((y - y1) * deltax) / deltay
        mov     di, ax
        pop     ax
        add     di, ax              ; X_final = x1 + X_calculado
        pop     si

        push    di                  ; X
        push    si                  ; Y
        call    plot_xy

        pop     dx
        cmp     si, dx
        je      fim_line
        inc     si
        jmp     line6

    fim_line:
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        pop     bp
        ret     8                   ; Limpa 8 bytes da pilha

; ============================================================================
; SEGMENTO DE DADOS
; ============================================================================
segment data

cor             db      branco_intenso  ; Cor atual de desenho

; CONSTANTES DE CORES DA PALETA VGA (16 CORES)
; Formato dos bits do atributo: I R G B (Intensidade, Red, Green, Blue)
preto           equ     0               ; 0000b
azul            equ     1               ; 0001b
verde           equ     2               ; 0010b
cyan            equ     3               ; 0011b
vermelho        equ     4               ; 0100b
magenta         equ     5               ; 0101b
marrom          equ     6               ; 0110b
branco          equ     7               ; 0111b
cinza           equ     8               ; 1000b
azul_claro      equ     9               ; 1001b
verde_claro     equ     10              ; 1010b
cyan_claro      equ     11              ; 1011b
rosa            equ     12              ; 1100b
magenta_claro   equ     13              ; 1101b
amarelo         equ     14              ; 1110b
branco_intenso  equ     15              ; 1111b

modo_anterior   db      0
linha           dw      0
coluna          dw      0
deltax          dw      0
deltay          dw      0
mens            db      'AbCdEfGhIjKl'
mensdois        db      'Fernan'

tabela          db
centrox         db      319
centroy         db      239

; ============================================================================
; SEGMENTO DE PILHA
; ============================================================================
segment stack stack
    resb        512
stacktop: