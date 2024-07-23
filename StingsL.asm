.model small
.stack 100h
.data
    my_string db 'Hello, World!$'
    len dw ?

.code
main proc
    mov ax, @data
    mov ds, ax

    mov si, offset my_string
    xor cx, cx
    
loop_len:
    lodsb
    cmp al, '$'
    je done
    inc cx
    jmp loop_len
    
done:
    mov [len], cx

    mov ax, 4C00h
    int 21h
main endp
end main