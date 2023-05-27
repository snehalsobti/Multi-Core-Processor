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

### General Encoding Format

Each instruction is being encoded in a 16-bit format. On a broader level, there are two types of encoding being used:  
* III 0 XXX 000000YYY,
These are the instructions that can be used to implement assembly code programs on my Multi-Core Processor

