.MODEL SMALL
.STACK 100H
.DATA

fmsg		db 'Enter N (3-digit number, like 123 or 027, 008):', 10, 13, '$'
errorMsg	db 10, 13, 'Enter a number less than 256!!!', 10, 13, '$'
lmsg		db 'Sum is : ', '$'                                                  
number   	db 0                                                                    ; our datas
 
sum			dd 0

.CODE
start:
                mov ax, @DATA                    	; set ds to point to the data segment
                mov ds, ax
                
         again:             
         		lea si, number                     ; load effective address of number
                lea dx, fmsg                       ; load effective address of fmsg
                mov ah, 09h
                int 21h                            ; print string

                mov ah, 01h
                int 21h                            ; get input character
                
                sub al, 30h                        ; ascii 30h 
                cmp al, 02h                        ; if al > 2, actually the number is greater than 255 and it's an error
                jg error
                mov bx, 100                        ; bx = 100
                mul bx                             
                add [ si ], al                     ; [ si ] += al
                mov ah, 01h                        ; character input
                int 21h
                
                sub al, 30h                    	   ; ascii
                
                mov bx, 10                         ; bx = 10
                mul bx
                add [ si ], al                     ; [ si ] += al
                mov ah, 01h                        ; character input
                int 21h
                
         
                sub al, 30h                        ; ascii
                add [ si ], al                     ; [ si ] += al
                cmp [ si ], 0                      ; if number == 256 --> error
                je error
                sub ax, ax                         ; clear ax
                
                mov dl, 0ah
                mov ah, 02h                        ; print a new line
                int 21h
                mov dl, 0dh
                mov ah, 02h
                int 21h                            ; print cret
                
                lea dx, lmsg                       ; load effective address of lmsg
                mov ah, 09h
                int 21h                            ; print string 
                
                mov ax, 01h                        ; ax = 1, first odd number
                lea si, number                     ; load effective address of number
                lea di, sum                        ; load effective address of sum
                mov dx, [ si ]                     ; dx = [ si ]
                sub cx, cx                         ; clear cx
                call recursive                     ; call recursive
                	
           error:
           		lea dx, errorMsg                   ; load effective address of errroMsg
           		mov ah, 09h
           		int 21h                            ; print string
           		jmp again                          ; jump to again
           		
           		
          Exit: 
          		lea di, sum                        ; load effective address of sum
          		mov [ di ] , cx                    ; [ di ] = cx
          		mov ax, cx                         ; ax = cx
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
          		
          		              
                cont:
                	mov ah, 4CH                    ; dos, terminate program
                	mov al, 0
                	int 21H                        ; terminate 
                                                   
    recursive   proc
    			pushf                              ; pushf
    			cmp ax, dx                         ; if ax > dx,
    			jg Exit                            ; jump to Exit
    			add cx, ax                         ; cx += ax
    			add ax, 2                          ; ax += 2
    			call recursive                     ; call recursive
    			
    			popf                               ; popf
    			ret                                ; return 
    endp                                           ; end of function
    
END start