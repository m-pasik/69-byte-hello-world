[bits 32]
org 0x10000                 ; Where the code is placed in memory

; Beginning of the ELF header

db 0x7f, 'ELF'              ; Magic number

str1: db 'Hello, World'     ; First part of the string (overwrites part of e_indent)
len1: equ $ - str1          ; Length of the first string

dw 0x2                      ; Object file type (executable)
dw 0x3                      ; Instruction set architecture (x86)

; This code overwrites e_version (object file version)
x14:
    mov al, 0x4             ; System call number (sys_write)
    jmp x20                 ; Jump to the next block of code (at 0x20)

dd x14                      ; Entry point
dd 0x2c                     ; Start of the program header table (0x2c)

x20:
    mov ecx, str1           ; Address of "Hello, World" string
    mov esi, [ecx + offset] ; Move second string to esi
    jmp x3a                 ; Jump to the next block of code (at 0x3a)

dw 0x20                     ; Size of a program header table entry

; Beginning of the program header
; The start of the header table was set to 0x2c which is before the end of the ELF header
; As a result headers overlap

dd 0x1                      ; Type of the segment (loadable).
                            ; It overlaps with two 2-byte fields in the file header:
                            ; e_phentsize (number of entries in the program header table)
                            ; and e_phnum (size of each entry, which can be 0, since it gets ignored)
dd 0x0                      ; Offset of the segment in the file image.
                            ; Overlaps with fields that need to be 0 due to lack of section header table.

; End of the ELF header

dd 0x10000                  ; Virtual address of the segment in memory

offset: equ $ - str1        ; Offset of second string from the beginning of the first
str2: db '!', 0xa           ; Second part of the string, overwrites p_paddr (physical address)
                            ; which only matters on systems where physical address is relevant
len2: equ $ - str2          ; Length of the seconds string

; This code overwrites second half of the physical address field
; As well as p_filesz, p_memsz, p_flags and p_align
x3a:
    mov dl, len1 + len2     ; Length of the full string
    mov [ecx + len1], si    ; Move "!\n" to the end of the first string
    mov [ecx + len1], si    ; The instruction is duplicated so that p_filesz and p_memsz are the same
    mov bl, 0x1             ; File descriptor (stdout)
    int 0x80                ; Invoke system call
    mov al, 0x1             ; System call number (sys_exit)
    int 0x80                ; Invoke system call
