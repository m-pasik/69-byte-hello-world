# 76-byte-hello-world
This *might* be the smallest Linux "Hello World" that can be made.

## Simple explanation 
The entire code of this executable is crammed inside the ELF and program headers, which for 32-bit ELF files take up 52 and 32 bytes respectively, adding up to 84, but if you make the program header begin before the file header ends it's possible to get it down to 76. 

Considering that you can't make an executable that has no file and program headers, this is (probably?) the smallest possible Linux executable that prints "Hello World".

## Hex dump
This is how the executable looks when represented as hex.
```
00000000: 7f45 4c46 4865 6c6c 6f20 576f 726c 640a  .ELFHello World.
00000010: 0200 0300 b004 eb08 1400 0100 2c00 0000  ............,...
00000020: b301 b904 0001 00eb 0f00 2000 0100 0000  .......... .....
00000030: 0000 0000 0000 0100 b20c eb09 1f00 0000  ................
00000040: 1f00 0000 01cd 80b0 01cd 8000            ............
```

## Code explanation
The code isn't really very complicated. It's basically just what you'd see in some assembly tutorial, but crammed into the header of the executable.
```gas
0x14:
    mov $0x4, %al       # system call number (sys_write)
    jmp 0x20            # jump to the next segment
0x20:
    mov $0x1, %bl       # file descriptor (stdout) 
    mov $0x10004, %ecx  # address where "Hello World\n" string is stored
    jmp 0x38            # jump to the next segment
0x38:
    mov $0xc, %dl       # length of the string
    jmp 0x45            # jump to the next segment
0x45:
    int $0x80           # invoke system call 
    mov $0x1, %al       # system call number (sys_exit)
    int $0x80           # invoke system call
```
