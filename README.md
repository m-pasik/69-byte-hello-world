# 76-byte-hello-world
This *might* be the smallest Linux "Hello World" that can be made.

## Simple explanation 
The entire code of this executable is crammed inside the ELF and program headers, which for 32-bit ELF files take up 52 and 32 bytes respectively, adding up to 84, but if you make the program header begin before the file header ends it's possible to get it down to 76. 

Considering that you can't make an executable that has no file and program headers, this is (probably?) the smallest possible Linux executable that prints "Hello World".

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
00000000: 7f45 4c46 4865 6c6c 6f20 576f 726c 640a  .ELFHello World.
00000010: 0200 0300 b004 eb08 1400 0100 2c00 0000  ............,...
00000020: b20c b904 0001 00eb 1b00 2000 0100 0000  .......... .....
00000030: 0000 0000 0000 0100 0000 0000 4c00 0000  ............L...
00000040: 4c00 0000 b301 cd80 b001 cd80            L...........
```

## Code overview
The code isn't really very complicated. It's basically just what you'd see in some assembly tutorial, but crammed into the header of the executable.
```asm
x14:
    mov al, 0x4         ; System call number (sys_write)
    jmp x20             ; Jump to the next block of code (at 0x20)
x20:
    mov dl, 0xc         ; Length of the string (12)
    mov ecx, msg        ; Address of "Hello World\n" string
    jmp x44             ; Jump to the next block of code (at 0x44)
x44:
    mov bl, 0x1         ; File descriptor (stdout)
    int 0x80            ; Invoke system call
    mov al, 0x1         ; System call number (sys_exit)
    int 0x80            ; Invoke system call
```
You can find more information in the comments inside hello.asm file
