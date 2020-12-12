data segment
    num dw 1221
    reversed dw ?
    arr db 10 dup(0)
    temp dw ?
    res db 10 dup('$')
data ends

code segment
    assume cs:code, ds:data

palindrome:
    mov ax, data
    mov ds, ax
    
    mov ax, num
    lea si, res 
    call hexToDecimal
    lea dx, res  
    lea si, arr 
    mov ax, num

reverse:
    mov dx, 0
    mov bx, 10
    div bx
    mov arr[si], dl
    mov temp, ax
    mov ax, dx
    
    inc si
    mov ax, temp
    cmp temp, 0
    jg reverse
    lea di, arr

finish:
    inc di
    cmp arr[di], 0
    jg finish
    
    dec di
    mov al, arr[di]
    mov ah, 0
    mov reversed, ax
    mov cx, 10
    
convert:
    dec di
    mov al, arr[di]
    mov ah, 0
    mul cx
    add reversed, ax
    
    mov ax, cx
    mov bx, 10
    mul bx
    mov cx, ax 
    
    cmp arr[di], 0
    jg convert
   
    mov ax, reversed 
    
    lea si, res
    call hexToDecimal
    
    lea dx, res
    
    mov ax, num
    cmp reversed, ax
    je itsPalindrome
   
    mov dx, 00
    jmp done
   
itsPalindrome:
    mov dx, 01
    
done: 
    mov ah, 4ch
    int 21h

code ends

hexToDecimal proc near
    mov cx, 0
    mov bx, 10
    firstLoop:
        mov dx, 0
        div bx
        add dl, 30h
        push dx
        inc cx
        cmp ax, 9
        jg firstLoop
        
        add al, 30h
        mov [si], al
        
   secondLoop:
        pop ax
        inc si
        mov [si], al
        loop secondLoop
        ret
hexToDecimal endp

end palindrome
   
    
    