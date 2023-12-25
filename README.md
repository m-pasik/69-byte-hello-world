# 76 byte Hello World!
A Tiny Linux "Hello, World!".

## Simple explanation 
The entire code of this executable is crammed inside the ELF and program headers, which for 32-bit ELF files take up 52 and 32 bytes respectively, adding up to 84, but if you make the program header begin before the file header ends it's possible to get it down to 76 (maybe smaller but idk if I'd fit everything I need inside).

## How to build?
To generate the executable simply run:
```
make
```
and the executable will be called `hello`. 

Note: You need to have `make` and `nasm` installed.

## Hex dump
This is how the executable looks when represented as hex.
```
00000000: 7f45 4c46 4865 6c6c 6f2c 2057 6f72 6c64  .ELFHello, World
00000010: 0200 0300 b004 eb08 1400 0100 2c00 0000  ............,...
00000020: b904 0001 008b 7134 eb10 2000 0100 0000  ......q4.. .....
00000030: 0000 0000 0000 0100 210a b20e 6689 710c  ........!...f.q.
00000040: 6689 710c b301 cd80 b001 cd80            f.q.........
```

## Code overview
In order to print "Hello, World!\n", which (at least if you include comma and an exclamation mark) doesn't fit in any single useable block of memory in the headers I ended up having to make some self-modifying code.
```asm
; [...]

str1: db 'Hello, World'     ; First part of the string
len1: equ $ - str1          ; Length of the first string

; [...]

x14:
    mov al, 0x4             ; System call number (sys_write)
    jmp x20                 ; Jump to the next block of code (at 0x20)

; [...]

x20:
    mov ecx, str1           ; Address of "Hello, World" string
    mov esi, [ecx + offset] ; Move second string to esi
    jmp x3a                 ; Jump to the next block of code (at 0x3a)

; [...]

offset: equ $ - str1        ; Offset of second string from the beginning of the first
str2: db '!', 0xa           ; Second part of the string
len2: equ $ - str2          ; Length of the seconds string

x3a:
    mov dl, len1 + len2     ; Length of the full string
    mov [ecx + len1], si    ; Move "!\n" to the end of the first string
    ; [...]
    mov bl, 0x1             ; File descriptor (stdout)
    int 0x80                ; Invoke system call
    mov al, 0x1             ; System call number (sys_exit)
    int 0x80                ; Invoke system call
```
You can find more information in the comments inside hello.asm file
