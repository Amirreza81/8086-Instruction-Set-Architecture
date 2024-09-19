.MODEL SMALL
.STACK 100H
.DATA                                                ; definding datas here

FirstMessage    db 'Enter your number: $'
LastMessage     db 'Your number is: $'                                                  
arr             db 5 DUP (?)

.CODE
start:
                mov ax, @DATA
                mov ds, ax
                
                lea dx, FirstMessage        ; load effective address of FirstMessage
                mov ah, 09H                 ; 09H  for printing a string
                int 21H                     ; interrupt 21H
                     
                call func1                  ; call func1
                
        lab:    mov dl, 10
                mov ah, 02H
                int 21H                     ; printing a new line
                
                mov dl, 13
                mov ah, 02H
                int 21H                     ; carriage return
                     
                lea dx, LastMessage         ; load effective address of FirstMessage
                mov ah, 09H                 ; 09H  for printing a string
                int 21H                     ; interrupt 21H
                
                call func2                  ; call func2
                       
                mov ah, 4CH                 ;
                mov al, 0                   ;
                int 21H                     ; terminate
                       
                func1 proc                  ; start func1
                    pushf                   ; push flags
                       
                    mov cx, 5               ; counter = 5
                    mov si, offset arr      ; address of arr in si
                
                    loop1:                  ; start loop
                        mov ah, 01H         ; 01H for reading input
                        int 21H             ; interrupt 21H
                        cmp al, 0DH         ; if al == (Enter),
                        je lab              ; jump to the lab
                        mov [si], al        ; al --> [si]
                        inc si              ; si++
                        loop loop1          ; go to the first of the loop and counter-- automatically
                        
                    popf                    ; pop flags
                    ret                     ; return
                func1 endp                  ; end of func1
                
                
                func2 proc                  ; start func2
                    pushf                   ; push flags  
                       
                    lea si, arr             ; load effective address of arr
                    mov cx, 5               ; counter = 5
                       
                    loop2:
                        mov dl, [si]        ; move [si] to dl for printing
                        mov ah, 02H         ; 02H for printing
                        int 21H             ; interrupt 21H
                        inc si              ; si++
                        loop loop2          ; go to the first of the loop and counter-- automatically
                        
                   popf                     ; pop flags
                   ret                      ; return
                func2 endp                  ; end of func2
                    
END start