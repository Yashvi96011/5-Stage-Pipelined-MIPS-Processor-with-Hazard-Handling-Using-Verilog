# 5-Stage-Pipelined-MIPS-Processor-with-Hazard-Handling

A complete 32-bit MIPS Pipeline Processor implemented in Verilog HDL with support for hazard detection, data forwarding, pipeline registers, and basic MIPS instructions. This project demonstrates the architecture and operation of a classic 5-stage pipelined CPU.

### `Pipeline Registers:`
IF → IF/ID → ID → ID/EX → EX → EX/MEM → MEM → MEM/WB → WB

### `Features:`
1.32-bit MIPS Architecture

2.Five Pipeline Stages:
Instruction Fetch (IF),
Instruction Decode (ID),
Execute (EX),
Memory Access (MEM),
Write Back (WB).

3.Pipeline Registers:
IF/ID,
ID/EX,
EX/MEM,
MEM/WB,

4.Hazard Detection Unit

5.Forwarding Unit

6.Branch Handling and Pipeline Flush

7.Sign Extension and Shift-Left Unit

8.Register File and Data Memory

9.ALU and ALU Control Unit

10.Verilog Testbench Included

11.Waveform Generation using VCD

### `Supported Instructions:`
1.R-Type Instructions:
ADD,
SUB,
AND,
OR,
NOR,
SLT


2.I-Type Instructions:
ADDI,
LW,
SW,
BEQ,

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




# 5-Stage Pipelined MIPS Processor with Hazard Handling

## Overview
This repository contains a fully synthesizable, 32-bit Pipelined MIPS Processor implemented in Verilog HDL. The architecture features a classic 5-stage RISC pipeline integrated with dedicated hardware units to dynamically resolve data, load-use, and control hazards. 

The project demonstrates a production-style approach to computer architecture, emphasizing modular RTL design, strict synchronization between datapath and control paths, and cycle-accurate hardware simulation.

---

## Features
* **32-Bit MIPS Architecture:** Full 32-bit data and instruction paths based on standard RISC principles.
* **5-Stage Pipeline Implementation:** Optimized instruction throughput utilizing standard stages:
  * Instruction Fetch (IF)
  * Instruction Decode (ID)
  * Execute (EX)
  * Memory Access (MEM)
  * Write Back (WB)
* **Active Hazard Management:** * **Forwarding Unit:** Eliminates RAW data hazards via bypassing networks.
  * **Hazard Detection Unit:** Automatically stalls the pipeline and injects hardware NOPs during load-use conflicts.
  * **Branch Handling:** Resolves control hazards dynamically using hardware flushes.
* **Modular Infrastructure:** Decoupled design containing a dual-read/single-write Register File, autonomous Data Memory, ALU Control, and Sign-Extension units.
* **Verification & Diagnostics:** Simulation testbench configured to output Value Change Dump (`.vcd`) waveforms for granular debugging.

---

## Supported Instructions

| Instruction Type | Mnemonic | Operation | Description |
| :--- | :--- | :--- | :--- |
| **R-Type** | `ADD` | $RD \leftarrow RS + RT$ | Signed Addition |
| | `SUB` | $RD \leftarrow RS - RT$ | Signed Subtraction |
| | `AND` | $RD \leftarrow RS \text{ \& } RT$ | Bitwise Logical AND |
| | `OR`  | $RD \leftarrow RS \text{ \| } RT$ | Bitwise Logical OR |
| | `NOR` | $RD \leftarrow \sim(RS \text{ \| } RT)$ | Bitwise Logical NOR |
| | `SLT` | $RD \leftarrow (RS < RT) ? 1 : 0$ | Set Less Than (Signed) |
| **I-Type** | `ADDI`| $RT \leftarrow RS + \text{SignExtImm}$ | Addition Immediate |
| | `LW`  | $RT \leftarrow \text{Mem}[RS + \text{SignExtImm}]$ | Load Word from Data Memory |
| | `SW`  | $\text{Mem}[RS + \text{SignExtImm}] \leftarrow RT$ | Store Word to Data Memory |
| | `BEQ` | $\text{if } (RS == RT) \text{ PC } \leftarrow \text{Target}$ | Branch if Equal |

---

## Architecture

The processing core is partitioned into independent functional RTL blocks to maintain clean design boundaries and optimal timing isolation:

### 1. Control & ALU Control Unit
Decodes opcode and function fields directly from the instruction stream to govern active control lines, register destinations, write-enable signals, and precise ALU operational modes.

### 2. Dual-Port Register File
Implements a synchronous 3-port storage system allowing two independent, parallel read operations and one single write operation per clock cycle.

### 3. Execution Core (ALU)
A 32-bit execution block that processes arithmetic, logic, and comparison operations, feeding immediate computation flags back into the pipeline system.

### 4. Pipeline Registers
Interstage Isolation Registers (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`) propagate instruction payloads, addresses, and corresponding control words synchronously across the clock boundary.



---

## Hazard Handling Architecture

Real-time pipeline correctness is maintained natively in hardware without relying on compiler-inserted software delays:

### Data Hazards (Forwarding Unit)
The structural Forwarding Unit actively sniffs downstream register destinations to intercept Read-After-Write (RAW) data conflicts. Data is routed directly to the ALU inputs via internal multiplexer bypass tracks from:
* `EX/MEM` $\rightarrow$ `EX` Stage
* `MEM/WB` $\rightarrow$ `EX` Stage

### Load-Use Hazards (Hazard Detection Unit)
When an instruction attempts to read a register immediately following a `LW` instruction that modifies it, data cannot be forwarded in time. The Hazard Detection Unit automatically:
1. Intercepts the condition at the `ID` stage.
2. Disables PC and `IF/ID` register updates to freeze instruction progress.
3. Injects a hardware `NOP` (bubble) into the `ID/EX` register to safely split the sequence.

### Control Hazards (Branch Flushing)
Upon a successful evaluation of a `BEQ` conditional branch instruction, speculatively fetched instructions inside the pipeline are invalidated. The Control Unit asserts a synchronous pipeline flush, clearing the mispredicted instruction bytes out of flight to preserve system state integrity.

---

## Project Structure

```text
5-Stage-Pipelined-MIPS-Processor/
│
├── Documentates/
│   ├── Architecture_Overview.md
│   ├── Hazard_Handling_Spec.md
│   ├── Control_Unit_Table.md
│   └── Memory_Mapping.md
│
├── Images/
│   ├── Datapath_Architecture.png
│   ├── Forwarding_Logic.png
│   ├── Pipeline_Stall_Waveform.png
│   └── Branch_Flush_Timing.png
│
├── RTL_Source_Code/
│   ├── MIPS_TOP.v
│   ├── INSTRUCTION_FETCH.v
│   ├── INSTRUCTION_DECODE.v
│   ├── EXECUTE_STAGE.v
│   ├── MEMORY_STAGE.v
│   ├── WRITE_BACK.v
│   ├── REG_FILE.v
│   ├── ALU_32.v
│   ├── HAZARD_DETECTION.v
│   ├── FORWARDING_UNIT.v
│   └── PIPELINE_REGS.v
│
├── Testbenches/
│   ├── MIPS_TOP_TB.v
│   └── Component_Sub_TBs/
│
└── README.md
