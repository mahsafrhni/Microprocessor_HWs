;data segment
    ;num dw 49
;data ends

code segment
    assume ds:data, cs:code 

squareRoot:
    mov ax, 49
    mov bx, 0ffffh                                                                                     
    mov cx, 0000h
    
func:
    add bx, 02
    inc cx
    sub ax, bx
    jnz func
    mov dx, cx
   
    mov ah, 4ch
    int 21h
    
code ends
end squareRoot
