.data
            string db 'MahSa$'  
            
.code 
lowerToUpper:          
            mov ax, data
            mov ds, ax  
                    
upperCase: 
            cmp [bx], '$'
            je finish
                       
            cmp byte ptr [bx], 'a'
            jb itsLowercase
            cmp byte ptr [bx], 'z'
            ja itsLowercase
            and byte ptr [bx], 11011111b 
            
itsLowercase:
            inc bx
            jmp upperCase
             
              
finish:     lea dx, string          
            mov ah, 09h
            int 21h
            mov dx, ax
               
            mov ax, 4C00h        
            int 21h
            
end lowerToUpper