[bits 32]
    org 0x10000
    db 0x7f, 'ELF'   e_indent
    dd 0x1
    dd 0x0
    dd $$
    dw 0x2
    dw 0x3
    dd _start
    dd _start
    dd 0x4
_next:
    mov dl, len
    mov al, 0x4
    int 0x80
    mov al, 0x1
    int 0x80
    dw 0x20
    dw 0x1
_start:
    mov bl, 0x1 
    mov ecx, str
    jmp _next
str:
    db 'Hello, World!', 0x0a
len: equ $ - str
