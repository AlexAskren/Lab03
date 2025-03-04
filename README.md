# Lab03

## top_riscv_main
- **Processor**
  - HDL design 1: ALU (EX stage) - `CLK`
  - HDL design 2: Instruction Decode (ID stage) - `CLK` (sank)
  - HDL design 3: Program Counter (IF stage) - NO `CLK` (deep)
  - HDL design 5: Register File (ID stage) - `CLK`
  - HDL design 7: Control Block - ALU Operation Reorganize (ID/EX stage) - `CLK`
  - HDL design 8: Instruction Control Logic Branch and Jump (ID/EX stages) - `CLK`
  - HDL design 9: Miscellaneous Designs - `CLK`

- **Instruction Memory**
  - HDL design 4: Instruction Memory File (IF stage) - NO `CLK`

- **Data Memory**
  - HDL design 6: Data Memory File (MEM stage) - NO `CLK`

## Pipeline Flow
1. **Program Counter** (HDL design 3) → 
2. **Instruction Decode** (HDL design 2), **Register File** (HDL design 5), **ALU Operation Reorganize** (HDL design 7), **Branch/Jump Logic** (HDL design 8) → 
3. **ALU** (HDL design 1) → 
4. **Data Memory File** (HDL design 6)