.include"m8535def.inc"
.def minu=r0
.def mind=r1
.def horu=r2
.def hord=r3
.def tch=r4
.def tcl=r5
.def aux =r16
.def col=r17
.def disp=r18
.def cseg=r19
.def sgnd=r20

reset:
	rjmp main
	rjmp str
.org $008
	rjmp time
	rjmp barre
tabla:
	.db $C0,$F9,$A4,$B0,$99,$92,$82,$D8,$80,$90
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out ddra,aux
	out ddrb,aux
	out portd,aux
	ldi aux,$F0
	out ddrc,aux
	ldi aux,$0F
	out portc,aux
	ldi aux,2  ;0000 0010
	out mcucr,aux
	ldi aux,$40; 0100 0000
	out gicr,aux
	ldi aux,$C2
	mov tch,aux
	ldi aux,$F7
	mov tcl,aux
	ldi aux,2
	out tccr0,aux
	ldi aux,3
	out tccr1b,aux
	out tcnt1l,tcl
	out tcnt1h,tch
	ldi aux,1
	out timsk,aux
	sei
	clr minu
	clr mind
	ldi aux,2
	mov horu,aux
	ldi aux,1
	mov hord,aux
	ldi zh,high(tabla<<1)
	ldi zl,low(tabla<<1)
	clr yl
	ld aux,y+
	ldi col,1
	add zl,aux
	lpm disp,Z
	ldi cseg,60
	ldi sgnd,$80
ciclo:
	sbis pinc,0
	rcall incminu
	sbis pinc,1
	rcall incmind
	sbis pinc,2
	rcall inchr
	rjmp ciclo

incminu:
	inc minu
	mov aux,minu
	cpi aux,10
	brne uno
	clr minu
uno:
	sbis pinc,0
	rjmp uno
	ret

incmind:
	inc mind
	mov aux,mind
	cpi aux,6
	brne dos
	clr mind
dos:
	sbis pinc,1
	rjmp dos
	ret

inchr:
	inc horu
	mov aux,horu
	cpi aux,3
	breq chhd0
	cpi aux,10
	brne sale0
	ldi aux,1
	mov hord,aux
	clr horu
	rjmp sale0
nod0:
	ldi aux,1
	mov horu,aux
	clr hord
sale0:
	sbis pinc,2
	rjmp sale0
	ret
chhd0:
	mov aux,hord
	cpi aux,1
	breq nod0
	rjmp sale0

time:
	out tcnt1l,tcl
	out tcnt1h,tch
	ldi aux,$80
	eor sgnd,aux
	dec cseg
	brne sale
	ldi cseg,60
	inc minu
	mov aux,minu
	cpi aux,10
	brne sale
	clr minu
	inc mind
	mov aux,mind
	cpi aux,6
	brne sale
	clr mind
	inc horu
	mov aux,horu
	cpi aux,3
	breq chhd
	cpi aux,10
	brne sale
	ldi aux,1
	mov hord,aux
	clr horu
	rjmp sale
nod:
	ldi aux,1
	mov horu,aux
	clr hord
sale:
	reti
chhd:
	mov aux,hord
	cpi aux,1
	breq nod
	rjmp sale
barre:
	ser aux
	out portb,aux
	lsl col
	cpi col,$10
	breq nvo
salb:
	ld aux,y+
	ldi zl,low(tabla<<1)
	add zl,aux
	lpm disp,z
	eor disp,sgnd
	out porta,col
	out portb,disp
	reti
nvo:
	clr yl
	ldi col,1
	rjmp salb
str:
	ser aux
	out portc,aux
	ldi aux,5
	out timsk,aux
	reti













