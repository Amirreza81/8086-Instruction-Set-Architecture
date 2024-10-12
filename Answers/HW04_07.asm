.MODEL SMALL
.STACK 100H
.DATA
oname	db '8086.txt', 0
fname	db 'new_8086.txt', 0
handle	dw ?
buffer  db 100 dup (?)
newBuffer	db 100 dup (?)
count	db 100                                                  

.CODE
start:
                mov ax, @DATA
                mov ds, ax
                
                ; openning an exisitng file  and reading
                
                mov ah, 3dh
                mov dx, offset oname
                mov al, 0
                int 21h
                mov handle, ax
                
                mov ah, 3fh
                mov bx, handle
                lea dx, buffer
                mov cx, 100
                int 21h                       ; save in the buffer
                
                ; displaying
                
                lea si, buffer
                loop1:
                	mov ah, 2
                	mov dl, [ si ]
                	int 21h
                	inc si
                	dec count
                	jnz loop1
                
                lea si, buffer
                lea di, newBuffer
                mov cl, 100
                mov ah, 0
                loopn:
                	 cmp cl, 0
                	 je Exit
                	 mov al, [ si ]
                	 cmp al, 2fh
                	 jg there
                	 mov ah, 0
                     inc si
                     dec cx
                     jmp loopn
                
                there:
                	cmp al, 3ah
                	jl here
                	mov ah, 0
                    inc si
                    dec cl
                    jmp loopn 
                here:
                	mov  [ di ], al
                	inc di
                	cmp ah, 1
                	je here2 
                	mov ah, 1
              there2:
                	inc si
                	dec cl
                	jmp loopn
                	
              here2:
              		mov [ di ], 0ah
              		inc di
              		jmp there2                       ; save numbers in newBuffer
                	 
                ; 			opening a new file
                
          Exit:
                mov ah, 3ch
                lea dx, fname
                mov al, 1
                int 21h
                mov handle, ax
                
                mov ah, 3eh
                mov dx, handle
                int 21h
                
                ; open an existing file 
                
                mov ah, 3dh
                mov dx, offset fname
                mov al, 1
                int 21h
                mov handle, ax 
                
                mov ah, 40h
                mov bx, handle
                mov cx, 100
                lea dx, newBuffer
                int 21h
                
                mov ah, 3eh
                mov dx, handle
                int 21h
                
                mov ah, 4CH
                mov al, 0
                int 21H
                
      
END start