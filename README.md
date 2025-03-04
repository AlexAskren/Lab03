# Lab03
top_riscv_main\
– Processor
	HDL design 1 ALU (EX stage) -- CLK
	HDL design 2 Instruction Decode (ID stage) -- CLK   (sank)
	HDL design 3 Program counter (IF stage)  -- NO CLK  (deep)
	HDL design 5 Register File (ID stage) -- CLK
	HDL design 7 Control block: ALU operation reorganize (ID/EX stage) -- CLK
	HDL design 8 Instruction Control Logic Branch, and Jump (ID/EX stages) -- CLK
	--HDL design 9 Miscellaneous designs -- CLK
– Instruction memory
	HDL design 4 Instruction Memory File (IF stage) -- NO CLK
– Data memory
	HDL design 6 Data Memory File (MEM stage) -- NO CLK


Program counter -> 
Instruction Decode, Register File, ALU operation reorganize, Instruction Control Logic Branch and Jump ->
ALU ->
Data Memory File
