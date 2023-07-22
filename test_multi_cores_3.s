START: b PROGRAM_1
	b PROGRAM_2

.define LED_ADDRESS 0x10
.define HEX_ADDRESS 0x20
.define SW_ADDRESS 0x30
.define KEY_ADDRESS 0x40

PROGRAM_1:
	  // Display even numbers on LEDs
	  mvt r3, #LED_ADDRESS        // point to LED port
	  mv r4, #EVEN_DATA
	  mv r5, #ODD_DATA
	  mv r0, #2
MAIN_1: 
  
WAIT_1:   
	  ld r1, [r5]
	  sub r1, r0
	  cmp r1, #-1
	  bne WAIT_1	

	  mv r2, =0x200
DELAY_1:
	  sub r2, #1
	  bne DELAY_1

        st r0, [r3]                // light up LEDs

	  st r0, [r4]

	  add r0, #2
	  mv    pc, #MAIN_1

PROGRAM_2:
	  // Display odd numbers on LEDs
        mvt r3, #LED_ADDRESS        // point to LED port
	  mv r4, #EVEN_DATA
	  mv r5, #ODD_DATA
	  mv r0, #1
MAIN_2:   

WAIT_2:   
	  ld r1, [r4]
	  sub r1, r0
	  cmp r1, #-1
	  bne WAIT_2

	  mv r2, =0x200
DELAY_2:
	  sub r2, #1
	  bne DELAY_2

        st r0, [r3]                // light up LEDs

	  st r0, [r5]

	  add r0, #2
	  mv pc, #MAIN_2

EVEN_DATA:
	.word 0
ODD_DATA:
	.word 0