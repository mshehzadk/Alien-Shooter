; Muhammad Shehzad, Mohsin Batti

.model small
.stack 100h	
.data 

UName db 10 dup('$')
GameName db "Welcome to Galaxy Attack Shooter $"
EnterName db "Enter your Name: $"
welcome db "Welcome to Candy Crush Presented by Shehzad and Ahmed $"
Str1 db "Good Luck!$"
Str2 db "Name: $"
Str3 db "Score: $"

Rule db "Rules for Galaxy Attack Shooter!$"
Rule1 db "1. You have to save to planet in this game from different types of enimies. $"
Rule2 db "2. There is a spaceship loaded with bullets which will help you to counter your enimies. $" 
Rule3 db "3. You have to use left and right key of keyboard to move the spaceship. $"
Rule4 db "4. Use space bar to fire on enimies $"

i dw 0
j dw 0
k dw 0
x dw 0
y dw 0
z dw 0
a dw 0
b dw 0
count dw 0
temp dw 0

spaceship_xvalue dw 0
spaceship_yvalue dw 0
germs_xvalue dw 0
germs_yvalue dw 0
germs_zvalue dw 0

germs_xarray dw 50,100,150,200,250,300,350,400,450,500,50,100,150,200,250,300,350,400,450,500
germs_yarray dw 60,50,70,60,50,70,60,50,70,60,110,120,130,110,120,130,110,120,130,110
germs_zarray dw 85,135,185,235,285,335,385,435,485,535,85,135,185,235,285,335,385,435,485,535

no_of_germs dw 20

.CODE

space macro
	pushA
	mov dl,' '
	mov ah,02h
	int 21h
	popA
	
endm

nextline macro
	pushA
	mov dl,10
	mov ah,02h
	int 21h
	mov dl,13
	mov ah,02h
	int 21h
	popA
endm

SetMousePosition macro
		pushA
		mov ax,4
		; cx will contain the x-cordinate
		; dx will contain the y-cordinate
		int 33h
		popA
	
	
endm

RestrictMouse macro
	
		pushA
		; Horizontaly Restriction
		mov ax,7
		mov cx,117
		mov dx,516
		int 33h	
		; Vertically Resrtriction
		mov ax,8
		mov cx,51
		mov dx,450
		int 33h		
		popA
	
endm

ResetMouse macro
	pushA
	mov ax,0
	int 33h
	popA
	
endm

showMouse macro
	pushA
		mov ax,1
		int 33h	
	popA
	
endm

HideMouse macro
	pushA
		mov ax,2
		int 33h
	popA
	
endm

main proc
  
    mov AX, @data
    mov DS, AX
				
	call displayInitialScreen	;Initialze Graphic Mode
    ;call drawSquare   			;Call to Intial Square
    ;call GetName				; Call to display the string of Name
	;call inputPlayerName       ;Call to for Input of Name
	;call displayRules			;Call to display rules
	;call displayInitialScreen	
	
	;mov germs_xvalue,250
	;mov germs_yvalue,60
	;mov germs_zvalue,285
	
	;call drawshapes
	;call initialzeShapes
	mov spaceship_xvalue,250
	mov spaceship_yvalue,350
	;call drawspaceship
	
	;call clearenemies
	;call checkinput
	call simulation
	
	
	

exit:
mov ah,04ch
int 21h
main endp


drawshapes proc

	mov si,offset germs_xarray
	mov di,offset germs_yarray
	mov bx,offset germs_zarray
	mov ax,no_of_germs
	mov count,ax
	.while(count > 0)
		mov ax,[si]
		mov germs_xvalue,ax
		mov dx,[di]
		mov germs_yvalue,dx
		mov cx,[bx]
		mov germs_zvalue,cx

		.if((ax == dx) && (dx==0))
			jmp moveon 
		.endif
		push si
		push di
		push bx
		push count
		call drawenimies
		pop count
		pop bx
		pop di
		pop si
		moveon:
		add si,2
		add di,2
		add bx,2

		dec count
	.endw


	ret
drawshapes endp

delay proc
	push ax
	push bx
	push cx
	push dx
	mov cx,100
	startLoop:
		mov ax,00h
		push CX
		mov cx,1000
		innerloop:
			mov ax,00h
			mov dx,5344
			mov bx,5000
			
		Loop innerloop
		pop cx
	Loop startLoop
	pop dx
	pop cx
	pop bx
	pop ax
	ret
delay endp

displayInitialScreen proc
	; Set video mode
	mov ah, 0		; function mode 
	mov al, 12h		; video mode number of 640 x 480
	int 10h

	; scroll up window
	mov AH, 06h ; function mode
	mov AL, 0	; lines to scroll
	mov CX, 0	; ch-upper row number, cl-left column number
	mov DH, 80	; dh-lower row number
	mov DL, 80	; dl-right column number
	mov BH, 08h	; backgroud color number of grey
	int 10h		; interupt
	RET
displayInitialScreen endp

drawSquare proc
	;-------Change Background to black sqaure---------
	mov AH, 06h
	mov AL, 10 ; scroll line
	mov Cx,19
	mov DH, 18 ;move up
	mov DL, 60
	mov BH, 00h
	int 10h
	;--------Draw Square of Yellow around it as border---------------
	mov si,152 ; x-axis
	mov di,144 ; y-axis
	.while si<489
		; horizontal line
		mov ah,0Ch ; function mode to write graphics pixels
		mov al,0eh ; color
		mov cx,si  ; x-axis
		mov dx,di  ; y-axis
		mov bh,0   ; page-number
		int 10h	   ; interupt
		inc si	   ; incremeting x axis
	.endw
	.while di<305
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		mov bh,0
		int 10h
		inc di
	.endw
	.while si>152
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		;mov bh,0
		int 10h
		dec si
	.endw
	.while di>144
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		mov bh,0
		int 10h
		dec di
	.endw
	RET
drawSquare endp

GetName proc
	; Drawing a Welcome background of black color on the uper side of Name box
	mov si,150	; x-axis
	mov di,102	; y-axis
	mov i,00	
	.while i<=25
		.while si<=480
			mov ah,0Ch
			mov al,00h  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,150
		inc di
	.endw
	
	; Displaying the welcome title inside the black box title

	mov dh, 7 	; setting the row for cursor
	mov dl, 25 	; setting the col for cursor
	mov si, 0
	displaystring1:
		mov bh,0	; page number
		mov ah, 02	; function mode for cursor
		int 10h		; interupt
		mov ah, 09  ; function mode for writing the character
		mov al, GameName[si] ; getting the character at si
		mov bl, 0eh	; color
		mov cx, 1	; Number of times to print
		mov bh, 0	; page number
		int 10h		; interupt
		inc dl		; incrementing the Col_no of cursor for writing the next charcter
		inc si		; increnting si for next character 
		cmp GameName[si], "$"
	jne displaystring1

	; Displaying the 'Enter Name' inside the black box
	mov dh, 13
	mov dl, 20
	mov si, 0
	displaystring:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, EnterName[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		
		inc dl
		inc si
		cmp ENterName[si], "$"
	jne displaystring	
	
	RET
GetName endp

inputPlayerName proc

	; set cursor position
	mov dl, 37  ; columns 
	mov dh, 13  ; rows
	mov bh,0    ; page no
	mov ah, 02
	int 10h
		
	; set text mode cursor shape
	mov ch, 26h	; row start
	mov cl, 7	; row end
	mov ah, 1	; function mode
	int 10h		; interupt
	; Get the name from the user 
	mov SI, offset UName
	mov ah,01
	inputChar:
		int 21h
		mov [si], al
		inc si
		cmp al, 13
	jne inputChar
	mov al,"$"
	mov [si],al

	mov ch, 06h	; row start
	mov cl, 7	; row end
	mov ah, 1	; function mode
	int 10h		; interupt
	ret
inputPlayerName endp

displayRules proc
	; Set Full Background Grey using scroll up window
	mov AH, 06h 
	mov AL, 0
	mov CX, 0
	mov DH, 80
	mov DL, 80
	mov BH, 08h
	int 10h

	; Draw the square of black color using scroll up window
	mov AH, 06h ; function mode
	mov AL, 21	; move up
	mov Cx,8 	; ch: left col no, cl: upper row no
	mov DH, 25	; lower row no
	mov DL, 70	; right col no
	mov BH, 0	; page number
	int 10h
	;-----------Yellow Border----------
	mov si,64
	mov di,80
	.while si<568
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		mov bh,0
		int 10h
		inc si
	.endw
	.while di<415
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		mov bh,0
		int 10h
		inc di
	.endw
	.while si>64
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		;mov bh,0
		int 10h
		dec si
	.endw
	.while di>80
		mov ah,0Ch
		mov al,0eh
		mov cx,si
		mov dx,di
		mov bh,0
		int 10h
		dec di
	.endw

	;------------Display Rules-------------

	mov dh, 6; rows
	mov dl, 10;columns
	mov si, 0
	displayRule:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Rule[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp Rule[si], "$"
	jne displayRule

	mov dh, 8; rows
	mov dl, 10 ; columns
	mov si, 0
	displayRule1:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Rule1[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		.if dl==67
			mov dl,11
			inc dh

		.endif
		inc dl
		inc si
		cmp Rule1[si], "$"
	jne displayRule1

	mov dh,11
	mov dl, 10 ; columns
	mov si, 0
	displayRule2:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Rule2[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		.if dl==70
			mov dl,11
			inc dh

		.endif
		inc dl
		inc si
		cmp Rule2[si], "$"
	jne displayRule2

	mov dh,14
	mov dl, 10 ; columns
	mov si, 0
	displayRule3:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Rule3[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		.if dl==70
			mov dl,11
			inc dh
		.endif
		inc dl
		inc si
		cmp Rule3[si], "$"
	jne displayRule3

	mov dh,17
	mov dl, 10 ; columns
	mov si, 0
	displayRule4:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Rule4[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		.if dl==70
			mov dl,11
			inc dh
		.endif
		inc dl
		inc si
		cmp Rule4[si], "$"
	jne displayRule4

	mov dh,20 ; rows
	mov dl, 33 ; columns
	mov si, 0
	displayGoodLuck:
		mov ah, 02
		int 10h
		mov ah, 09 
		mov al, Str1[si]
		mov bl, 0Eh
		mov cx, 1
		mov bh, 0
		int 10h	
		inc dl
		inc si
		cmp Str1[si], "$"
	jne displayGoodLuck
	mov ah,08h
	int 21h
	ret
displayRules endp

drawenimies proc
	; Drawing Enimes
	; x=250	- x axis
	; y=60	- y axis
	; z=290 - endpiont

	;;;;;;;;;;;;;;;;;;;;;;;;;;;; 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov si,germs_xvalue
	mov x,si
	;mov z,si
	;add z,35
	mov si,germs_yvalue
	mov y,si
	mov si,germs_zvalue
	mov z,si

	;; Rectangle
	mov si,x	; x-axis
	mov di,y	; y-axis
	mov i,00	
	.while i<=20
		.while si<=z
			mov ah,0Ch
			mov al,03h  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,x
		inc di
	.endw


	mov si,x	; x-axis

	mov di,y	; y-axis
	add di,5
	mov i,00	
	.while i<=10
		.while si<=z
			mov ah,0Ch
			mov al,05h  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,x
	
		inc di
	.endw


  ;; Triangles inside rectangle
	mov si,x
	add si,22
	mov di,y  
	sub si,5
	mov i,0
	mov j,si
	mov k,si
	mov i,di
	add i,25
	.while di<=i
		.while si<=j
			mov ah,0Ch
			mov al,0Ah
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		add di,2
		inc j
		dec k
		mov si,k
	.endw
	add i,20
	.while di<=i
		.while si<=j
			mov ah,0Ch
			mov al,0Ah
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		add di,1
		dec j
		inc k
		mov si,k
	.endw

	

	Ret
drawenimies endp

initialzeShapes proc
	mov si,germs_xvalue
	mov x,si
	mov si,germs_yvalue
	mov y,si
	mov si,germs_zvalue
	mov z,si
	mov count,0
	.while(count != 7)
		
		call drawenimies
		.if(count <= 2)
			sub x,50
			add y,20
			sub z,50
		.else
			add x,50
			add y,30
			add z,50
		.endif
		
		inc count
	.endw

	mov si,germs_xvalue
	mov x,si
	add x,50
	mov si,germs_yvalue
	mov y,si
	add y,20
	mov si,germs_zvalue
	mov z,si
	add z,50
	
	mov count,0
	.while(count != 5)
		
		call drawenimies
		.if(count < 2)
			add x,50
			add y,20
			add z,50
		.else
			sub x,50
			add y,30
			sub z,50
		.endif
		inc count
	.endw
	ret

initialzeShapes endp

generateRandomNumber proc			; generate a rand no using the system time
   
   MOV AH, 00h						; interrupts to get system time        
   INT 1AH							; CX:DX now hold number of clock ticks since midnight      
   mov  ax, dx
   xor  dx, dx
   mov  cx, 9   
   div  cx							; here dx contains the remainder of the division - from 0 to 9

generateRandomNumber endp

drawspaceship proc
	; Drawing spaceship
	; x=250	- x axis
	; y=300	- y axis
	; z=350 - endpiont
	mov ax,spaceship_xvalue
	mov x,ax
	mov ax,spaceship_yvalue
	mov y,ax
	


	mov ax,x
	mov z,ax
	add z,100
	;; Square
	mov si,x	; x-axis
	mov di,y	; y-axis
	mov i,00	
	.while i<=100
		.while si<=z
			mov ah,0Ch
			mov al,0Ah  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,x
		inc di
	.endw
	; horzontal Rectangle
	mov si,x	; x-axis
	mov di,y	; y-axis
	add di,25
	mov i,00	
	.while i<=25
		.while si<=z
			mov ah,0Ch
			mov al,04h  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,x	
		inc di
	.endw

		;; triangles


	mov count,1
	.while(count != 5)
		mov ax,24
		mov bx,count
		mul bx
		mov si,x
		add si,ax
		sub si,12
		mov i,si
		mov j,si
		mov k,si
		mov di,y  
		sub di,12 

		.while(di<=y)
			.while(si<=i)
				mov ah,0Ch
				mov al,0Ch
				mov cx,si
				mov dx,di
				mov bh,0
				int 10h
				inc si
			.endw
			inc di
			inc i
			dec j
			mov si,j
		.endw
		inc count
	.endw
	; Verticle rectangle
	mov si,x	; x-axis
	add si,25
	mov di,y	; y-axis
	sub z,50
	mov i,00	
	.while i<=100
		.while si<=z
			mov ah,0Ch
			mov al,04h  ; Color
			mov cx,si
			mov dx,di
			mov bh,0
			int 10h
			inc si
		.endw
		inc i
		mov si,x
		add si,25
		inc di
	.endw
	


	ret
drawspaceship endp

ClearBackground proc
	; scroll up window
	mov AH, 06h ; function mode
	mov AL, 0	; lines to scroll
	mov CX, 0	; ch-upper row number, cl-left column number
	mov DH, 15	; dh-lower row number
	mov DL, 80	; dl-right column number
	mov BH, 08h	; backgroud color number of grey
	int 10h		; interupt
	RET


ClearBackground endp

removeenimies proc

	push si
	push di

	mov si,germs_xarray[si]
	mov j,si
	mov di,germs_yarray[di]
	mov z,si
	add z,35
	mov i,0
	.while i<=55
					.while si<=z
						mov ah,0Ch
						mov al,08h  ; Color
						mov cx,si
						mov dx,di
						mov bh,0
						int 10h
						inc si
					.endw
					inc i
					mov si,j
					inc di
	.endw
	pop di
	pop si

	ret
removeenimies endp

drawbullets proc
	push spaceship_xvalue
	push spaceship_yvalue

	.while(spaceship_yvalue > 200)
	; making the verticle rectangles
		mov temp,0
		mov count,8
		.while(temp != 4)

				mov si,spaceship_xvalue	; x-axis
				add si,count
				mov di,spaceship_yvalue	; y-axis
				sub di,50
				mov z,si
				add z,5
				mov i,00	
				.while i<=25
					.while si<=z
						mov ah,0Ch
						mov al,04h  ; Color
						mov cx,si
						mov dx,di
						mov bh,0
						int 10h
						inc si
					.endw
					inc i
					mov si,spaceship_xvalue
					add si,count
					inc di
				.endw

				inc temp
				add count,24
		.endw

		mov temp,0
		mov count,8
		.while(temp != 4)

				mov si,spaceship_xvalue	; x-axis
				add si,count
				mov di,spaceship_yvalue	; y-axis
				sub di,70
				mov z,si
				add z,3
				mov i,00	
				.while i<=3
					.while si<=z
						mov ah,0Ch
						mov al,0Eh  ; Color
						mov cx,si
						mov dx,di
						mov bh,0
						int 10h
						

						mov ah,0Ch
						mov al,0Eh  ; Color
						mov cx,si
						mov dx,di
						sub dx,8
						mov bh,0
						int 10h
						
						inc si

					.endw
					inc i
					mov si,spaceship_xvalue
					add si,count
					inc di
				.endw

				inc temp
				add count,24
		.endw

	; making the triangles over them

		mov count,11
		mov temp,0
		.while(temp != 4)
				mov si,spaceship_xvalue
				add si,count
				mov i,si
				mov j,si
				mov di,spaceship_yvalue 
				mov y,di
				sub y,50
				sub di,55

				.while(di<=y)
					.while(si<=i)
							mov ah,0Ch
							mov al,0Ch
							mov cx,si
							mov dx,di
							mov bh,0
							int 10h
							inc si
						.endw
						inc di
						inc i
						dec j
						mov si,j
					
				.endw
			inc temp
			add count,24
		.endw

		call delay
				
				mov si,spaceship_xvalue	; x-axis
				mov di,spaceship_yvalue	; y-axis
				sub di,80
				mov z,si
				add z,100
				mov i,00	
				
				.while i<=55
					.while si<=z
						mov ah,0Ch
						mov al,08h  ; Color
						mov cx,si
						mov dx,di
						mov bh,0
						int 10h
						inc si
					.endw
					inc i
					mov si,spaceship_xvalue
					inc di
				.endw
				
		sub spaceship_yvalue,50

	.endw
	pop spaceship_yvalue
	pop spaceship_xvalue

	
	;dec no_of_germs

	ret
drawbullets endp

clearspaceship proc

	push spaceship_xvalue
	push spaceship_yvalue
	
	; scroll up window
	mov AH, 06h ; function mode
	mov AL, 0	; lines to scroll
	;mov CX, 0	; ch-upper row number, cl-left column number
	mov ch,20
	mov cl,0
	mov DH, 80	; dh-lower row number
	mov DL, 80	; dl-right column number
	mov BH, 08h	; backgroud color number of grey
	int 10h		; interupt

	pop spaceship_yvalue
	pop spaceship_xvalue
	ret
clearspaceship endp

clearenemies proc

	
	; scroll up window
	mov AH, 06h ; function mode
	mov AL, 0	; lines to scroll
	;mov CX, 0	; ch-upper row number, cl-left column number
	mov ch,0
	mov cl,0
	mov DH, 20	; dh-lower row number
	mov DL, 80	; dl-right column number
	mov BH, 08h	; backgroud color number of grey
	int 10h		; interupt


	ret
clearenemies endp

checkinput proc

	; check if any key is pressed
	mov temp,0
	.while(temp < 10)
	mov ah,01
	int 16h
	jz key_not_pressed
	mov ah,00
    int 16h
	cmp ax,4D00h
	je Move_Left
	cmp ax,4B00h
	je Move_Right
	cmp ax,3920h
	je Fire_Bullets
	jmp key_not_pressed
	
	Move_Right:
		.if(spaceship_xvalue>120)
			call clearspaceship
			sub spaceship_xvalue,20
			
			call drawspaceship
		.endif
		inc temp
		JMP key_not_pressed
	Move_Left:
		.if(spaceship_xvalue<530)
			call clearspaceship
			add spaceship_xvalue,20
			
			call drawspaceship
		.endif
		inc temp
		;jmp return1
		JMP key_not_pressed
	Fire_Bullets:
		call drawbullets

	key_not_pressed:
	.endw

	;Right Arrow --> 4D00  Left Arrow --> 4B00, space bar 3920


	return1:
		ret
checkinput endp

function1 proc

	mov count,0
	mov si,offset germs_xarray
	mov di,offset germs_yarray
	mov bx,offset germs_zarray
	mov ax,spaceship_xvalue
	mov b,ax
	add b,100

	.while(count <20)

			
			mov ax,[si]	;x
			mov cx,[di]	;y
			mov dx,[bx]	;z
			
			
			.if((ax>=spaceship_xvalue) && (dx<=b))
						push ax
						push bx
						push cx
						push dx
						push si
						push di
						;call removeenimies
						pop di
						pop si
						pop dx
						pop cx
						pop bx
						pop ax

						mov ax,0
						mov germs_xarray[si],ax
						mov germs_yarray[di],ax
						dec no_of_germs
				
			.elseif ((ax<spaceship_xvalue) && (dx<b))
					add ax,100
					.if(ax>spaceship_xvalue)
						push ax
						push bx
						push cx
						push dx
						push si
						push di
						;call removeenimies
						pop di
						pop si
						pop dx
						pop cx
						pop bx
						pop ax

						mov ax,0
						mov germs_xarray[si],ax
						mov germs_yarray[di],ax
						dec no_of_germs
					.endif

			.elseif((ax>spaceship_xvalue) && (dx>=b))

					.if(ax<=b)
						push ax
						push bx
						push cx
						push dx
						push si
						push di
						;call removeenimies
						pop di
						pop si
						pop dx
						pop cx
						pop bx
						pop ax
							mov ax,0
							mov germs_xarray[si],ax
							mov germs_yarray[di],ax
							dec no_of_germs
					.endif
			

			.endif


			moveon1:
			add si,2
			add di,2
			add bx,2
			inc count
		;
	.endw
	;dec no_of_germs
	
	ret
function1 endp

simulation proc

			mov spaceship_xvalue,250
			mov spaceship_yvalue,350
			call drawshapes
			call drawspaceship
			.while(no_of_germs > 0)

						mov ah,01
						int 16h
						jz key_not_pressed
						mov ah,00
						int 16h
						cmp ax,4D00h
						je Move_Left
						cmp ax,4B00h
						je Move_Right
						cmp ax,3920h
						je Fire_Bullets
						jmp key_not_pressed
						
						Move_Right:
							.if(spaceship_xvalue>40)
								call clearspaceship
								sub spaceship_xvalue,20
								call drawspaceship
							.else
								mov spaceship_xvalue,250
								mov spaceship_yvalue,350
							.endif
							jmp key_not_pressed
						Move_Left:
							.if(spaceship_xvalue<530)
								call clearspaceship
								add spaceship_xvalue,20
								call drawspaceship
							.else
								mov spaceship_xvalue,250
								mov spaceship_yvalue,350
							.endif
							jmp key_not_pressed
						Fire_Bullets:
							call drawbullets
							;call function1
							;call clearenemies
							;call drawshapes
							sub no_of_germs,1
						key_not_pressed:
						
						 
			.endw


	ret
simulation endp


end main