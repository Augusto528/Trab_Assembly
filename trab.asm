segment code
..start:

    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, stacktop

    mov     ah, 0Fh
    int     10h
    mov     [modo_anterior], al

    mov     al, 12h
    mov     ah, 00h
    int     10h

    mov     byte [cor], branco_intenso
    call    desenhar_bordas_tela
    call    mostrar_texto_sair
    call    mostrar_texto_filtro_borda
    call    mostrar_texto_filtro_media
    call    mostrar_texto_agucamento
    call    mostrar_texto_abrir

    mov     ax, 0
    int     33h

    mov     ax, 1
    int     33h

    ; Aguarda os cliques do mouse.
    loop_mouse:

        mov     ax, 3
        int     33h

        test    bl, 00000001b
        jz      loop_mouse

        .esperar_soltar:
            mov     ax, 3
            int     33h
            test    bl, 00000001b
            jnz     .esperar_soltar

        call verificar_botao_abrir
        call verificar_botao_sair
        call verificar_botao_filtro_borda
        call verificar_botao_filtro_media
        call verificar_botao_agucamento

        jmp loop_mouse

    ; Restaura o modo de vídeo e encerra o programa.
    encerrar_programa:
        mov     ah, 00h
        mov     al, [modo_anterior]
        int     10h

        mov     ah, 4ch
        int     21h

    ; Desenha as bordas e divisões da tela.
    desenhar_bordas_tela:

        mov     ax,      0
        push    ax
        mov     ax,         0
        push    ax
        mov     ax,      639
        push    ax
        mov     ax,      0
        push    ax
        call    desenhar_linha

        mov     ax, 639
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 639
        push    ax
        mov     ax, 479
        push    ax
        call    desenhar_linha

        mov     ax, 639
        push    ax
        mov     ax, 479
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 479
        push    ax
        call    desenhar_linha

        mov     ax, 0
        push    ax
        mov     ax, 479
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 0
        push    ax
        call    desenhar_linha

        mov     ax, 320
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 320
        push    ax
        mov     ax, 400
        push    ax
        call    desenhar_linha

        mov     ax, 0
        push    ax
        mov     ax, 400
        push    ax
        mov     ax, 640
        push    ax
        mov     ax, 400
        push    ax
        call    desenhar_linha

        mov     ax, 0
        push    ax
        mov     ax, 80
        push    ax
        mov     ax, 640
        push    ax
        mov     ax, 80
        push    ax
        call    desenhar_linha

        mov     ax, 80
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 80
        push    ax
        mov     ax, 80
        push    ax
        call    desenhar_linha

        mov     ax, 160
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 160
        push    ax
        mov     ax, 80
        push    ax
        call    desenhar_linha

        mov     ax, 480
        push    ax
        mov     ax, 0
        push    ax
        mov     ax, 480
        push    ax
        mov     ax, 80
        push    ax
        call    desenhar_linha

    ret

    ; Mostra o texto do botão Abrir.
    mostrar_texto_abrir:
        mov     cx, 5
        mov     bx, 0
        mov     dh, 2
        mov     dl, 3

        .escrever:
            call    posicionar_cursor
            mov     al, [bx + abrir]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever

    ret

    ; Mostra o texto do botão Sair.
    mostrar_texto_sair:
        mov     cx, 4
        mov     bx, 0
        mov     dh, 2
        mov     dl, 13

        .escrever:
            call    posicionar_cursor
            mov     al, [bx + sair]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever

    ret

    ; Mostra o texto do filtro de borda.
    mostrar_texto_filtro_borda:
        mov     cx, 8
        mov     bx, 0
        mov     dh, 1
        mov     dl, 25

        .escrever:
            call    posicionar_cursor
            mov     al, [bx + deteccao]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever

        mov     cx, 8
        mov     bx, 0
        mov     dh, 3
        mov     dl, 25

        .escrever2:
            call    posicionar_cursor
            mov     al, [bx + borda]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever2

    ret

    ; Mostra o texto do filtro de média.
    mostrar_texto_filtro_media:
        mov     cx, 9
        mov     bx, 0
        mov     dh, 1
        mov     dl, 45

        .escrever:
            call    posicionar_cursor
            mov     al, [bx + filtro]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever

        mov     cx, 5
        mov     bx, 0
        mov     dh, 3
        mov     dl, 47

        .escrever2:
            call    posicionar_cursor
            mov     al, [bx + media]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever2

    ret

    ; Mostra o texto do filtro de aguçamento.
    mostrar_texto_agucamento:
        mov     cx, 10
        mov     bx, 0
        mov     dh, 2
        mov     dl, 65

        .escrever:
            call    posicionar_cursor
            mov     al, [bx + agucamento]
            call    escrever_caractere
            inc     bx
            inc     dl
            loop    .escrever

    ret

    ; Verifica se o botão Abrir foi selecionado.
    verificar_botao_abrir:
        cmp     cx, 0
        jb      .nada
        cmp     cx, 79
        ja      .nada
        cmp     dx, 0
        jb      .nada
        cmp     dx, 120
        ja      .nada

        push    ax
        push    bx
        push    cx
        push    dx

        mov     ax, 2
        int     33h

        mov     byte [cor], amarelo
        call    mostrar_texto_abrir

        mov     byte [cor], branco_intenso
        call    mostrar_texto_sair
        call    mostrar_texto_filtro_borda
        call    mostrar_texto_filtro_media
        call    mostrar_texto_agucamento

        mov     ax, 1
        int     33h

        call    carregar_imagem_arquivo
        jc      .pular_leitura

        .pular_leitura
        pop     dx
        pop     cx
        pop     bx
        pop     ax

        .nada:
            ret

    ; Verifica se o botão Sair foi selecionado.
    verificar_botao_sair:
        cmp     cx, 80
        jb      .nada

        cmp     cx, 160
        ja      .nada

        cmp     dx, 0
        jb      .nada

        cmp     dx, 120
        ja      .nada

        call    encerrar_programa

        .nada:
            ret

    ret

    ; Verifica se o filtro de borda foi selecionado.
    verificar_botao_filtro_borda:
        cmp     cx, 161
        jb      .nada

        cmp     cx, 320
        ja      .nada

        cmp     dx, 0
        jb      .nada

        cmp     dx, 120
        ja      .nada

        push    ax
        push    bx
        push    cx
        push    dx

        mov ax, 2
        int 33h

        mov byte[cor], cyan_claro
        call mostrar_texto_filtro_borda

        mov byte[cor], branco_intenso
        call    mostrar_texto_abrir
        call    mostrar_texto_sair
        call    mostrar_texto_filtro_media
        call    mostrar_texto_agucamento

        mov ax, 1
        int 33h

        call aplicar_filtro_borda

        pop     dx
        pop     cx
        pop     bx
        pop     ax

        .nada:
            ret

    ret

    ; Verifica se o filtro de média foi selecionado.
    verificar_botao_filtro_media:
        cmp cx, 321
        jb  .nada

        cmp cx, 480
        ja  .nada

        cmp dx, 0
        jb  .nada

        cmp dx, 120
        ja  .nada

        push    ax
        push    bx
        push    cx
        push    dx

        mov ax, 2
        int 33h

        mov byte [cor], vermelho
        call mostrar_texto_filtro_media

        mov byte[cor], branco_intenso
        call    mostrar_texto_abrir
        call    mostrar_texto_sair
        call    mostrar_texto_filtro_borda
        call    mostrar_texto_agucamento

        mov ax, 1
        int 33h

        call aplicar_filtro_media

        pop     dx
        pop     cx
        pop     bx
        pop     ax

        .nada:
            ret

    ret

    ; Verifica se o aguçamento foi selecionado.
    verificar_botao_agucamento:
        cmp cx, 481
        jb  .nada

        cmp cx, 639
        ja  .nada

        cmp dx, 0
        jb  .nada

        cmp dx, 120
        ja  .nada

        push    ax
        push    bx
        push    cx
        push    dx

        mov ax, 2
        int 33h

        mov byte [cor], verde_claro
        call mostrar_texto_agucamento

        mov byte[cor], branco_intenso
        call    mostrar_texto_abrir
        call    mostrar_texto_sair
        call    mostrar_texto_filtro_borda
        call    mostrar_texto_filtro_media

        mov ax, 1
        int 33h

        call aplicar_filtro_agucamento

        pop     dx
        pop     cx
        pop     bx
        pop     ax

        .nada:
            ret

    ret

    ; Abre o arquivo e carrega os pixels da imagem.
    carregar_imagem_arquivo:
            push    ax
            push    bx
            push    cx
            push    dx
            push    si
            push    di

            mov     ah, 3dh
            mov     al, 0
            mov     dx, arquivo_gatas
            int     21h
            jc      .erro

            mov     [file_handle], ax
            mov     si, [y_inicial]

            mov     word [linha], 0

        .loop_linhas_arq:
            mov     ax, [linha]
            inc     ax
            mov     cx, 242
            mul     cx
            inc     ax
            mov     di, ax

            mov     ah, 3fh
            mov     bx, [file_handle]
            mov     cx, 480
            mov     dx, buffer_linha
            int     21h

            cmp     ax, 0
            je      .fechar_arq

            mov     cx, [x_inicial]
            mov     bx, buffer_linha

        .loop_colunas_arq:
            mov     al, [bx]

            cmp     al, 32
            jbe     .avancar_ponteiro

            cmp     al, '9'
            jbe     .numero
            sub     al, 55
            jmp     .pintar

        .numero:
            sub     al, 48

        .pintar:
            mov     [buffer_padded + di], al
            inc     di

            mov     byte [cor], al
            push    cx
            push    si
            call    desenhar_pixel

        .avancar_ponteiro:
            add     bx, 2
            inc     cx

            mov     ax, [x_inicial]
            add     ax, 240
            cmp     cx, ax
            jb      .loop_colunas_arq

            inc     si
            inc     word [linha]

            cmp     word [linha], 240
            jb      .loop_linhas_arq

        .fechar_arq:
            mov     ah, 3eh
            mov     bx, [file_handle]
            int     21h
            clc
            jmp     .fim_abertura

        .erro:
            stc

        .fim_abertura:
            pop     di
            pop     si
            pop     dx
            pop     cx
            pop     bx
            pop     ax
            ret

    ; Posiciona o cursor de texto.
    posicionar_cursor:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp

        mov     ah, 2
        mov     bh, 0
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

    ; Escreve um caractere com a cor atual.
    escrever_caractere:
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp

        mov     ah, 9
        mov     bh, 0
        mov     cx, 1
        mov     bl, [cor]
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

    ; Desenha um pixel nas coordenadas recebidas.
    desenhar_pixel:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ah, 0ch
        mov     al, [cor]
        mov     bh, 0
        mov     cx, [bp+6]
        mov     dx, [bp+4]
        int     10h

        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        popf
        pop     bp
        ret     4

    ; Desenha o contorno de um círculo.
    desenhar_circulo:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+8]
        mov     bx, [bp+6]
        mov     cx, [bp+4]

        mov     dx, bx
        add     dx, cx
        push    ax
        push    dx
        call    desenhar_pixel

        mov     dx, bx
        sub     dx, cx
        push    ax
        push    dx
        call    desenhar_pixel

        mov     dx, ax
        add     dx, cx
        push    dx
        push    bx
        call    desenhar_pixel

        mov     dx, ax
        sub     dx, cx
        push    dx
        push    bx
        call    desenhar_pixel

        mov     di, cx
        sub     di, 1
        mov     dx, 0

    stay:
        mov     si, di
        cmp     si, 0
        jg      inf

        mov     si, dx
        sal     si, 1
        add     si, 3
        add     di, si
        inc     dx
        jmp     plotar

    inf:
        mov     si, dx
        sub     si, cx
        sal     si, 1
        add     si, 5
        add     di, si
        inc     dx
        dec     cx

    plotar:
        mov     si, dx
        add     si, ax
        push    si
        mov     si, cx
        add     si, bx
        push    si
        call    desenhar_pixel

        mov     si, ax
        add     si, dx
        push    si
        mov     si, bx
        sub     si, cx
        push    si
        call    desenhar_pixel

        mov     si, ax
        add     si, cx
        push    si
        mov     si, bx
        add     si, dx
        push    si
        call    desenhar_pixel

        mov     si, ax
        add     si, cx
        push    si
        mov     si, bx
        sub     si, dx
        push    si
        call    desenhar_pixel

        mov     si, ax
        sub     si, dx
        push    si
        mov     si, bx
        add     si, cx
        push    si
        call    desenhar_pixel

        mov     si, ax
        sub     si, dx
        push    si
        mov     si, bx
        sub     si, cx
        push    si
        call    desenhar_pixel

        mov     si, ax
        sub     si, cx
        push    si
        mov     si, bx
        sub     si, dx
        push    si
        call    desenhar_pixel

        mov     si, ax
        sub     si, cx
        push    si
        mov     si, bx
        add     si, dx
        push    si
        call    desenhar_pixel

        cmp     cx, dx
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
        ret     6

    ; Desenha um círculo preenchido.
    desenhar_circulo_preenchido:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+8]
        mov     bx, [bp+6]
        mov     cx, [bp+4]

        mov     si, bx
        sub     si, cx
        push    ax
        push    si
        mov     si, bx
        add     si, cx
        push    ax
        push    si
        call    desenhar_linha

        mov     di, cx
        sub     di, 1
        mov     dx, 0

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
        call    desenhar_linha

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
        call    desenhar_linha

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
        call    desenhar_linha

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
        call    desenhar_linha

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

    ; Desenha uma linha entre dois pontos.
    desenhar_linha:
        push    bp
        mov     bp, sp
        pushf
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di

        mov     ax, [bp+10]
        mov     bx, [bp+8]
        mov     cx, [bp+6]
        mov     dx, [bp+4]

        cmp     ax, cx
        je      line2
        jb      line1
        xchg    ax, cx
        xchg    bx, dx
        jmp     line1

    line2:
        cmp     bx, dx
        jb      line3
        xchg    bx, dx

    line3:
        push    ax
        push    bx
        call    desenhar_pixel
        cmp     bx, dx
        jne     line31
        jmp     fim_line
    line31:
        inc     bx
        jmp     line3

    line1:
        push    cx
        sub     cx, ax
        mov     [deltax], cx
        pop     cx

        push    dx
        sub     dx, bx
        ja      line32
        neg     dx
    line32:
        mov     [deltay], dx
        pop     dx

        push    ax
        mov     ax, [deltax]
        cmp     ax, [deltay]
        pop     ax
        jb      line5

        push    cx
        sub     cx, ax
        mov     [deltax], cx
        pop     cx

        push    dx
        sub     dx, bx
        mov     [deltay], dx
        pop     dx

        mov     si, ax

    line4:
        push    ax
        push    dx
        push    si
        sub     si, ax
        mov     ax, [deltay]
        imul    si
        mov     si, [deltax]
        shr     si, 1

        cmp     dx, 0
        jl      ar1
        add     ax, si
        adc     dx, 0
        jmp     arc1
    ar1:
        sub     ax, si
        sbb     dx, 0
    arc1:
        idiv    word [deltax]
        add     ax, bx
        pop     si

        push    si
        push    ax
        call    desenhar_pixel

        pop     dx
        pop     ax
        cmp     si, cx
        je      fim_line
        inc     si
        jmp     line4

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

        mov     si, bx

    line6:
        push    dx
        push    si
        push    ax
        sub     si, bx
        mov     ax, [deltax]
        imul    si
        mov     si, [deltay]
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
        idiv    word [deltay]
        mov     di, ax
        pop     ax
        add     di, ax
        pop     si

        push    di
        push    si
        call    desenhar_pixel

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
        ret     8

    ; Aplica o filtro de detecção de bordas.
    aplicar_filtro_borda:
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, 0

        .loop_linhas:
            mov dx, 0

        .loop_colunas:

            push dx

            mov ax, cx
            inc ax
            mov bx, 242
            mul bx

            pop dx

            add ax, dx
            inc ax
            mov si, ax

            xor bx, bx

            mov al, [buffer_padded + si - 243]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si - 242]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si - 241]
            cbw
            sub bx, ax

            mov al, [buffer_padded + si - 1]
            cbw
            sub bx, ax

            mov al, [buffer_padded + si]
            mov ah, 0
            shl ax, 3
            add bx, ax

            mov al, [buffer_padded + si + 241]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si + 242]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si + 243]
            cbw
            sub bx, ax

            mov ax, bx
            cmp ax, 0
            jge .verifica_teto
            mov ax, 0
            jmp .desenhar_pixel

        .verifica_teto:
            cmp ax, 15
            jle .desenhar_pixel
            mov ax, 15

        .desenhar_pixel:
            mov [cor], al

            mov ax, [x_inicial]
            add ax, 320
            add ax, dx
            push ax

            mov ax, [y_inicial]
            add ax, cx
            push ax

            call desenhar_pixel

            inc dx
            cmp dx, 240
            jae .fim_loop_colunas
            jmp .loop_colunas
        .fim_loop_colunas:

            inc cx
            cmp cx, 240
            jae .fim_loop_linhas
            jmp .loop_linhas
        .fim_loop_linhas:

            pop di
            pop si
            pop dx
            pop cx
            pop bx
            pop ax
            ret

    ; Aplica o filtro de média na imagem.
    aplicar_filtro_media:
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, 0

        .loop_linhas_f:
            mov dx, 0

        .loop_colunas_f:
            push dx
            mov ax, cx
            inc ax
            mov bx, 242
            mul bx
            pop dx

            add ax, dx
            inc ax
            mov si, ax

            xor bx, bx

            mov al, [buffer_padded + si - 243]
            cbw
            add bx, ax
            mov al, [buffer_padded + si - 242]
            cbw
            add bx, ax
            mov al, [buffer_padded + si - 241]
            cbw
            add bx, ax

            mov al, [buffer_padded + si - 1]
            cbw
            add bx, ax
            mov al, [buffer_padded + si]
            cbw
            add bx, ax
            mov al, [buffer_padded + si + 1]
            cbw
            add bx, ax

            mov al, [buffer_padded + si + 241]
            cbw
            add bx, ax
            mov al, [buffer_padded + si + 242]
            cbw
            add bx, ax
            mov al, [buffer_padded + si + 243]
            cbw
            add bx, ax

            mov ax, bx
            mov bx, 9
            push dx
            xor dx, dx
            div bx
            pop dx

            mov [cor], al

            mov ax, [x_inicial]
            add ax, 320
            add ax, dx
            push ax

            mov ax, [y_inicial]
            add ax, cx
            push ax

            call desenhar_pixel

            inc dx
            cmp dx, 240
            jae .fim_loop_colunas_f
            jmp .loop_colunas_f
        .fim_loop_colunas_f:

            inc cx
            cmp cx, 240
            jae .fim_loop_linhas_f
            jmp .loop_linhas_f
        .fim_loop_linhas_f:

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    ; Aplica o filtro de aguçamento na imagem.
    aplicar_filtro_agucamento:
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, 0

        .loop_linhas_a:
            mov dx, 0

        .loop_colunas_a:
            push dx
            mov ax, cx
            inc ax
            mov bx, 242
            mul bx
            pop dx

            add ax, dx
            inc ax
            mov si, ax

            xor bx, bx

            mov al, [buffer_padded + si - 243]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si - 242]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si - 241]
            cbw
            sub bx, ax

            mov al, [buffer_padded + si - 1]
            cbw
            sub bx, ax

            mov al, [buffer_padded + si]
            mov ah, 0
            mov di, ax
            shl ax, 3
            add ax, di
            add bx, ax

            mov al, [buffer_padded + si + 241]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si + 242]
            cbw
            sub bx, ax
            mov al, [buffer_padded + si + 243]
            cbw
            sub bx, ax

            mov ax, bx
            cmp ax, 0
            jge .verifica_teto_a
            mov ax, 0
            jmp .desenhar_pixel_a

        .verifica_teto_a:
            cmp ax, 15
            jle .desenhar_pixel_a
            mov ax, 15

        .desenhar_pixel_a:
            mov [cor], al

            mov ax, [x_inicial]
            add ax, 320
            add ax, dx
            push ax

            mov ax, [y_inicial]
            add ax, cx
            push ax

            call desenhar_pixel

            inc dx
            cmp dx, 240
            jae .fim_loop_colunas_a
            jmp .loop_colunas_a
        .fim_loop_colunas_a:

            inc cx
            cmp cx, 240
            jae .fim_loop_linhas_a
            jmp .loop_linhas_a
        .fim_loop_linhas_a:

            pop di
            pop si
            pop dx
            pop cx
            pop bx
            pop ax
            ret

segment data

    cor             db      branco_intenso

    preto           equ     0
    azul            equ     1
    verde           equ     2
    cyan            equ     3
    vermelho        equ     4
    magenta         equ     5
    marrom          equ     6
    branco          equ     7
    cinza           equ     8
    azul_claro      equ     9
    verde_claro     equ     10
    cyan_claro      equ     11
    rosa            equ     12
    magenta_claro   equ     13
    amarelo         equ     14
    branco_intenso  equ     15

    modo_anterior   db      0
    linha           dw      0
    coluna          dw      0
    deltax          dw      0
    deltay          dw      0
    mens            db      'AbCdEfGhIjKl'

    abrir           db      'ABRIR'
    sair            db      'SAIR'
    deteccao        db      'DETEC', 0x80, 0x84, 'O'
    borda           db      'de BORDA'
    filtro          db      'FILTRO de'
    media           db      'M', 0x90, 'DIA'
    agucamento      db      'AGU', 0x80, 'AMENTO'

    file_handle     dw      0
    buffer_linha    resb    480
    x_inicial       dw      40
    y_inicial       dw      120

    arquivo_gatas   db      'gatas.txt', 0
    handler         dw      0

    buffer_padded          times 58564 db 0

segment stack stack
    resb 512
stacktop:

