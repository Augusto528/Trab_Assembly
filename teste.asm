segment dados
    saida   db '00000', 13, 10, '$'

segment code
..start:

    mov ax, dados
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, stacktop

    mov di, saida
    add di, 4 ; '0000*'

    mov cx, 4
    mov ax, 0
    add ax, 5c1ah

    divisao:
    div ax, 0xA
    mov [di], ah
    sub di, 1

    mov dx, saida
    mov ah, 9
    int 21h

    cmp ax, 0x00
    jne divisao



segment stack stack
    resb 256
    stacktop: