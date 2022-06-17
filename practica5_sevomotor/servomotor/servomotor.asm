.include "m8535def.inc"
.def aux = r16

; Inicializar apuntador de pila
ldi aux,low(ramend)
out spl,aux
ldi aux,high(ramend)
out sph,aux

ser aux
out ddra,aux 
out portb,aux
checa: 
	sbis pinb,0 ;Preguntar si el pinb(0) tiene 1. Si sí saltar a la siguiente instrucción, sino se la va a brincar
	rcall cero
	sbis pinb,1
	rcall uno
	sbis pinb,2
	rcall dos
	sbis pinb,3
	rcall tres
	sbis pinb,4
	rcall cuatro
	sbis pinb,5
	rcall cinco
	sbis pinb,6
	rcall seis
	sbis pinb,7
	rcall siete
	rjmp checa
cero: ;poner 1 en port(a) durante 1ms y 0 por 19ms
	sbi porta,0 ;Poner 1 en porta(0)
	ldi aux,6
	rcall cta
	cbi porta,0 ;Apagar porta(0)
	ldi aux,133
	rcall cta
	ret
uno: 
	sbi porta,0 
	ldi aux,8
	rcall cta
	cbi porta,0 
	ldi aux,132
	rcall cta
	ret
dos: 
	sbi porta,0 
	ldi aux,9
	rcall cta
	cbi porta,0 
	ldi aux,131
	rcall cta
	ret
tres: 
	sbi porta,0 
	ldi aux,10
	rcall cta
	cbi porta,0 
	ldi aux,130
	rcall cta
	ret
cuatro: 
	sbi porta,0 
	ldi aux,11
	rcall cta
	cbi porta,0 
	ldi aux,129
	rcall cta
	ret
cinco: 
	sbi porta,0 
	ldi aux,12
	rcall cta
	cbi porta,0 
	ldi aux,128
	rcall cta
	ret
seis: 
	sbi porta,0 
	ldi aux,13
	rcall cta
	cbi porta,0 
	ldi aux,127
	rcall cta
	ret
siete: 
	sbi porta,0 
	ldi aux,14
	rcall cta
	cbi porta,0 
	ldi aux,126
	rcall cta
	ret

cta:
	rcall retardo
	dec aux
	brne cta
	ret

retardo:
; Assembly code auto-generated
; by utility from Bret Mulvey
; Delay 136 cycles
; 136us at 1.0 MHz

    ldi  r18, 45
L1: dec  r18
    brne L1
    nop
	ret
