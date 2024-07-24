.MODEL SMALL
.STACK 100h

.DATA
    prompt DB 'Enter 5 numbers (0-9): $'
    newline DB 13, 10, '$'        ; Carriage return and line feed
    smallest DB 'Smallest: $'
    largest DB 'Largest: $'
    ascending DB 'Ascending: $'
    descending DB 'Descending: $'
    space DB ' $'
    numbers DB 5 DUP(?)           ; Array to store 5 numbers

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX                    ; Set up data segment

    ; Display prompt
    LEA DX, prompt
    MOV AH, 9                     ; DOS function to print string
    INT 21h

    ; Input 5 numbers
    MOV CX, 5                     ; Counter for loop
    LEA SI, numbers               ; Load address of numbers array
INPUT_LOOP:
    MOV AH, 1                     ; DOS function to read character
    INT 21h
    SUB AL, '0'                   ; Convert ASCII to number
    MOV [SI], AL                  ; Store number in array
    INC SI                        ; Move to next array element
    MOV AH, 2                     ; DOS function to print character
    MOV DL, ' '                   ; Print space between numbers
    INT 21h
    LOOP INPUT_LOOP

    ; Print newline
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Find smallest and largest
    MOV CX, 5                     ; Counter for loop
    LEA SI, numbers               ; Reset SI to start of array
    MOV AL, [SI]                  ; Assume first number is both smallest and largest
    MOV BL, AL
FIND_LOOP:
    MOV DL, [SI]
    CMP DL, AL
    JGE NOT_SMALLER               ; Jump if DL >= AL
    MOV AL, DL                    ; Update smallest
NOT_SMALLER:
    CMP DL, BL
    JLE NOT_LARGER                ; Jump if DL <= BL
    MOV BL, DL                    ; Update largest
NOT_LARGER:
    INC SI
    LOOP FIND_LOOP

    ; Print smallest
    LEA DX, smallest
    MOV AH, 9
    INT 21h
    MOV DL, AL
    ADD DL, '0'                   ; Convert number back to ASCII
    MOV AH, 2
    INT 21h
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Print largest
    LEA DX, largest
    MOV AH, 9
    INT 21h
    MOV DL, BL
    ADD DL, '0'                   ; Convert number back to ASCII
    MOV AH, 2
    INT 21h
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Sort in ascending order (Bubble Sort)
    MOV CX, 4                     ; Outer loop counter (n-1 passes)
OUTER_LOOP:
    MOV SI, OFFSET numbers
    PUSH CX                       ; Save outer loop counter
    MOV CX, 4                     ; Inner loop counter
INNER_LOOP:
    MOV AL, [SI]
    CMP AL, [SI+1]
    JLE SKIP_SWAP                 ; If AL <= [SI+1], no swap needed
    XCHG AL, [SI+1]               ; Swap elements
    MOV [SI], AL
SKIP_SWAP:
    INC SI
    LOOP INNER_LOOP
    POP CX                        ; Restore outer loop counter
    LOOP OUTER_LOOP

    ; Print in ascending order
    LEA DX, ascending
    MOV AH, 9
    INT 21h
    MOV CX, 5                     ; Counter for loop
    LEA SI, numbers
PRINT_ASC:
    MOV DL, [SI]
    ADD DL, '0'                   ; Convert number to ASCII
    MOV AH, 2
    INT 21h
    LEA DX, space
    MOV AH, 9
    INT 21h
    INC SI
    LOOP PRINT_ASC
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Print in descending order
    LEA DX, descending
    MOV AH, 9
    INT 21h
    MOV CX, 5                     ; Counter for loop
    LEA SI, numbers
    ADD SI, 4                     ; Start from the end of the array
PRINT_DESC:
    MOV DL, [SI]
    ADD DL, '0'                   ; Convert number to ASCII
    MOV AH, 2
    INT 21h
    LEA DX, space
    MOV AH, 9
    INT 21h
    DEC SI                        ; Move backwards through the array
    LOOP PRINT_DESC

    ; Exit program
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN