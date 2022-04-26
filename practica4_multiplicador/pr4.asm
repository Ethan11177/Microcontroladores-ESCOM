.include"m8535def.inc"
.def aux = r16
.def aux1 = r17
.def aux2 = r18
reset:
	rjmp main
	rjmp subed
	rjmp subei
.org $12
	rjmp mul2
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out ddra,aux
	out portb,aux
	out portd,aux
	ldi aux,0b00001010
	out mcucr,aux
	ldi aux,0b11100000
	out gicr,aux
	sei
ciclo:
	rjmp ciclo
subed:
	in aux,pina
	mov aux1,aux
	andi aux,$0f
	inc aux
	cpi aux,$0A
	breq cer0
uno:
	andi aux1,$f0
	or aux,aux1
	out porta,aux
	reti
cer0:
	clr aux
	rjmp uno
subei:
	ldi aux1,$10
	in aux,pina
	mov aux2,aux
	add aux,aux1
	andi aux,$F0
	cpi aux,$A0
	breq cer1
dos:
	andi aux2,$0F
	or aux,aux2
	out porta,aux
	reti
cer1:
	clr aux
	rjmp dos
mul2:
	clr aux2
	in aux,pina
	mov aux1,aux
	andi aux,$0F
	swap aux1
	andi aux1,$0F
	mul aux,aux1
suma:
	tst r0
	breq ya
	inc aux2
	cpi aux2,$0a
	breq ajd
	dec r0
	brne suma
ya:
	out porta,aux2
	reti
ajd:
	dec r0
	ldi aux,6
	add aux2,aux
	rjmp suma