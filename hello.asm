.model small                ; com program
.stack 100h                 ; code start here
.data                       ; define data segment
message db "hello world$"   ; message to be displayed terminating 
.code                       ; code segmemt
    Begin:
    mov dx,OFFSET message   ; offset og message terminating with $
    mov ax,SEG message      ; 
    mov ds,ax               
    mov ah,9d               ; function to terminate
    int 21h                 
    mov ah,4CH
    int 21h
    END Begin