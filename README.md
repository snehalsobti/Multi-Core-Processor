# Multi-Core-Processor
A 16-bit, 8-register Multi-Core Processor designed using Verilog HDL (Hardware Description Language) with a wide range of memory mapped I/O and various additional functionalities. The processor has two cores but it is highly scalable. Memory arbiter policy has been implemented to avoid memory access conflicts among multiple cores. In addition to that, Atomic Instructions have also been implemented to avoid memory access conflicts when multiple cores try to access the same memory location.   

## Disclaimer
This repository explains the functionalities of this Multi-Core Processor and also contains the test programs along with the snapshots of the running programs. Although most of the content in this Processor was above and beyond the course expectations (which were just to implement some of the basic instructions of a processor), I cannot publicly share the actual code for the processor to prevent students from committing Academic Integrity violations by copying it.   

Employers are encouraged to ask me for the Code if they are considering hiring me.  

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
* III 0 XXX 000000YYY --> involves only registers
* III 1 XXX DDDDDDDDD --> involves register as well as immediate data #D <br/>
Here, III denotes the operation code, XXX denotes register X (operand 1), YYY denotes register Y (operand 2) or DDDDDDDDD denotes #D (operand 2) <br/>

## Instructions

These are the instructions that can be used to implement assembly code programs on my Multi-Core Processor

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
There are 10 LEDs - LED9 to LED0. LED9 is reserved to show the ```Run``` status of the processor. To display something on LEDs, the 9 bits are written at address 0x1000.  
1 means on and 0 means off  

### 7-Segment HEX Displays (Address - 0x2000 to 0x2005)
There are 6 7-segment HEX Displays - HEX0 to HEX5. To display something on a HEX display, the 7 bits for a 7-segment display are written at the corresponding address of that HEX display.  
For example, if 01111111 written at address 0x2004 --> turns on all the segments of HEX4  

### Switches (Address - 0x3000)  
There are 10 switches - SW9 to SW0. SW9 is reserved to control the ```Run``` status of the processor. To fetch any input from the switches, the 9 bits are read from address 0x3000. For example, if SW9, SW6, SW2 and SW1 are on and all other switches are off --> ```Run``` will be equal to 1 and when we read from address 0x3000, we get the 9 bits as 001000110   

### Pushbuttons (Address - 0x4000)  
There are 4 pushbuttons - KEY3 to KEY0. To fetch any input from the pushbuttons, the 4 bits are read from address 0x4000. For example, if KEY3 is pressed --> when we read from address 0x4000, we get the 4 bits as 1000. So, we can perform Polled I/O.  

## Fundamental Idea behind Multi-Core Processor 

* First of all, I built a Verilog module named ```proc``` for a processor that can handle all the instructions mentioned in the section above.
* Now, in the top-level module, I create two instances of ```proc``` named ```procA``` and ```procB```. So, basically, I get the two cores A and B of my multi-core processor.
* The next step would be to handle the conflicts regarding memory and I/O access that might happen between the two cores. These conflicts are handled using the concept of memory arbiter and atomic instructions

### Memory Arbiter  

* Both the cores share the same memory --> So, they have the same ```data_in``` signal. But both of them have separate ```read```, ```write```, and ```data_out``` signals.
* I also use separate ```Run``` signals named ```Run_A``` and ```Run_B``` for both the cores. So, basically, the ```Run``` signal controlled by SW9 and the handling of memory and I/O conflicts decide the values of ```Run_A``` and ```Run_B```. Priority is given to ```procA``` in case both the cores need to access memory at the exact same time.
* So, the role of the memory arbiter is that if there is a memory or an I/O access conflict between the two cores, decide which core should be given access to what resource, that basically means allocating resources among the cores.
* In addition to this, each of the cores outputs an atomic signal as well. An atomic signal is output when an atomic instruction is performed. Basically, we use the atomic instruction in our assembly code (.s file) when we know that the two cores might be trying to access the exact same memory location simultaneously. (Details regarding Atomic Instructions are discussed in detail in a separate section)
* If neither of the cores output an atomic signal --> both ```Run_A``` and ```Run_B``` are kept *on* by the memory arbiter. In this case, the role of the memory arbiter is to allocate the resources such as memory and I/O to corresponding cores. For example, if at a particular time, ```procA``` is trying to read from the switches and ```procB``` is trying to write to the 7-segment HEX displays, the memory arbiter provides the global ```data_in``` signal to ```procA``` and the global ```data_out``` signal comes from ```procB```. This way, the processor is able to do more than one task in parallel
* If either of the cores output an atomic signal --> the ```Run``` signal of the other core is turned *off* by the memory arbiter. In this case, the role of the memory arbiter is to decide which core of the processor should stay *on* and which one should be strictly turned *off* for some time. For example, if at a particular time, both ```procA``` and ```procB``` are reading switches in separate infinite loops that indicates that there is a possibility that these cores may try to read the switches simultaneously. So, to prevent this, we use atomic instructions in both loops. So, if ```procA``` outputs an atomic signal, ```RunB``` will be turned *off* by the memory arbiter.
* If both the cores try to access the same resource simultaneously, priority is given to ```procA``` by default.

### Atomic Instructions

I have used a TAS (Test And Set) instruction as the atomic instruction in my Multi-Core Processor. Talk about reserved instruction encoding st ...... and also talk about mutex, lock or semaphore .... Talk about when the instruction used and what it does...

Then include the test programs with screenshots...
