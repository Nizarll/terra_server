section .text
  hello db 'Hello, World!',0
global _start

_start:
    mov  eax, 4
    mov  ebx, 1
    mov  ecx, hello
    mov  edx, 0xd
    int  0x80
    mov  eax, 1
    xor  ebx, ebx
    int  0x80

