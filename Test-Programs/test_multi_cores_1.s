START: b PROGRAM_1
	 b PROGRAM_2

.define LED_ADDRESS 0x10
.define HEX_ADDRESS 0x20
.define SW_ADDRESS 0x30

PROGRAM_1:	
	  // Count from 0 and display on LEDs
        mvt   r3, #LED_ADDRESS        // point to LED port
	  mv r0, #1
MAIN_1:   
	  mv    r2, #0xffff
DELAY_1:
	  sub r2, #1
	  bne DELAY_1
        st    r0, [r3]                // light up LEDs
	  add r0, #1
	    mv    pc, #MAIN_1

PROGRAM_2:	
// This program shows the digits 543210 on the HEX displays. Each digit has to be selected
//  by using the SW switches. Setting SW=0 displays 0, SW=1 displays 1, and so on.
            bl     BLANK                // call subroutine to blank the HEX displays
MAIN:       mvt    r2, #HEX_ADDRESS     // point to HEX port
            mv     r3, #DATA            // used to get 7-segment display pattern

            mvt    r4, #SW_ADDRESS      // point to SW port
            ld     r0, [r4]             // read switches
            and    r0, #0x7             // use only SW2-0
            add    r2, r0               // point to correct HEX display
            add    r3, r0               // point to correct 7-segment pattern

            ld     r0, [r3]             // load the 7-segment pattern
            st     r0, [r2]             // light up HEX display

            mv     pc, #MAIN

// subroutine BLANK
//     This subroutine clears all of the HEX displays
//    input: none
//    returns: nothing
// changes: r0 and r1.
BLANK:      mv     r0, #0               // used for clearing
            mvt    r1, #HEX_ADDRESS     // point to HEX displays
            st     r0, [r1]             // clear HEX0
            add    r1, #1
            st     r0, [r1]             // clear HEX1
            add    r1, #1
            st     r0, [r1]             // clear HEX2
            add    r1, #1
            st     r0, [r1]             // clear HEX3
            add    r1, #1
            st     r0, [r1]             // clear HEX4
            add    r1, #1
            st     r0, [r1]             // clear HEX5

            mv     pc, lr               // return from subroutine

DATA:       .word  0b00111111           // '0'
            .word  0b00000110           // '1'
            .word  0b01011011           // '2'
            .word  0b01001111           // '3'
            .word  0b01100110           // '4'
            .word  0b01101101           // '5'

