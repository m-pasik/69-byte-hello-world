[bits 32]
org 0x10000                     ; Where the code is placed in memory

; Beginning of the ELF header

db 0x7f, 'ELF'                  ; Magic number

msg: db 'Hello World', 0xa      ; Message (overwrites part of e_indent)

dw 0x2                          ; Object file type (executable)
dw 0x3                          ; Instruction set architecture (x86)

; This code overwrites e_version (object file version)
x14:
    mov al, 0x4                 ; System call number (sys_write)
    jmp x20                     ; Jump to the next block of code (at 0x20)

dd x14                          ; Entry point
dd 0x2c                         ; Start of the program header table (0x2c)

x20:
    mov dl, 0xc                 ; Length of the string (12)
    mov ecx, msg                ; Address of "Hello World\n" string
    jmp x44                     ; Jump to the next block of code (at 0x44)

db 0x0                          ; Second byte of e_ehsize entry (the first one was overwritten)
dw 0x20                         ; Size of a program header table entry

; Beginning of the program header
; The start of the header table was set to 0x2c which is before the end of the ELF header
; As a result headers overlap

dd 0x1                          ; Type of the segment (loadable).
                                ; It overlaps with two 2-byte fields in the file header:
                                ; e_phentsize (number of entries in the program header table)
                                ; and e_phnum (size of each entry, which can be 0, since it gets ignored)
dd 0x0                          ; Offset of the segment in the file image.
                                ; Overlaps with fields that need to be 0 due to lack of section header table.

; End of the ELF header

dd 0x10000                      ; Virtual address of the segment in memory
dd 0x0                          ; Physical address of the segment in memory (only on systems where relevant)
dd 0x4c                         ; Size in bytes of the segment in the file image
dd 0x4c                         ; Size in bytes of the segment in memory

; This code overwrites p_flags and part of p_align.
x44:
    mov bl, 0x1                 ; File descriptor (stdout)
    int 0x80                    ; Invoke system call
    mov al, 0x1                 ; System call number (sys_exit)
    int 0x80                    ; Invoke system call

