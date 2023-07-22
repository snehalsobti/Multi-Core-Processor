START: 
	b PROGRAM_1
	b PROGRAM_1

.define LED_ADDRESS 0x10
	
PROGRAM_1:
	mv r1, #1
	mv r3, #LOCK
	mv r4, #DATA
	mvt r2, #LED_ADDRESS

WAIT_FOR_UNLOCK_1:		// WAIT FOR UNLOCK
	st r1, [r3]			// TAS r1, [r3]
	cmp r1, #1
	beq WAIT_FOR_UNLOCK_1

	ld r0, [r4]
	
	add r0, #1

	st r0, [r2]

	st r0, [r4]

	mv r3, #0			// GIVE UP LOCK
	mv r1, #LOCK
	st r3, [r1]

	mv r3, =0x400
OUTER_DELAY_LOOP_1:
	sub r3, #1
	bne OUTER_DELAY_LOOP_1

	b PROGRAM_1

PROGRAM_2:
	mv r1, #1
	mv r3, #LOCK
	mv r4, #DATA
	mvt r2, #LED_ADDRESS

WAIT_FOR_UNLOCK_2:		// WAIT FOR UNLOCK
	st r1, [r3]			// TAS r1, [r3]
	cmp r1, #1
	beq WAIT_FOR_UNLOCK_2

	ld r0, [r4]
	
	add r0, #1

	st r0, [r2]

	st r0, [r4]

	mv r3, #0			// GIVE UP LOCK
	mv r1, #LOCK
	st r3, [r1]

	mv r3, =0x400
OUTER_DELAY_LOOP_2:
	sub r3, #1
	bne OUTER_DELAY_LOOP_2

	b PROGRAM_2

LOCK:
	.word 0

DATA:
	.word 0