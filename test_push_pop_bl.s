START: b PROGRAM_1
END_2: b END_2

PROGRAM_1:
 	  mv    sp, =0x1000   // sp = 0x1000 = 4096
	  mv   r2, =0x1000 // LED_ADDRESS
        mv    r4, =0xFF
        push  r4
	  st    r4, [r2]
	  mv    r1, =0xffff
DELAY:	
	  sub r1, #1
	  bne  DELAY

        bl    SUBR

	  st    r4, [r2]
	  mv    r1, =0xffff
DELAY3:	
	  sub r1, #1
	  bne  DELAY3


        pop   r4
	
	  st    r4, [r2]
	  mv    r1, =0xffff
DELAY4:	
	  sub r1, #1
	  bne  DELAY4

           		
END:    b     END

SUBR:   sub   r4, #0xF
	  st    r4, [r2]
	  mv    r1, =0xffff
DELAY2:	
	  sub r1, #1
	  bne  DELAY2
        mv    pc, lr
