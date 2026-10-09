segment dados
  mensini  db 'Serie de Fibonacci',13,10,'$'
  mensfim  db 'bye',13,10,'$'
  saida    db '00000',13,10,'$'


segment code
..start:
  mov ax, dados
  mov ds, ax
  mov ax, stack
  mov ss, ax
  mov sp, stacktop

  mov dx,mensini ; Mensagem de inicio
  mov ah,9  
  int 21h 

  mov dx,mensini ; Mensagem de inicio
  mov ah,9  
  int 21h 

  mov ax, 0 ; Primeiro elemento da série
  mov bx, 1 ; Segundo elemento da série

proximo_numero:
  add ax, bx
  mov dx, ax ; Calcula novo número da série
  mov ax, bx
  mov bx, dx
  cmp dx, 0x8000
  jb proximo_numero

exit:
  mov dx,mensfim ; Mensagem final
  mov ah,9
  int 21h

quit:
  mov ax,4c00H
  int 21h


segment stack stack
  resb 256
stacktop: