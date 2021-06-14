%define MAXINT 0x7FFFFFFF
%define MININT 0x80000000

        section .text
        global eval
eval:
; prologue
        push ebp                ; save caller's frame pointer
        mov ebp, esp            ; set own frame pointer

        push ebx        
        push esi
        push edi

        mov eax, [ebp + 8]      ; argument - pointer to string

        mov ebp, esp

        xor ebx, ebx            ; zeroing the flag register
        xor edi, edi            ; zeroing the temporary result register

eval_loop:
        xor edx, edx            ; load only a byte from memory into lower byte of edx
                                ; rest of edx set to zero
        mov dl, [eax]           ; read char from string
        inc eax                 ; increment pointer

        test dl, dl             ; test if it is end of string
        jz finish               ; yes - return output

        cmp dl, '0'             
        jb operator_check      

        cmp dl, '9'
        ja eval_loop            ; skip char if it is invalid

.convert_num: 
        sub dl, '0'             ; convert to number 
        imul edi, 10            ; make space for next digit in ebx
        jo input_overflow
        
        cmp bl, 1               ; test if negative input flag is set
        jne .store_temp_num           
        neg edx                 ; negate if flag is set

.store_temp_num:
        mov cl, 1
        add edi, edx
        jno eval_loop
        
input_overflow:
        mov edi, MAXINT
        inc eax
        jmp push_edi_cont

operator_check:
        cmp dl, '-'
        je subtractor_check

        cmp dl, ' '             ; if space was read, push number to the stack
        je check_cl

        lea ecx, [ebp - 8]
        cmp esp, ecx
        ja eval_loop

        cmp dl, '+'
        je addition

        cmp dl, '*'
        je multiply

        cmp dl, '/'
        jne eval_loop 

divide:
        mov edi, eax

        ; only case for overflow in division is MININT / -1
        mov ebx, MININT

        xor edx, edx
        pop ecx                 ; divisor
        pop eax                 ; edx:eax is the dividend

        cmp eax, ebx
        je .saturate_div

.continue:
        cdq
        idiv ecx

        push eax                ; eax contains quotient    
        mov eax, edi            ; restore pointer to string

        xor edi, edi
        xor ecx, ecx
        jmp eval_loop

.saturate_div:
        cmp ecx, -1
        jne .continue           ; if divisor is not equal -1, continue with normal division

        mov ebx, MAXINT         ; else saturate result to MAXINT
        mov eax, edi            ; restore pointer to string
        mov edi, ebx            ; saturate

        jmp push_edi_cont       ; push and continue

subtractor_check:
        mov dl, [eax]           ; mov next char from string
        cmp dl, ' '             ; if space was read after subtractor, go to subtraction 
        je subtract

        test dl, dl
        jz subtract

        cmp dl, '0'
        jb eval_loop

        cmp dl, '9'
        ja eval_loop

        mov bl, 1
        jmp eval_loop        

addition:
        pop edi
        pop edx

        mov ebx, edx

        add edi, edx
        jo saturate

        jmp push_edi_cont

multiply:
        pop edi
        pop edx

        mov ebx, edi

        imul edi, edx
        jo .saturate_mult

        jmp push_edi_cont

.saturate_mult:
        mov edi, MAXINT
        test ebx, ebx
        js .bothsigned_check

        test edx, edx
        jns .continue           ; if both are positive, saturate to MAXINT

        mov edi, MININT         ; second one is signed, saturate to MININT

.bothsigned_check:
        test edx, edx
        js .continue            ; both are negative, saturate to MAXINT

        mov edi, MININT         ; only first one is signed, MININT
  
.continue:
        jmp push_edi_cont

subtract:
        cmp ebp, esp
        je eval_loop
        
        lea ecx, [ebp - 4]
        cmp esp, ecx
        je eval_loop

        pop edx
        pop edi

        sub edi, edx
        jo saturate

        jmp push_edi_cont

saturate:
        mov edi, MININT
        test ebx, ebx
        js .continue

        mov edi, MAXINT
.continue:
        mov cl, 1

check_cl:
        test cl, cl
        jz eval_loop
push_edi_cont:
        push edi
        xor edi, edi
        xor ebx, ebx
        xor ecx, ecx
        jmp eval_loop

finish:
        cmp esp, ebp              ; check whether the stack is empty
        je .clear_eax             ; if so go to epilogue

        pop eax

        cmp esp, ebp            ; check whether the stack is empty
        je .restore             ; if so go to epilogue

        mov esp, ebp
        jmp .restore
; restore saved registers
.clear_eax:
        mov eax, edi

.restore:
        pop edi
        pop esi
        pop ebx
; epilogue 
        pop ebp
        ret