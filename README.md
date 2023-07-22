# Multi-Core-Processor
A 16-bit, 8-register Multi-Core Processor designed using Verilog HDL (Hardware Description Language) with a wide range of memory-mapped I/O and various additional functionalities. The processor has two cores but it is highly scalable. A memory arbiter policy has been implemented to avoid memory access conflicts among multiple cores. In addition to that, Atomic Instructions have also been implemented to avoid memory access conflicts when multiple cores try to access the same memory location.  

Each core has its own set of 16-bit 8 registers. My processor can handle two independent programs running on two different cores and both of them can interact with I/O at the same time. Both cores share a single port RAM and multiplex their I/O (which means that both cores can work with all the I/O devices and no partitioning is needed)

## Disclaimer
This repository explains the functionalities of this Multi-Core Processor that I built during a Computer Organization course in my second year of Computer Engineering at UofT. It also contains the test programs (Refer to [Test-Programs](https://github.com/snehalsobti/Multi-Core-Processor/tree/main/Test-Programs)). Although most of the content in this Processor Project was above and beyond the course expectations (which were just to implement a processor capable of handling basic assembly instructions), I cannot publicly share the actual code for the processor to prevent students from committing Academic Integrity violations by copying it.   

Employers are encouraged to ask me for the Code if they are considering hiring me.  

## Terminology used throughout the repository

* rX denotes Register X --> typically the destination register
* rY denotes Register Y --> typically the source register
* The Processor has 8 registers --> r0 to r7 where r5, r6, r7 are reserved for specific purposes
* sp denotes stack pointer --> r5 reserved as sp
* lr denotes link register --> r6 reserved as lr
* pc denotes program counter --> r7 reserved as pc
* LSB means least significant bit and MSB means most significant bit
* I/O denotes Input/Output

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
TAS | st r1, [r3] | Atomic Instruction | 101 0 001 000000 011 | Test And Set Instruction (Refer to [Atomic Instructions](https://github.com/snehalsobti/Multi-Core-Processor/blob/main/README.md#atomic-instructions))

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
There are 4 pushbuttons - KEY3 to KEY0. These are active-low which means that if a KEY is pressed, it will be represented as a 0. KEY0 is reserved for the ```reset``` operation (to reset the processor). To fetch any input from the pushbuttons, the 3 bits (KEY3 to KEY1) are read from address 0x4000. For example, if KEY3 is pressed --> when we read from address 0x4000, we get the 3 bits as 011. So, we can perform Polled I/O for KEYs.

## Fundamental Idea behind Multi-Core Processor 

* First of all, I built a Verilog module named ```proc``` for a processor that can handle all the instructions mentioned in the section above.
* Now, in the top-level module, I create two instances of ```proc``` named ```procA``` and ```procB```. So, basically, I get the two cores A and B of my multi-core processor.
* The next step would be to handle the conflicts regarding memory and I/O access that might happen between the two cores. These conflicts are handled using the concept of memory arbiter and atomic instructions

### Memory Arbiter  

The idea behind accessing the I/O devices is that for each processor, when it wants to write then it will assert the ```write_enable``` output signal, and when it wants to read it will assert the ```read_enable``` signal. In both cases, it asserts the signal and then waits for one cycle and then reads/writes the data. The problem is what happens if both cores attempt to perform an operation (either read or write) in the same cycle. The way I resolve that is to have some logic (i.e. the memory arbiter) in the top-level module which basically says that if both cores have asserted a memory request in the same cycle, then only one core can go through.  

* Both cores can read from / write to all I/O devices and there is a hardware mechanism so that only one core can write at a time, and the other core is forced to wait for a cycle (its ```Run``` turned off) if both try to write in the same cycle
* Both the cores share the same memory --> So, they have the same ```data_in``` signal. But both of them have separate ```read_enable```, ```write_enable```, and ```data_out``` signals.
* I also use separate ```Run``` signals named ```Run_A``` and ```Run_B``` for both the cores. So, basically, the ```Run``` signal controlled by SW9 and the handling of memory and I/O conflicts decide the values of ```Run_A``` and ```Run_B```. Priority is given to ```procA``` in case both the cores need to access memory at the exact same time.
* So, the role of the memory arbiter is that if there is a memory or an I/O access conflict between the two cores, decide which core should be given access to what resource, that basically means allocating resources among the cores.
* In addition to this, each of the cores outputs an atomic signal as well. An atomic signal is output when an atomic instruction is performed. Basically, we use the atomic instruction in our assembly code (.s file) when we know that the two cores might be trying to access the exact same memory location simultaneously. (Details regarding Atomic Instructions are discussed in detail in a separate section)
* If neither of the cores output an atomic signal --> both ```Run_A``` and ```Run_B``` are kept *on* by the memory arbiter. In this case, the role of the memory arbiter is to allocate the resources such as memory and I/O to corresponding cores. For example, if at a particular time, ```procA``` is trying to read from the switches and ```procB``` is trying to write to the 7-segment HEX displays, the memory arbiter provides the global ```data_in``` signal to ```procA``` and the global ```data_out``` signal comes from ```procB```. This way, the processor is able to do more than one task in parallel
* If either of the cores output an atomic signal --> the ```Run``` signal of the other core is turned *off* by the memory arbiter. In this case, the role of the memory arbiter is to decide which core of the processor should stay *on* and which one should be strictly turned *off* for some time. For example, if at a particular time, both ```procA``` and ```procB``` are reading switches in separate infinite loops that indicates that there is a possibility that these cores may try to read the switches simultaneously. So, to prevent this, we use atomic instructions in both loops. So, if ```procA``` outputs an atomic signal, ```RunB``` will be turned *off* by the memory arbiter.
* If both the cores try to access the same resource simultaneously, priority is given to ```procA``` by default.

### Atomic Instructions

I have used a TAS (Test And Set) instruction as the atomic instruction in my Multi-Core Processor. 

#### What is a lock  

* The basic idea behind atomic instructions is that we want to be able to use a data structure called a **Lock** in order to allow multiple cores to read and write to the same memory locations safely. The issue is that if multiple programs are interacting with the same data at the same time then they can get interleaved.
* Conceptually, a Lock is a data structure with the following operations  <br/>
```
Mutex mut = new Mutex(); //create a new lock at some address
mut.lock(); //waits until this thread can “aquire” the lock. If some other core already has it then wait until they release it.
<some other code that should only run on one processor core>
mut.unlock(); //give up the lock, other cores waiting to aquire the lock can now run
```

#### Understanding the need for TAS instruction  

* The idea behind the test and set hardware instruction is that you want an instruction that semantically is as follows: ```TAS r0, [r1]``` where r0 contains a flag, typically 1, and r1 contains the address of the lock.
* The instruction will then attempt to perform an ```st r0, [r1]``` instruction, except in addition, it will set some flag so that we can check if the store changed the value that was at R1
* **NOTE**--> We cannot just use a ```load``` instruction and then ```store``` instruction since what if another core changes the value between these two instructions? We need a single instruction that both performs a store and tells us if that store resulted in modifying a value, implemented in hardware.
* The simplest implementation would likely be to define ```TAS r0, [r1]``` to perform a ```st r0, [r1]``` and at the same time modify the value of r0 to be the previous value that was at [r1] before the store. Then to check if our ```TAS``` was a success we compare the values before and after.

#### The implementation of Lock  

Given a TAS instruction the implementation of the lock would be as follows: 
``` 
LOCK_AQUIRE(lock_addr)
{     
    int X = 1 //we attempt to write a 1 into the lock  
    while (true)  
    {  
        TAS X, [lock_addr];  
        if (X == 0) return;  
    }  
}  
```
```  
LOCK_RELEASE(lock_addr)
{    
    *lock_addr = 0; //release the lock  
}  
```

* So, when we perform a test & set instruction to try and write a value of 1 into the lock (remember 1 means we hold the lock). At the same time, the hardware puts the old value of X into register X. After that we check if the old value was 0. If the old value was 0, it means we set the lock from 0 to 1 which means we now hold the lock. If the previous value was 1 it means that some other core already held the lock and so we need to loop and try again.
* To implement this instruction, we add another output port to the ```proc``` module that says ```mem_atomic``` which would work similarly to the ```write_enable``` and ```read_enable```. When ```mem_atomic``` = 1 from a processor, the other processor is turned *off*. (If ```procA``` has ```mem_atomic``` = 1 then ```procB``` gets turned *off*, and vise versa). If both processors are asserting ```mem_atomic``` then we have a policy, such as turning *off* ```procB``` until atomic instruction of ```procA``` is done. This logic is very similar to the logic I already explained for ```write_enable``` and ```read_enable```.
* So, if ```procA``` is in the middle of a ```TAS```, then ```procB``` is not running until that ```TAS``` is done. Likewise, if ```procB``` is in the middle of a ```TAS``` then ```procA``` is not running and won’t ever start one.
* Encoding for TAS instruction -> ```st r1, [r3]``` --> So, store instruction with r1 as rX and r3 as rY is **reserved** for use as TAS instruction in assembly source code

## Test Programs  

I have included the test programs (i.e. the assembly source code files) in this repository (Refer to [Test-Programs](https://github.com/snehalsobti/Multi-Core-Processor/tree/main/Test-Programs)). 
* The ```procA``` core starts its execution of the code at line number 1 and the ```procB``` core starts its execution of the code at line number 2. So, we use branch instructions such as ```b PROGRAM_1``` instruction at line number 1 and ```b PROGRAM_2``` at line number 2.
* The .s files that I have included are to be run on the simulator (such as DESim). To run these assembly programs on DE1_SoC board, wherever I have included software delays by running loops having around 1000 iterations, change it to a larger number such as 5 million iterations
* There are comments added to each source code file that explain the purpose of the particular test program. Additionally, I have also mentioned briefly about all the test program files below.
* **NOTE** --> SW9 is used as the ```Run``` signal for the processor. So, it must be kept *on* to run the processor. Also, KEY0 is used as the ```Reset``` operation for the processor. So, before starting any program, press the ```Reset``` button.
  
The following test programs have been included to test if the processor handles all the assembly code instructions (these do not test the functionality of multiple cores):  

* test_basic_inst.s --> It tests basic instructions such as ```mv```, ```mvt```, ```sub```, ```add```, ```b``` (and ```b``` with other suffixes except ```bl```), ```ld```, ```st```. It shows on HEX displays either PASSEd or FAILEd.
* test_sw_led.s --> It runs a simple program of reading data from switches and displaying the data to the LEDs. For example, if SW6 and SW2 are turned *on*, LEDR6 and LEDR2 will be turned *on*.
* test_shift_cmp.s --> It tests the ```cmp```, ```lsl```, ```lsr```, ```asr```, and ```ror``` instructions. The type of shift operation is selected with SW6 and SW5 (00 == ```lsl```, 01 == ```lsr```, 10 = ```asr```, 11 == ```ror```). The processor must be reset each time these switches are changed, to restart the code. The value to be shifted is displayed on HEX3-0; this value is placed into r0 at the start of the code. The amount to be shifted in each loop iteration is set by SW3 to SW0.
* test_push_pop_bl.s --> It tests the ```push```, ```pop```, and ```bl``` instructions. It simply calls a subroutine and pushes r4 to a stack before calling the subroutine. It then pops r4 off the stack after returning from the subroutine. The value of r4 is modified by the subroutine but as we push before and pop after the subroutine call, we should retain the original value of r4. So, we check this functionality by displaying r4 on LEDs before, during and after the subroutine.

The following test programs have been included to test the functionality and parallelism of multiple cores and atomic instruction: 
* test_multi_cores_1.s --> It includes two completely independent programs for the two cores. There will be no I/O access or same memory location access conflicts.
    * PROGRAM_1 counts from 0 and displays on LEDs.
    * PROGRAM_2 displays the digits 543210 on the HEX displays. Each digit has to be selected by using the SW switches. Setting SW=0 displays 0, SW=1 displays 1, and so on.
* test_multi_cores_2.s --> It includes two programs for the two cores but this time, there will be an I/O access conflict. Both cores will try to write to the LEDs which will test the capability of memory arbiter.
    * PROGRAM_1 reads from KEYs (Pushbuttons). If any of the KEY3, KEY2 or KEY1 is pressed, it turns *on* all the LEDs
    * PROGRAM_2 starts from 1, keeps incrementing by 1, and displays binary form of every number on the LEDs
* test_multi_cores_3.s --> It includes two programs for the two cores but this time, the two cores need to communicate with each other. The two cores need to be in sync to display the numbers in sequence on LEDs such as 0, 1, 2, 3 ...... 
    * PROGRAM_1 displays even numbers on LEDs
    * PROGRAM_2 displays odd numbers on LEDs <br/>
Each core, after displaying an odd / even number, stores in its corresponding data variable what it just displayed. So, we have two variables that keep track of the recently displayed even and odd numbers. So, each core checks through the variables what the other core recently displayed on LEDs (number p) and what it has to print now (number q). If both q = p + 1, this means that the core should display its corresponding number; otherwise, wait for the other core to display.
* Final_Program.s --> It includes two programs but this time both the cores need to access the exact same memory location which is a DATA array. One core needs to read from it and the other needs to read plus modify the DATA array. This is to show the capability of my multi-core processor to handle conflicts related to the exact same memory location.
    * PROGRAM_1 increments all the elements of the DATA array by increment amount provided through Switches. It only increments when at least one of the Pushbuttons is pressed.
    * PROGRAM_2 keeps displaying the binary form of elements of DATA on LEDs and the decimal form of elements of DATA on HEX displays. 
* Final_Legend_Program.s --> It contains only PROGRAM_1. The PROGRAM_1 starts counting from 0 and keeps adding by 1 and displays the number's binary form on LEDs. Both cores run the same program. This is to test the implementation of atomic instruction.
