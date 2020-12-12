org 100h
.stack 64
.data
    pongGame db 'PONG GAME','$'
    stnumber db 'Mahsa Farahani  96243048','$'  
    winMSG db 'WON!','$' 
    finishedmsg db 'game over','$'
     start_col_racket dw   300 
     start_row_racket dw   30
     finish_col_racket dw  304
     finish_row_racket dw  60
     movement dw 4    
     xstart dw 4
     ystart dw 4
     xfinish dw 304
     yfinish dw 170
     ball_x dw 100
     ball_y dw 100 
     ball_size dw 4   
     move_horizontal dw 02h
     move_vertical  dw 01h
     score db 0
     best_score db 30 
     score_x db 23
     score_y db 20  
     
.code 
main proc far
    mov ax, @data
    mov ds, ax   
    
firstScreen: 
;move the string to x,y
    mov ah, 02h    
    mov bh, 00
    mov dh, 07   ;x
    mov dl, 35   ;y
    int 10h

;print pongGame 
    mov ah, 09
    mov dx, offset pongGame
    int 21h

;move the string to x,y
    mov ah, 02h    
    mov bh, 00
    mov dh, 09
    mov dl, 30
    int 10h


;ptint stnumber 
    mov ah, 09
    mov dx, offset stnumber
    int 21h
    
delay:
    mov ah, 86h
    mov cx, 20h
    int 15h 
             
clearScreen:
    mov ah, 06   
    mov al, 00     ;page 0
    mov bh, 07     ;xe shoroo e pak kardan
    mov ch, 07     ;ye shoroo e pak kardan
    mov cl, 30     ;xe payan e pak kardan
    mov dh, 09     ;ye shoroo e pak kardan
    mov dl, 100
    int 10h 
         
    call set_graphic_mode 
    
    mov ah, 02
    mov bh,00
    mov dl, score_y
    mov dh, score_x
    int 10h 
    mov dl, score
   
    add dl, "0"
    mov ah, 02
    int 21h
    mov al, best_score 
    cmp score, al
    jz win 
   
    Pong:
      call walls
      call ball
      call racket
       mov cx, 0ffffh
    game_time:
      loop game_time 
      
      call bounce_ball 
      call knock
      call move_racket
      jmp Pong
      
main endp     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
set_graphic_mode proc near
    mov ah, 0
    mov al, 13h
    int 10h 
    
    ret
endp set_graphic_mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
racket proc 
    mov ah, 0ch 
    mov al, 1
      
    mov dx, start_row_racket
loopRacket1:
    mov cx, start_col_racket

loopRacket2:
    int 10h
    inc cx
    cmp cx, finish_col_racket
    jnz loopRacket2
    
    inc dx
    cmp dx, finish_row_racket
    jnz loopRacket1
    
    ret
endp racket 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
walls proc

   mov ah, 0ch
   mov al, 50
   mov dx, ystart
   mov cx, xstart
  upwall: 
   int 10h
   inc cx
   cmp cx, xfinish
   jnz upwall
   mov dx, ystart
   mov cx, xstart
   
   leftwall:
    int 10h
   inc dx
   cmp dx, yfinish
   jnz leftwall
   
   mov cx, xstart 
   
   downwall:
   int 10h
   inc cx
     cmp cx, xfinish
   jnz downwall
   
  ret
             
  walls endp  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ball proc 
       mov cx, ball_x
    mov dx, ball_y 
     mov ah, 0ch
    mov al, 25
     int 10h
    ball_loop:
     mov ah, 0ch
    mov al, 141
    int 10h
    inc cx
    mov ax, cx
    sub ax, ball_x
    cmp ax, ball_size
    jng ball_loop
    mov cx, ball_x
    inc dx
    mov ax, dx
    sub ax, ball_y
    cmp ax, ball_size
    jng ball_loop
    ret
      
    endp ball
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
bounce_ball proc near
 mov dx, ball_y
    mov cx, ball_x
    
loopBall:  
    mov ah, 0ch 
    mov al, 00h 
    int 10h     
    inc cx       
    mov ax, cx
    sub ax, ball_x
    cmp ax, ball_size
    jng loopBall    
    mov cx, ball_x
    inc dx
    mov ax, dx
    sub ax, ball_y
    cmp ax, ball_size
    jng loopBall         
    
        
    mov ax, move_horizontal
    add ball_x, ax
    mov ax, move_vertical
    add ball_y, ax 
   
    ret            
 
     
      bounce_ball endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
knock proc
    mov ax, ball_x
    cmp ax, xstart
    jl  come_back_x 
    mov ax, ball_x
    add ax, ball_size
    cmp ax, xfinish
    jg  catch
    mov ax, ball_y
    cmp ax, ystart
    jl  come_back_y
     mov ax, ball_y 
     add ax, ball_size
    cmp ax, yfinish
    jg  come_back_y
    ret
    
    come_back_x:
    neg move_horizontal
    ret
     come_back_y:
    neg move_vertical
    ret      

   knock endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  catch proc
    mov ax, ball_y
    cmp ax, start_row_racket
    jl finished
    cmp ax,  finish_row_racket
    jle goal
    
    finished:

     call set_graphic_mode 
     mov ah, 02h    
    mov bh, 00
    mov dh, 07   ;x
    mov dl, 35   ;y
    int 10h
     mov ah, 09 
     mov dx, offset finishedmsg
     int 21h 
     jmp exitGame
     
  goal:
    
    inc score 
    mov ah, 02
    mov bh,00
    mov dl, score_y
    mov dh, score_x
    int 10h 
    mov dl, score
    mov al, dl
    out 199, al
    add dl, "0"
    mov ah, 02
    int 21h
    mov al, best_score
    cmp score, al
    jz win
    jmp  come_back_x:
    
    
    catch endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    win proc

        call set_graphic_mode 
        mov ah, 02
        mov bh, 00
        mov dl, score_x
        mov dh, score_y
        int 10h
        mov ah, 09h 
        mov dx, offset winMSG
        int 21h
        jmp exitGame
        win endp  
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
  move_racket proc
    
      mov ah, 01h
      int 16h
      jz cancel  ;ta vaqti k kilidi zade nashode b cancel bargard
      mov ah, 0h
      int 16h
      cmp al, 77h
      je move_up
      cmp al, 57h
      je move_up
      cmp al, 73h
      je move_down
      cmp al, 53h
      je move_down
      move_up:
      mov ax,start_row_racket
      cmp ax, ystart
      jle cancel
      mov ah, 0ch
      mov al, 0h
      mov cx, start_col_racket  
      loop1:
      mov dx, finish_row_racket 
      loop2:
      mov ah, 0ch
      mov al, 0h
      int 10h
      dec dx
      mov ax, dx
      sub ax, finish_row_racket 
      neg ax
      cmp ax, movement
      jnz loop2
      inc cx
      cmp cx, finish_col_racket   
      jnz loop1
      mov ax, movement
      sub start_row_racket, ax
      sub finish_row_racket, ax  
      jmp cancel
      move_down:
      mov ax, finish_row_racket   
      cmp ax, yfinish
      jge cancel 
      mov ah, 0ch
      mov al, 0h
      mov cx, start_col_racket
      loop3:
      mov dx, start_row_racket
      loop4:
      mov ah, 0ch
      mov al, 0h
      int 10h
      inc dx
      mov ax, dx
      sub ax, start_row_racket
      cmp ax, movement
      jnz loop4   
      inc cx
      cmp cx, finish_col_racket 
      jnz loop3
      mov ax, movement
      add start_row_racket, ax
      add finish_row_racket, ax      
      
      jmp cancel
      cancel:
      ret
      move_racket endp
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
 exitGame:
 end main 
