.stack 100h
.data
message   		db  'Enter your number(Enter 0 to finish):', '$'
string			db 6 										;MAX NUMBER OF CHARACTERS ALLOWED (4).
       			db ? 										;NUMBER OF CHARACTERS ENTERED BY USER.
       			db 6 dup (?) 								;CHARACTERS ENTERED BY USER.
       			
arr				dw 128 dup (0)                              ; arr

.code          

	  mov  ax, @data
	  mov  ds, ax                  ; set ds to point to the data segment
      
      
	  mov  ah, 9
 	  mov  dx, offset message
	  int  21h                    ; printing message with int 21h and ah = 09h
  
 	  lea di, arr                 ; load effective address of arr
  loop1:
  		mov  ah, 0Ah
  		mov  dx, offset string
  		int  21h                   ; string input with int 21h and ah = 0ah
    	mov dl, 0ah
    	mov ah, 02h
    	int 21h                    ; printing a newline
    	mov dl, 0dh
    	mov ah, 02h
    	int 21h                    ; printing cret
  		call string2number         ; call the function
  		cmp bx, 0                  ; if bx == 0,
  		je Exit                    ; jump to Exit
  		mov [ di ], bx             ; store bx in address di
  		add di, 2                  ; di += 2
   	    jmp loop1                  ; jump to the loop1
    
       
Exit:
	lea si, arr                    ; load effective address of arr
	sub si, 02h                    ; si -= 2
	sub di, 02h                    ; di -= 2
	mov bx, 10                     ; bx = 10
	loop2:
		mov ax, [ di ]             ; ax = contanin of address di
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
		mov dl, 0ah
    	mov ah, 02h
    	int 21h                    ; printing a new line
    	mov dl, 0dh
    	mov ah, 02h
    	int 21h                    ; printing cret
		sub di, 2                  ; di -= 2
		cmp di, si                 ; if di == si,
		je Exit2                   ; jump to Exit2
		jmp loop2                  ; jump to the loop2
		
Exit2:
	mov ah, 4CH                    ; dos, terminate program
 	mov al, 0                      ; return 0
  	int 21H                       ; terminate
  	
string2number  proc
	         
;  Make SI to Point to The Least significant digit.
  mov  si, offset string + 1 
  mov  cl, [ si ] 					;NUMBER OF CHARACTERS ENTERED.*                                         
  mov  ch, 0 						;CLEAR CH, NOW CX==CL.
  add  si, cx 						;NOW SI POINTS TO LEAST SIGNIFICANT DIGIT.
  
;CONVERT STRING.
  mov  bx, 0
  mov  bp, 1 						;MULTIPLE OF 10 TO MULTIPLY EVERY DIGIT.
  
repeat:         
;CONVERT CHARACTER.                    
  mov  al, [ si ] 					;CHARACTER TO PROCESS.
  sub  al, 48 						;CONVERT ASCII CHARACTER TO DIGIT.
  mov  ah, 0 						;CLEAR AH, NOW AX==AL.
  mul  bp 							;AX*BP = DX:AX.
  add  bx,ax 						;ADD RESULT TO BX.
   
;INCREASE MULTIPLE OF 10 (1, 10, 100...).
  mov  ax, bp
  mov  bp, 10
  mul  bp 					;AX*10 = DX:AX.
  mov  bp, ax 				;NEW MULTIPLE OF 10.
    
  dec  si 					;NEXT DIGIT TO PROCESS.
  loop repeat 				;COUNTER CX-1, IF NOT ZERO, REPEAT.

  ret     					; return
endp                        ; end of function