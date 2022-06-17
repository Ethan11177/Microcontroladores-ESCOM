#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <avr/eeprom.h>

int aux;
int cta_eepr;

unsigned char hex2bcd (unsigned char hex)
{
   unsigned char    bcdHI=hex/10;
   unsigned char      bcdLO=hex%10;
   unsigned char     bcdData= (bcdHI<<4)+bcdLO;    
   return   (bcdData);
}

void config_io(void){
   
   DDRA = 0x01;
   DDRC = 0X0F;
   DDRD = 0XFF;
   DDRB = 0b11111010;
   PORTB = _BV(PB0) | _BV(PB2);
   
   TIMSK = _BV(TOIE0) | _BV(TOIE1) | _BV(TOIE2);

   MCUCSR = _BV(ISC2);
   GICR = _BV(INT2);
   sei();

   TCCR0 = _BV(CS02) | _BV(CS01); 
   TCNT0 = 250;

   cta_eepr = eeprom_read_byte(0x00);
   PORTD = hex2bcd(cta_eepr);
}



ISR(TIMER0_OVF_vect){
   PORTC = 0x00;
   cta_eepr = eeprom_read_byte(0x00);
   cta_eepr++;

   while(!eeprom_is_ready()){
      _delay_ms(10);
   }

   eeprom_write_byte(0x00,cta_eepr);
   PORTD =  hex2bcd(cta_eepr);

   TCCR2 = _BV(CS21);
   TCNT1H = 0xB3;
   TCNT1L = 0xB5;
   TCCR1B = _BV(CS12);
   TCNT0 = 250;
}

ISR(TIMER1_OVF_vect){
	TCNT1H = 0xB3;
	TCNT1L = 0xB5;
	TCCR2 = 0x00;
	TCCR1B = 0x00;
	TCNT0 = 250;
}

ISR(TIMER2_OVF_vect){
	TCNT2 = 256-141;
	aux = PINA ^ 0x01;
	PORTA = aux;
	TCNT0 = 0;
}

ISR(INT2_vect){
   cta_eepr = 0;
   while(!eeprom_is_ready())
      _delay_ms(10);
   eeprom_write_byte(0x00,cta_eepr);
   PORTD = hex2bcd(0);
   //TCNT0 = 250;
}

int main(void){ 
   config_io();
   cta_eepr = 0;
   while (1){
	 PORTC = 256-TCNT0;
   }
 }
