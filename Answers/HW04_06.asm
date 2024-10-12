.MODEL SMALL
.STACK 100H
.DATA

fmsg		db 'Enter your number in 5 digitis(like 12345, 01234, 00123, 00012, 00001): ', 10, 13, '$'
errorMsg	db 'None!$'
lmsg		db 'The cube root is: $'
number		dw 0                                                  

.CODE
start:
                mov ax, @DATA                      ; set ds to point to the data segment
                mov ds, ax
                
                lea dx, fmsg                       ; load effective address of fmsg
                mov ah, 09h
                int 21h                            ; print string
                lea si, number                     ; load effective address of number
                
                mov ah, 01h
                int 21h                            ; get input character
                sub al, 30h                        ; ascii 30h
                mov bx, 10000                        ; bx = 10000
                sub ah, ah
                mul bx                             
                add [ si ], ax                     ; [ si ] += al
                
                mov ah, 01h                        ; character input
                int 21h
                sub al, 30h                    	   ; ascii
                mov bx, 1000                         ; bx = 1000
                sub ah, ah
                mul bx
                add [ si ], ax                     ; [ si ] += al

                mov ah, 01h                        ; character input
                int 21h
                sub al, 30h                    	   ; ascii
                mov bx, 100                         ; bx = 100
                sub ah, ah
                mul bx
                add [ si ], ax                     ; [ si ] += al
                
                mov ah, 01h                        ; character input
                int 21h
                sub al, 30h                    	   ; ascii
                mov bx, 10                         ; bx = 10
                sub ah, ah
                mul bx
                add [ si ], ax                     ; [ si ] += al
                
                mov ah, 01h                        ; character input
                int 21h
                sub al, 30h                    	   ; ascii
                mov bx, 1                         ; bx = 1
                sub ah, ah
                mul bx
                add [ si ], ax                     ; [ si ] += al
                
                mov ax, [ si ] 
                mov di, 0				; the factor
                mov bx, 2				; the helping factor
                lastLoop:
                	cmp bx, 31          ; if bx > 31,
                	jg Exit             ; jump to the Exit
                	mov ax, [ si ]      ; ax = [ si ]
                	xor dx, dx          ; clear dx
                	div bx              ; div ax / bx
                	cmp dx, 0           ; if dx != 0,
                	jne there           ; jump to the there
                	jmp here            ; jump here
                	
                there:
                	add bx, 1            ; bx++;
                	jmp lastLoop		 ; jump to the lastLoop
                here:
                	div bx               ; div ax / bx
                	div bx               ; div ax / bx
                	cmp ax, 1            ; if ax != 1,
                	jne there            ; jump to the there
                	mov di, bx           ; di = bx
                
                		
         Exit:  
         
         		mov dl, 0ah
         		mov ah, 02h
         		int 21h                    ; printing a new line
         		
         		mov dl, 0dh
         		mov ah, 02h
         		int 21h                    ; printing cret
         		
         		lea dx, lmsg
         		mov ah, 09h
         		int 21h                    ; printing a new message
         		
         		mov ax, di                 ; ax = di
         		cmp ax, 0                  ; if ax == 0,
         		je error                   ; jump to error
         		
         		 
         		loop3:                         
						mov bx, 10                 ; bx = 10
						xor dx, dx                 ; xor dx to make it zero before divide to prevent any error 
						div bx                     ; ax / bx --> ax, ax % bx --> dx
						add dx, 30h                ; ascii --> dx += 30h
						push dx                    ; push dx in stack
						mov cx, ax                 ; cx = ax
						mov ax, cx                 ; ax = cx	why? ( I don't know :) )
						cmp ax, 0                  ; if ax != 0,
						jne loop3                  ; jump to loop3
          		
          		loop4:	
						pop dx                     ; pop stack 
						cmp dx, 30h                ; compare dx with zero
						jl cont                    ; if dx < 0, go to cont
						cmp dx, 39h                ; compare dx with nine
						jg cont                    ; if dx > 9, go to cont
						mov ah, 02h                ; ah = 02h
						int 21h                    ; print character
						jmp loop4                  ; jump to the loop4
						
				error:
					lea dx, errorMsg
					mov ah, 09h
					int 21h                         ; printing error message
            cont:
                mov ah, 4CH
                mov al, 0                           ; dos, terminate program
                int 21H
                                                    ; terminate
      
END start