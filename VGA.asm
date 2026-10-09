segment code
..start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, stacktop

    

    mov ah, 4Ch 
    int 21h 

segment data    
    

segment stack stack
    resb 256
stacktop: