data segment
    num db 4
data ends

code segment
    assume ds:data, cs:code
    
factorialProgram:
    mov ax, data
    mov ds,ax
    
    mov ah, 00
    mov al, num
    
func: dec num
      mul num
      mov cl, num
      cmp cl, 01
      jnz func
      
      mov dx, ax
      
      mov ah, 4ch
      int 21h

code ends
end factorialProgram