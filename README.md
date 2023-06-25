# Multi-Core-Processor
A 16-bit, 8-register Multi-Core Processor designed using Verilog HDL (Hardware Description Language) with a wide range of memory mapped I/O and various additional functionalities. The processor has two cores but it is highly scalable. Memory arbiter policy has been implemented to avoid memory access conflicts among multiple cores. In addition to that, Atomic Instructions have also been implemented to avoid memory access conflicts when multiple cores try to access the same memory location access.   

## Disclaimer
This repository explains the functionalities of this Multi-Core Processor and also contains the test programs along with the snapshots of the running programs. Although most of the content in this Processor was above and beyond the course expectations (which were just to implement some of the basic instructions of a processor), I cannot publicly share the actual code for the processor to prevent students from committing Academic Integrity violations by copying it.   

Employers are encouraged to ask me for the Code if you are considering hiring me.  

## Terminology used throughout the repository

* rX denotes Register X --> typically the destination register
* rY denotes Register Y --> typically the source register
* The Processor has 8 registers --> r0 to r7 where r5, r6, r7 are reserved for specific purposes
* sp denotes stack pointer --> r5 reserved as sp
* lr denotes link register --> r6 reserved as lr
* pc denotes program counter --> r7 reserved as pc
* LSB means least significant bit and MSB means most significant bit

### General Encoding Format

Each instruction is being encoded in a 16-bit format. On a broader level, there are two types of encoding being used:  
* III 0 XXX 000000YYY,
These are the instructions that can be used to implement assembly code programs on my Multi-Core Processor

## Instructions

Instruction | Assembly | Notation | Encoding | Meaning 
--- | --- | --- | --- | --- 
mv | mv rX, rY | rX <- rY | 000 0 XXX 000000 YYY | Move contents of rY into rX 
mv | mv rX, #D | rX <- #D | 000 1 XXX DDDDDDDDD | Move 9 bits of immediate data #D into rX
mvt | mvt rX, #D | rX <- (#D << 8) | 001 1 XXX 0 DDDDDDDD | Move 8 bits of immediate data #D MSBs of rX
add | add rX, rY | rX <- rX + rY | 010 0 XXX 000000 YYY  | Add rX to rY
add | add rX, #D | rX <- rX + #D | 010 1 XXX DDDDDDDDD  | Add rX to immediate data #D
sub | sub rX, rY | rX <- rX - rY | 011 0 XXX 000000 YYY  | Subtract rY from rX
sub | sub rX, #D | rX <- rX - #D | 011 1 XXX DDDDDDDDD  | Subtract immediate data #D from rX
ld | ld rX, [rY] | rX <- [rY] | 100 0 XXX 000000 YYY | Load data from address rY into rX
pop | pop rX | sp <- rX <- [sp], sp++ | 100 1 XXX 000000 101 | Pop rX from stack
st | st rX, [rY] | [rY] <- rX | 101 0 XXX 000000 YYY | Store rX at address rY
push | push rX | sp--, [sp] <- rX | 101 1 XXX 000000 101 | Push rX onto stack
and | and rX, rY | rX <- rX & rY | 110 0 XXX 000000 YYY | Bitwise AND of rX and rY
and | and rX, #D | rX <- rX & #D | 110 1 XXX DDDDDDDDD  | Bitwise AND of rX and immediate data #D
cmp | cmp rX, rY | Flags Updated | 111 0 XXX 000000 YYY  | Compare rX to rY (update flags according to rX - rY)
cmp | cmp rX, #D | Flags Updated | 111 1 XXX DDDDDDDDD  | Compare rX to immediate data #D (update flags according to rX - #D)
lsl | lsl rX, rY | rX <- rX << rY | 111 0 XXX 10 00 00 YYY  | Logical shift left of rX by rY bits
lsr | lsr rX, rY | rX <- rX >> rY | 111 0 XXX 10 01 00 YYY  | Logical shift right of rX by rY bits
asr | asr rX, rY | rX <- rX >>> rY | 111 0 XXX 10 10 00 YYY  | Arithmetic shift right of rX by rY bits
ror | ror rX, rY | rX <- rX <<>> rY | 111 0 XXX 10 11 00 YYY  | Rotate Right of rX by rY bits
lsl | lsl rX, #D | rX <- rX << #D| 111 0 XXX 11 00 0 DDDD  | Logical shift left of rX by #D bits
lsr | lsr rX, #D | rX <- rX >>#D | 111 0 XXX 11 01 0 DDDD  | Logical shift right of rX by #D bits
asr | asr rX, #D | rX <- rX >>> #D | 111 0 XXX 11 10 0 DDDD  | Arithmetic shift right of rX by #D bits
ror | ror rX, #D | rX <- rX <<>> #D | 111 0 XXX 11 11 0 DDDD  | Rotate Right of rX by #D bits  

## I/O Devices (along with the addresses used for them)  

A memory initialization file (MIF) is used for memory.  It contains the binary for the assembly instructions in a .mif file  

### Memory (Address - 0x0000)  
This memory contains the binary code for the assembly instructions. The memory contains 4096 16-bit words. Memory addresses range from 0x0000 to 0x0FFF.  

### LED (Address - 0x1000)  
There are 10 LEDs. LED10 is reserved to show the *Run* status of the processor. To display something on LEDs, the 9 bits that are written at address 0x1000.  
1 means on and 0 means off  

### 7-Segment HEX Displays (Address - 0x2000 to 0x2005)
There are 6 7-segment HEX Displays - HEX0 to HEX5. To display something on a HEX display, the 7 bits for a 7-segment display are written at the appropriate address.  
For example, if 01111111 written at address 0x2004 --> turns on all the segments of HEX4  

### Switches (Address - 0x3000)  
There are 10 switches (SWs). SW10 is reserved to control the *Run* status of the processor. To 
