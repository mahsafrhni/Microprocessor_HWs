data segment
    element dw 0 
    element1 dw 0
    element2 dw 1
    element3 dw 0 
    c db 10 dup ('$') 
    f db 4
    n db 2 
    t dw 1
    addition dw 0
data ends

code segment
     assume ds:data, cs:code
      
fibbonacci:              
 mov ax,data
 mov ds,ax 
 
 mov dx,offset c
 mov si,dx
 mov byte ptr[si],2   
 mov cl,byte ptr[si+1]
 add si,cx

looop:
 mov al,byte ptr[si+1]
 and ax,15 
 mul t
 add addition,ax
 mov ax,t
 mul bx
 mov t,ax
 dec si
 loop looop 

 mov ax,addition
 mov bl,2
 div bl
 call return
 mov ax,element1 
 mov bx,element2
 mov dx,element3 

loooop: 
 mov cx,addition 
 add ax,bx
 mov element,ax
 mov bx,dx
 mov dx,ax 

 mov element1,ax
 mov element2,bx
 mov element3,dx

 mov f,05
 call deci

 inc f
 call return

 mov ax,element1
 mov bx,element2
 mov dx,element3

 cmp addition,1 
 dec addition
 jmp loooop  

return:
ret
 
deci:
 lea si,n+5
 mov cx,10
 mov bx,5        

func1:
 cmp ax,cx
 jb func2
 xor dx,dx
 div cx
 add dl,48
 mov byte ptr[si],dl
 dec si
 dec bx 
 jmp func1 

func2:
 add al,48
 mov byte ptr[si],al
 mov byte ptr[si+6],"$"
 mov ah,09
 lea dx,n+bx
 int 21h
 ret

end fibbonacci
code ends  

