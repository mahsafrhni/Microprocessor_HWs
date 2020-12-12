data segment
    num1 dw 8
    num2 dw 6
    gcd dw ?
data ends

code segment
    assume ds:data cs:code

gcdProgram:
      mov ax, data
      mov ds,ax
      
      mov ax, num1
      mov bx, num2
      
while: mov dx, 0
       mov cx, bx 
       
       div bx
       mov bx, dx 
       
       mov ax, cx
       
       cmp bx, 0
       jne while  
       
       mov gcd,ax 
       mov dx,ax
       
       mov ah,4ch 
       int 21h
code ends
end gcdProgram
      
