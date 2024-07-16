section .data
    sentence db "The quick brown fox jumps over the lazy dog", 0
    result db "Number of 'e's: ", 0
    
section .bss
    count resb 1

section .text
    global _start

_start:
    mov ecx, sentence    ; Load address of sentence into ecx
    xor eax, eax         ; Initialize counter (eax) to 0

count_loop:
    mov bl, [ecx]        ; Load current character into bl
    test bl, bl          ; Check if it's null terminator
    jz done              ; If so, we're done counting
    
    cmp bl, 'e'          ; Compare with lowercase 'e'
    jne next_char        ; If not 'e', move to next character
    inc eax              ; If 'e', increment counter

next_char:
    inc ecx              ; Move to next character
    jmp count_loop       ; Continue loop

done:
    add al, '0'          ; Convert count to ASCII
    mov [count], al      ; Store result

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 19
    int 0x80

    ; Print count
    mov eax, 4
    mov ebx, 1
    mov ecx, count
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80