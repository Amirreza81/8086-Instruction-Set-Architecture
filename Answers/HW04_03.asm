.MODEL SMALL
.STACK 100H
.DATA
 
arr1 	dd 10000001h, 10010100h, 10000111h, 101101bfh, 1100001ah, 20000001h, 10000010h, 10000001h, 10001111h, 1000110ah              ; the array                                                  
result 		dd ?                        ; save the summ of the elements of array in result                         

.CODE
start:
                mov ax, @DATA
                mov ds, ax                ; set ds to point to the data segement
                
                
                lea bx, arr1              ; load effective address of the array
                mov si, 5                 ; 10 / 2 = 5 --> 5 times we should call the function
                sub di, di                ; di = 0
        MyLoop:
        		mov dl, 0ah               ; printing new line 
        		mov ah, 02h
        		int 21h                   ; interrupt 21h
        		mov dl, 0dh               ; printing cret
        		mov ah, 02h
        		int 21h                   ; interrupt 21h 
        		lea bx, arr1              ; load effective address of the array
                call OriginFunction       ; call the function
                dec si                    ; si--;
                cmp si, 0                 ; if si == 0,
                je Exit                   ; jump to the  Exit
                jmp MyLoop                ; jump to the first of the loop
                
        Exit:   mov ah, 4CH               ; dos, terminate program
                mov al, 0                 ; return code will be 0
                int 21H                   ; terminate the program
                
OriginFunction 	proc                      ; function
	            pushf                     ; push flags
	            
                mov cx, [bx + di]               ; less significant bit of number1 in cx 
                mov bx, [bx + 2 + di]           ; most significant bit of number1 in bx 
                mov ax, word ptr arr1 + 4 + di       ; less significant bit of number2 in ax 
                mov dx, word ptr arr1 + 6 + di      ; most significant bit of number2 in dx
                
      			add      ax, cx                    ; add less significant bit + less significant bit
      			add	     bx, dx                    ; add most significant bit + most significant bit
      			  
      			add      word ptr result, ax          	; less significant bit answer  
      			add      word ptr result + 2, bx        ; most significant bit answer
      			add 	 di, 8                          ; di += 8 , for accessing next elements of array
      			mov      bx, word ptr result + 2        ; Result in reg bx
				mov      dh, 2                          ; dh = 2 for printing
      			
 		loop1:
   			    mov      ch, 04h                ; Count of digits to be displayed  
      		    mov      cl, 04h                   ; Count to roll by 4 bits   
      		    
 		loop2:
      			rol      bx, cl                 ; roll bl so that most significant bit comes to less significant bit   
      			mov      dl, bl                    ; load dl with data to be displayed  
      			and      dl, 0fH                   ; get only less significant bit  
      			cmp      dl, 09                    ; check if digit is 0-9 or letter A-F  
      			jbe      loop3  
      			add      dl, 07                    ; if letter add 37H else only add 30H   
      			
 		loop3:
 	  			add      dl, 30H  
      			mov      ah, 02                    ; INT 21H (Display character)  
      			int      21H
      			  
      			dec      ch                        ; Decrement Count  
      			jnz      loop2   
      			dec      dh  
      			cmp      dh, 0  
      			mov      bx, word ptr result           ; display less significant bit of answer  
      			jnz      loop1
      			  
      			
                popf                 ; pop flags
                ret                  ; return
				endp                 ; end of function

END start