# 5-Stage-Pipelined-MIPS-Processor-with-Hazard-Handling

A complete 32-bit MIPS Pipeline Processor implemented in Verilog HDL with support for hazard detection, data forwarding, pipeline registers, and basic MIPS instructions. This project demonstrates the architecture and operation of a classic 5-stage pipelined CPU.

###` Features:`
1.32-bit MIPS Architecture
2.Five Pipeline Stages:
Instruction Fetch (IF)
Instruction Decode (ID)
Execute (EX)
Memory Access (MEM)
Write Back (WB)
3.Pipeline Registers:
IF/ID
ID/EX
EX/MEM
MEM/WB
4.Hazard Detection Unit
5.Forwarding Unit
6.Branch Handling and Pipeline Flush
7.Sign Extension and Shift-Left Unit
8.Register File and Data Memory
9.ALU and ALU Control Unit
10.Verilog Testbench Included
11.Waveform Generation using VCD

### `Supported Instructions:`
1.R-Type Instructions
ADD
SUB
AND
OR
NOR
SLT
2.I-Type Instructions
ADDI
LW
SW
BEQ

### `Hazard Handling:`

### Data Hazards:
`Handled using:`
Forwarding Unit
EX/MEM → EX forwarding
MEM/WB → EX forwarding


### Load-Use Hazards:
`Handled using:`
Hazard Detection Unit
Pipeline stalling
Insertion of NOPs


### Control Hazards:
`Handled using:`
Branch detection
Pipeline flushing

### `Pipeline Registers:`
IF → IF/ID → ID → ID/EX → EX → EX/MEM → MEM → MEM/WB → WB

### `Project Structure:`
├── dff_async_clear.v
├── reg32.v
├── PC.v
├── InstructionMemory.v
├── RegisterFile.v
├── DataMemory.v
├── Control.v
├── ALUControl.v
├── ALU.v
├── SignExtend.v
├── Adder.v
├── ShiftLeft2.v
├── MUX2.v
├── MUX2_5bit.v
├── MUX3.v
├── HazardDetectionUnit.v
├── ForwardingUnit.v
├── IF_ID.v
├── ID_EX.v
├── EX_MEM.v
├── MEM_WB.v
├── MIPS_Pipeline.v
├── tb_MIPS_Pipeline.v
└── README.md
