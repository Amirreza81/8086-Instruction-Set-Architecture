.MODEL SMALL
.STACK 100H
.DATA

arr1	dw		5, 19, 24, 158, 24781
lengthOfArr1	dw 5
arr2	dw		6, 17, 247, 1942 
lengthOfArr2	dw 4
msg				db 'Your numbers in last list are:', 10, 13, '$'

lastArr			dw	100 dup (0)                                                                  ; our datas

.CODE
start:
                mov ax, @DATA                           ; set ds to point to the data segment
                mov ds, ax
                
                lea ax, arr1                            ; load effective address of arr1
                lea bx, arr2                            ; load effective address of arr2
                lea si, lengthOfArr1                    ; load effective address of lengthOfArr1
                lea di, lengthOfArr2                    ; load effective address of lengthOfArr2
                
                mov cx, [ si ]                          ; [si]  = cx
                mov dx, [ di ]                          ; [di] = dx
                
                push bx                                 ; push bx
                push dx                                 ; push dx
                push ax                                 ; push az
                push cx                                 ; push cx
                
                lea dx, msg                             ; load effective address of msg
                mov ah, 09h                             ; 09h for printing string
                int 21h                                 ; interrupt 21 h
                
                call function1                          ; call the function
                
            Exit:
            	call print                              ; call the function
            	
            	
            finish:                                     
                mov ah, 4CH                             ; dos, temrninate program
                mov al, 0
                int 21H                                 ; terminate program
                
    function1   proc  
    			pop bp                                	; pop bp
     			pop cx                                  ; pop cx
     			pop ax                                  ; pop ax
     			pop dx                                  ; pop dx
     			pop bx                                  ; pop bx
     			pushf                                   ; pushf
     			
     			sub si, si                              ; si = 0
     			mov si, ax                              ; si = ax
     			lea di, lastArr                         ; load effective address of lastArr
     			
     			loop1:
     					cmp cx, 0                       ; if cx == 0,
     					je loop2                        ; jump to loop2
     					mov ax, [ si ]                  ; ax = [ si ]
     					mov [ di ], ax                  ; [ di ] = bx
     					dec cx                          ; cx--; 
     					add si, 2                       ; si += 2
     					add di, 2                       ; di += 2
     					jmp loop1                       ; jump to the loop1
     			loop2:
     				mov si, bx                          ; si = bx
     				loop3:
     					cmp dx, 0                       ; if dx == 0,
     					je Exit                         ; jump to Exit
     					mov bx, [ si ]                  ; bx = [ si ]
     					mov [ di ], bx                  ; [ di ] = bx
     			        dec dx                          ; dx--;
     			        add si, 2                       ; si += 2
     			        add di, 2                       ; di += 2
     			        jmp loop3                       ; jump to loop3
     			
     			
     			    
     				popf                                ; popf
     				ret                                 ; return
     				
     function1		endp                                ; end function
     
     print			proc                                
     	            
     	            lea si, lastArr                     ; load effective address of lastArr
     	            
     	      oloop:
     	            mov ax, [ si ]                      ; ax = [ si ]
     	      nloop:
     	            cmp ax, 0                           ; if ax == 0,
     	            je finish                           ; jump to the finish
     	            mov bx, 10                          ; bx = 10
     	            xor dx, dx                          ; xor dx to prevent error 
     	            div bx                              ; ax / bx --> ax, ax % bx --> dx
     	            add dx, 30h                         ; ascii , dx += 30h
     	            push dx                             ; push dx
     	            mov cx, ax                 ; cx = ax
					mov ax, cx                 ; ax = cx	why? ( I don't know :) )
					cmp ax, 0                  ; if ax != 0,
					jne nloop                  ; jump to nloop
     	
     	            loop12:
     	            	pop dx                     ; pop stack 
						cmp dx, 30h                ; compare dx with zero
						jl cont3                    ; if dx < 0, go to cont3
						cmp dx, 39h                ; compare dx with nine
						jg cont3                    ; if dx > 9, go to cont3
						mov ah, 02h                ; ah = 02h
						int 21h                    ; print character
						jmp loop12                  ; jump to the loop12
     	            cont3:
     	            	push dx                  ; push dx
     	            	add si, 2                ; si +=  2
     	            	mov dl, 0ah
     	            	mov ah, 02h
     	            	int 21h                  ; print a new line
     	            	mov dl, 0dh
     	            	mov ah, 02h
     	            	int 21h                  ; print cret
     	            	jmp oloop                ; jump to the oloop
     	            	
     				ret                          ; return
     endp                                        ; end of function
     
END start