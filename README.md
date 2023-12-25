# 69 byte Hello World!
A Tiny Linux "Hello, World!".

## Simple explanation 
The entire code of this executable is crammed inside the ELF and program headers, which for 32-bit ELF files take up 52 and 32 bytes respectively, adding up to 84, but when you make those headers overlap you can get the size down to 69.

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
00000000: 7f45 4c46 0100 0000 0000 0000 0000 0100  .ELF............
00000010: 0200 0300 2e00 0100 2e00 0100 0400 0000  ................
00000020: b20e b004 cd80 b001 cd80 2000 0100 b301  .......... .....
00000030: b937 0001 00eb e948 656c 6c6f 2c20 576f  .7.....Hello, Wo
00000040: 726c 6421 0a                             rld!.
```
