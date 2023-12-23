# 76-byte-hello-world
This *might* be the smallest Linux "Hello World" that can be made.

The entire code of this executable is crammed inside the ELF and program headers, which for 32-bit ELF files take up 52 and 32 bytes respectively, adding up to 84, but if you make the program header begin before the file header ends it's possible to get it down to 76. 

Considering that you can't make an executable that has no file and program headers, this is (probably?) the smallest possible Linux executable that prints "Hello World".
