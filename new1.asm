.MODEL SMALL
.STACK 100h

.DATA
    prompt DB 'Enter up to 20 numbers (0-999) separated by spaces, end with Enter: $'
    newline DB 13, 10, '$'
    smallest DB 'Smallest: $'
    largest DB 'Largest: $'
    ascending DB 'Ascending: $'
    descending DB 'Descending: $'
    space DB ' $'
    numbers DW 20 DUP(?)          ; Array to store up to 20 numbers (word-sized)
    count DW 0                    ; Counter for number of inputs

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    LEA DX, prompt
    MOV AH, 9
    INT 21h

    ; Input numbers
    XOR BX, BX                    ; BX will hold the current number
    MOV SI, 0                     ; SI is the index for numbers array
INPUT_LOOP:
    MOV AH, 1                     ; Read a character
    INT 21h
    CMP AL, 13                    ; Check for Enter key
    JE STORE_LAST_NUMBER
    CMP AL, ' '                   ; Check for space
    JE STORE_NUMBER
    SUB AL, '0'                   ; Convert ASCII to number
    MOV CL, AL
    MOV AX, BX                    ; Multiply current number by 10
    MOV DX, 10
    MUL DX
    ADD AX, CX                    ; Add new digit
    MOV BX, AX                    ; Store back in BX
    JMP INPUT_LOOP
STORE_NUMBER:
    MOV numbers[SI], BX           ; Store the number in array
    ADD SI, 2                     ; Move to next word in array
    INC count                     ; Increment count
    XOR BX, BX                    ; Reset BX for next number
    JMP INPUT_LOOP
STORE_LAST_NUMBER:
    MOV numbers[SI], BX           ; Store last number
    INC count

    ; Print newline
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Find smallest and largest
    MOV CX, count
    MOV SI, 0
    MOV AX, numbers[SI]           ; Initialize smallest with first number
    MOV BX, AX                    ; Initialize largest with first number
    ADD SI, 2                     ; Move to next number in array

FIND_LOOP:
    CMP SI, CX                    ; Check if end of array is reached
    JAE FIND_DONE

    MOV DX, numbers[SI]
    CMP DX, AX
    JL UPDATE_SMALLEST
    CMP DX, BX
    JG UPDATE_LARGEST

    JMP CONTINUE_FIND

UPDATE_SMALLEST:
    MOV AX, DX                    ; Update smallest
    JMP CONTINUE_FIND

UPDATE_LARGEST:
    MOV BX, DX                    ; Update largest
    JMP CONTINUE_FIND

CONTINUE_FIND:
    ADD SI, 2                     ; Move to next number in array
    JMP FIND_LOOP

FIND_DONE:

    ; Print smallest
    LEA DX, smallest
    MOV AH, 9
    INT 21h
    MOV AX, AX                    ; Move smallest to AX for printing
    CALL PRINT_NUMBER
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Print largest
    LEA DX, largest
    MOV AH, 9
    INT 21h
    MOV AX, BX                    ; Move largest to AX for printing
    CALL PRINT_NUMBER
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Sort in ascending order (Bubble Sort)
    MOV CX, count
    DEC CX                        ; Outer loop counter (n-1 passes)
OUTER_LOOP:
    MOV SI, 0                     ; Start from beginning of array
    PUSH CX                       ; Save outer loop counter
    MOV DI, CX                    ; Inner loop counter
INNER_LOOP:
    MOV AX, numbers[SI]
    CMP AX, numbers[SI+2]
    JLE SKIP_SWAP
    XCHG AX, numbers[SI+2]        ; Swap elements
    MOV numbers[SI], AX
SKIP_SWAP:
    ADD SI, 2                     ; Move to next pair of elements
    DEC DI
    JNZ INNER_LOOP
    POP CX                        ; Restore outer loop counter
    LOOP OUTER_LOOP

    ; Print in ascending order
    LEA DX, ascending
    MOV AH, 9
    INT 21h
    MOV CX, count
    MOV SI, 0
PRINT_ASC:
    MOV AX, numbers[SI]
    CALL PRINT_NUMBER
    LEA DX, space
    MOV AH, 9
    INT 21h
    ADD SI, 2
    LOOP PRINT_ASC
    LEA DX, newline
    MOV AH, 9
    INT 21h

    ; Print in descending order
    LEA DX, descending
    MOV AH, 9
    INT 21h
    MOV CX, count
    MOV AX, count
    DEC AX
    SHL AX, 1                     ; Multiply by 2 to get byte offset
    MOV SI, AX                    ; Start from the end of the array
PRINT_DESC:
    MOV AX, numbers[SI]
    CALL PRINT_NUMBER
    LEA DX, space
    MOV AH, 9
    INT 21h
    SUB SI, 2
    LOOP PRINT_DESC

    ; Exit program
    MOV AH, 4Ch
    INT 21h

MAIN ENDP

; Procedure to print a number in AX
PRINT_NUMBER PROC
    PUSH BX
    PUSH CX
    PUSH DX

    XOR CX, CX                    ; Digit counter
    MOV BX, 10                    ; Divisor
DIVIDE_LOOP:
    XOR DX, DX                    ; Clear DX for division
    DIV BX                        ; Divide AX by 10
    PUSH DX                       ; Push remainder (digit) onto stack
    INC CX                        ; Increment digit counter
    TEST AX, AX                   ; Check if quotient is zero
    JNZ DIVIDE_LOOP               ; If not, continue dividing

PRINT_LOOP:
    POP DX                        ; Pop digit from stack
    ADD DL, '0'                   ; Convert to ASCII
    MOV AH, 2                     ; Print character function
    INT 21h
    LOOP PRINT_LOOP

    POP DX
    POP CX
    POP BX
    RET
PRINT_NUMBER ENDP

END MAIN
