START: b PROGRAM_1
	 b PROGRAM_2

.define LED_ADDRESS 0x10
.define HEX_ADDRESS 0x20
.define SW_ADDRESS 0x30
.define KEY_ADDRESS 0x40

// st r1, [r3] reserved for TAS r1, [r3] where TAS means Test and Set for Atomic Instructions

// PROGRAM_1 increments all the elements of the DATA array
// by increment amount provided through Switches (SW[8:0])
// It only increments when at least one of the Keys (KEY[3:1]) is pressed
// If number provided by SW is greater than 9999 - array element,
// it sets the element to 9999
 
PROGRAM_1:
	
MAIN_1: 
	mv r4, #DATA
	mvt r3, #KEY_ADDRESS

WAIT_KEY_PRESS:		// Polled I/O
	ld r2, [r3]
	cmp r2, #7
	beq WAIT_KEY_PRESS

	mv r1, r2		// Store the KEY values to check later which KEYs were pressed

WAIT_KEY_RELEASE:
	ld r2, [r3]
	cmp r2, #7
	bne WAIT_KEY_RELEASE 

	mvt r3, #SW_ADDRESS 
	ld r2, [r3]         // Increment/Decrement/Multiplier value given through SW

LOOP_OPERATE:
	push r1		// r1 has the KEY values

	mv r3, #LOCK
	mv r1, #1

WAIT_FOR_UNLOCK_1:		// WAIT FOR UNLOCK
	st r1, [r3]			// TAS r1, [r3]
	cmp r1, #1
	beq WAIT_FOR_UNLOCK_1

	// LOCK ACQUIRED

	ld r0, [r4]
		
	mv r3, #0
	mv r1, #LOCK
	st r3, [r1]		// GIVE UP LOCK

	pop r1		// r1 has the KEY values

	cmp r0, #0		  
	beq MAIN_1		  // Done iterating through array if element is 0

	b KEY_3

	// KEY PRESS is a zero and KEY RELEASE is a one

	mv r3, r1

	and r3, #0b100
	cmp r3, #0	
	beq KEY_3		// KEY[3] given first priority --> i.e KEY[3] and/or other keys

	mv r3, r1

	and r3, #0b010
	cmp r3, #0		
	beq KEY_2		// KEY[2] given second priority --> i.e KEY[2] and/or KEY[1]

	mv r3, r1

	and r3, #0b001
	cmp r3, #0		
	beq KEY_1		// KEY[1] given least priority
	

// INCREMENT
KEY_3:
	// Validating the increment value
	// If number provided by SW is greater than 9999 - array element,
	// it sets the element to 9999
	mv r3, =9999	
	sub r3, r0          
	cmp r3, r2
	bmi SET_TO_HIGHEST
	
	add r0, r2
	b STORE_AND_GO_NEXT

// DECREMENT
KEY_2:
	// Validating the decrement value
	// If number provided by SW is greater than array element,
	// it sets the element to 0000
	cmp r0, r2
	bmi SET_TO_LOWEST

	sub r0, r2
	b STORE_AND_GO_NEXT

// MULTIPLY
KEY_1:
	mv r3, r0

	cmp r2, #0			// Check if multiplier is 0
	beq SET_TO_LOWEST

LOOP_MULTIPLY:

	cmp r2, #1
	beq STORE_AND_GO_NEXT
	
	sub r2, #1

	// Validating the increment value
	// If number provided by SW is such that (element * SW_VALUE) > 9999,
	// it sets the element to 9999
	push r1		// r1 has the KEY values

	mv r1, =9999
	sub r1, r0          
	cmp r1, r3

	bmi SET_TO_HIGHEST_AND_POP

	pop r1

	add r0, r3			// Multiplication is basically repeated addition
	b LOOP_MULTIPLY

SET_TO_HIGHEST_AND_POP:
	pop r1

SET_TO_HIGHEST:
	mv r0, =9999
	b STORE_AND_GO_NEXT

SET_TO_LOWEST:
	mv r0, #0
	b STORE_AND_GO_NEXT

STORE_AND_GO_NEXT:
	mv r3, #LOCK
	mv r1, #1

WAIT_FOR_UNLOCK_2:		// WAIT FOR UNLOCK
	st r1, [r3]			// TAS r1, [r3]
	cmp r1, #1
	beq WAIT_FOR_UNLOCK_2

	// LOCK ACQUIRED

	st r0, [r4]

	mv r3, #0
	mv r1, #LOCK
	st r3, [r1]		  // GIVE UP LOCK

	add r4, #1          // Move on to next element of DATA Array

	b LOOP_OPERATE


// PROGRAM_2 keeps displaying the binary form on LEDs and decimal form on HEX displays

PROGRAM_2:
	 mv sp, =0x1000
MAIN_2:
	mv r4, #DATA
	mv r2, #1
LOOP:
	mv r3, #LOCK
	mv r1, #1

WAIT_FOR_UNLOCK_3:
	st r1, [r3]		// TAS r1, [r3]
	cmp r1, #1			
	beq WAIT_FOR_UNLOCK_3

	// LOCK ACQUIRED
	
	ld r0, [r4]

	mv r3, #0
	mv r1, #LOCK
	st r3, [r1] 			// GIVE UP LOCK
	
	cmp r0, #0		  
	beq MAIN_2		  // Done iterating through array if element is 0

	mvt r3, #LED_ADDRESS
	
	st r0, [r3]			  // Display on LEDs

	bl CONVERT_TO_DECIMAL
	
	push r0
	push r1
	push r3
	push r4
	push r6


	mvt r3, #HEX_ADDRESS
	
	add r3, #5 			// Display the 1-based index of element in array on HEX5
	mv r0, #SEG7
	add r0, r2			// r2 contains the 1-based index of array element

	ld r0, [r0]
	st r0, [r3]

	sub r3, #2			// Point at HEX3 --> because Digit 3 (MSB) is displayed first

	mv r0, #4 			// Number of digits to be displayed
	mv r4, #DIGITS

	push r2
LOOP_DIGITS:
	ld r1, [r4]              // Digit to be displayed on HEX displays

	mv r2, #SEG7
	add r2, r1
	ld r2, [r2] 		 // Bit code to be sent to HEX displays
	st r2, [r3]

	sub r3, #1
	add r4, #1

	sub r0, #1

	bne LOOP_DIGITS

	 mv r0, =0x500
DELAY:
	 sub r0, #1
	 bne DELAY

	pop r2
	pop r6
	pop r4
	pop r3
	pop r1
	pop r0

	add r4, #1

	add r2, #1

	b LOOP

// Subroutine that converts a binary number to decimal
           
CONVERT_TO_DECIMAL:
	push r1
	push r2
	push r3
	push r4
	push r6
	
	mv r1, =1000 		// r1 points to the divisor
					// parameter for DIVIDE
					// Number to be displayed is a parameter passed by MAIN_2 in r0

	mv r4, #DIGITS		// r4 points to the decimal digits storage location

	bl DIVIDE

	st r1, [r4]

	mv r1, =100
	bl DIVIDE
	add r4, #1
	st r1, [r4]
	
	mv r1, =10
	bl DIVIDE
	add r4, #1
	st r1, [r4]
	
	add r4, #1
	st r0, [r4]

	pop r6
	pop r4
	pop r3
	pop r2
	pop r1	
			
	mv pc, lr

// Subroutine to perform the integer division r0 / r1
// Returns: quotient in r1, and remainder in r0

DIVIDE:
	push r2
	push r6
	
	mv r2, #0
CONT:
	cmp r0, r1
	bmi DIV_END
	sub r0, r1
	add r2, #1
	b CONT
DIV_END:
	mv r1, r2

	pop r6
	pop r2
	mv pc, lr

// If LOCK is one, one of the two programs is accessing (read/write) the one of the elements of DATA array
LOCK:
	.word 0

// DATA array with last element as 0 and all numbers are smaller than decimal number 9999
// No element other than last one should be 0 -- otherwise it will mark the end of array
DATA:
	.word 2023
	.word 1947
	.word 2002
	.word 245
	.word 1104
	.word 0

// Space to store 4 digits of an array element
DIGITS:
	.word 0
	.word 0
	.word 0
	.word 0

// Bit codes for digits 0-9 on hex displays
SEG7:  .word 0b00111111       // '0'
       .word 0b00000110       // '1'
       .word 0b01011011       // '2'
       .word 0b01001111       // '3'
       .word 0b01100110       // '4'
       .word 0b01101101       // '5'
       .word 0b01111101       // '6'
       .word 0b00000111       // '7'
       .word 0b01111111       // '8'
       .word 0b01100111       // '9'