.include"m8535def.inc"
	.def aux = r16
	.def col = r17
	.def cont = r18
reset:
	rjmp main
	.org $009
	rjmp barre 
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	;config puertos de salida
	out ddra,aux
	out ddrc,aux
	;habilitacion pullups portb
	out portb,aux
	;config timercounter0
	ldi aux, 3 ;preescala 3 ck/64
	out tccr0,aux;
	;inicializacion timercounter0
	ldi aux,$C1
	out tcnt0,aux
	;habilitacion timercounter0
	ldi aux,1
	out timsk,aux
	;habilitacion global interrupciones
	sei

	;conf caracteres a mostrar en display
	ldi aux,$06 ;1
	mov r0,aux
	ldi aux,$58 ;c
	mov r1,aux
	ldi aux,$40 ;- 
	mov r2, aux 
	ldi aux,$3f ;0
	mov r3, aux
	ldi aux,$3f ;0
	mov r4,aux
	ldi aux, $78 ;t	
	mov r5,aux
	;carga de numeros
	ldi aux,$3f	;0
	mov r6,aux
	ldi aux,$06	;1
	mov r7,aux
	ldi aux,$5b	;2
	mov r8,aux
	ldi aux,$4f	;3	
	mov r9,aux
	ldi aux,$66	;4
	mov r10,aux
	ldi aux,$6d	;5
	mov r11,aux
	ldi aux,$7d	;6
	mov r12,aux
	ldi aux,$27	;7
	mov r13,aux
	ldi aux,$7f	;8
	mov r14,aux
	ldi aux,$6f	;9 
	mov r15,aux

	;se carga la parte alta y baja del apuntador z con 0
	clr zh	  
	clr zl
	;se carga la parte baja del apuntador x,y con el registro6
	ldi XL,6 
	ldi YL,6
	
	ldi col,4  ;comun display mas a la derecha
loop:
	sbis pinb,0
	rjmp caja1
	sbis pinb,1
	rjmp caja2
	sbis pinb,2
	rjmp caja3
	sbis pinb,3
	rjmp caja4
	sbis pinb,4
	rjmp caja5	

	rjmp loop

barre:
	out porta,zh
	com col
	out portc,col
	com col
	;inicializacion timercounter0
	ldi aux,$C1
	out tcnt0,aux
	
	ld aux,z+
	out porta,aux
	lsl col ;corrimiento a la izquierda
	brcs nvo
salir:
	reti
nvo:
	clr zl
	ldi col,4
	rjmp salir
caja1:
	ldi aux,$06 ;1
	mov r0,aux
inloop1: sbic pinb,0
	rjmp temp
	rjmp inloop1

caja2:
	ldi aux,$5b ;2
	mov r0,aux
inloop2: sbic pinb,1
	rjmp temp
	rjmp inloop2

caja3:
	ldi aux,$4f ;3
	mov r0,aux
inloop3: sbic pinb,2
	rjmp temp
	rjmp inloop3

caja4:
	ldi aux,$66 ;4
	mov r0,aux
inloop4: sbic pinb,3
	rjmp temp
	rjmp inloop4

caja5:
	ldi aux,$6d ;5
	mov r0,aux
inloop5: sbic pinb,4
	rjmp temp
	rjmp inloop5
	
temp:
	cpi cont,9
	brge res
	inc XL
	inc cont
	ld aux,X
	mov r3, aux;digito menos significativo
	rjmp loop
res:
	ldi cont,0
	ldi XL,6
	ld aux,x
	mov r3, aux
	inc YL
	ld aux,Y
	mov r4, aux;
	
	rjmp loop
