.MODEL SMALL
.STACK 100h

.DATA
prompt1 DB 'Enter first string: $'
prompt2 DB 'Enter second string: $'
string1 DB 50, ?, 50 DUP(?)  ; First byte is max length, second is actual length
string2 DB 50, ?, 50 DUP(?)
equal_msg DB 0Dh,0Ah,'Strings are equal$'
not_equal_msg DB 0Dh,0Ah,'Strings are not equal$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Prompt for first string
    MOV AH, 09h
    LEA DX, prompt1
    INT 21h

    ; Read first string
    MOV AH, 0Ah
    LEA DX, string1
    INT 21h

    ; Move to new line
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV DL, 0Ah
    INT 21h

    ; Prompt for second string
    MOV AH, 09h
    LEA DX, prompt2
    INT 21h

    ; Read second string
    MOV AH, 0Ah
    LEA DX, string2
    INT 21h

    ; Compare strings
    LEA SI, string1 + 2  ; Skip length bytes
    LEA DI, string2 + 2
    MOV CL, string1 + 1  ; Actual length of string1
    MOV CH, 0            ; Clear CH to use CX as counter

compare_loop:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE not_equal
    INC SI
    INC DI
    LOOP compare_loop

    ; If we've reached here, all compared characters were equal
    ; Now check if string2 has ended as well
    MOV AL, [DI]
    CMP AL, 0Dh
    JNE not_equal
    JMP equal

equal:
    LEA DX, equal_msg
    JMP print

not_equal:
    LEA DX, not_equal_msg

print:
    MOV AH, 09h
    INT 21h

    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN