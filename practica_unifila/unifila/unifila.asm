.include"m8535def.inc"
.def aux = r16
.def aux2 = r17
.def tcnl = r18
.def tcnh = r19
reset:
	rjmp main
	rjmp boton
.org $008
	rjmp tress
	rjmp onda
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out ddra,aux
	out portd,aux
	ldi aux,5
	out timsk,aux
	ldi aux,2
	out mcucr,aux
	ldi aux,$40
	out gicr,aux
	sei
	ldi aux2,100
	ldi tcnl,$E5
	ldi tcnh,$48
ciclo:
	rjmp ciclo
onda:
	out tcnt0,aux2
	in aux,pina
	com aux
	out porta,aux
	reti
boton:
	out tcnt1l,tcnl
	out tcnt1h,tcnh
	ldi aux,3
	out tccr1b,aux
	ldi aux,2
	out tccr0,aux
	reti
tress:
	ldi aux,0
	out tccr1b,aux
	ldi aux,0
	out tccr0,aux
	reti
