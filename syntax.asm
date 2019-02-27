; read a byte from stdin
mov eax, 3               ; 3 is recognized by the system as meaning "read"
mov ebx, 0               ; read from standard input
mov ecx, variable    ; address to pass to
mov edx, 1               ; input length (one byte)
int 0x80             ; call the kernel

; print a byte to stdout
mov eax, 4           ; the system interprets 4 as "write"
mov ebx, 1           ; standard output (print to terminal)
mov ecx, variable    ; pointer to the value being passed
mov edx, 1           ; length of output (in bytes)
int 0x80             ; call the kernel