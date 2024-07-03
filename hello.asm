.model small
.stack 100h
.data
message db "hello world$"
.code
    Begin:
    mov dx,OFFSET message
    mov ax,SEG message
    mov ds,ax
    mov ah,9d
    int 21h
    mov ah,4CH
    int 21h
    END Begin