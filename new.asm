Data segment
msg db 0dh. 0ah, "Enter first number: $"
msgl db 0dh, 0ah, "Enter second number: $"
result 0dh, 0ah, "The Result is: $"

Data ends
Code segment
    assume CS:Code,DS:Data
start:
    mov Data ; Move Data to Data Segment add8
    mov ax
    
    mov dx,offset msg ; Display contents of variable msg
    mov ah, 09h
    int 2lh
    
    mov ab,01h
    int 21h
    
    sub al,30h
    mov bl,al