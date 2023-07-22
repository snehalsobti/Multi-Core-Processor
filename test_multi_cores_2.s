START: b PROGRAM_1
	b PROGRAM_2
.define LED_ADDRESS 0x10
.define HEX_ADDRESS 0x20
.define SW_ADDRESS 0x30
.define KEY_ADDRESS 0x40
PROGRAM_1:mvt r3, #LED_ADDRESS        // point to LED port
	  mvt r4, #KEY_ADDRESS
	  mv r0, =0b111111111
MAIN_1:   
WAIT:   ld r1, [r4]
	  cmp r1, #7
	  beq WAIT	

        st r0, [r3]                // light up LEDs
	  mv    pc, #MAIN_1

PROGRAM_2:
	  // Display numbers starting from 1 on LEDs
        mvt r3, #LED_ADDRESS        // point to LED port
	  mv r0, #1
MAIN_2:   
	  mv r2, =0xffff
DELAY_2:
	  sub r2, #1
	  bne DELAY_2

        st r0, [r3]                // light up LEDs

	  add r0, #1
	  mv pc, #MAIN_2