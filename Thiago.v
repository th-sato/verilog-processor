module Thiago (
	input reset,
	input clock50,
	input interruption,
	input enter,
	input [14:0] switches,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O,
	output [6:0] OUT_N,
	output LED
);
	wire clock, flagOUT, flagDM;
	wire [5:0] opcode;
	wire [19:0] addressMI, addressDM;
	wire [31:0] instruction, RDvalue, dataReadDM, IN_Data, OUT;
	
	/*BIOS Bios1(
		.clock(clock)
	);*/
	
	Divisor Divisor1 (
		.enter(enter),
		.CLOCK(clock50),
		.opcode(opcode),
		.NEW_CLOCK(clock)
	);
	
	MemoryInstructions MemoryInstructions1 (
		.clock(clock),
		.address(addressMI),
		.instruction(instruction)
	);
	
	DataMemory DataMemory1 (
		.clock(clock),
		.flagDM(flagDM),
		.address(addressDM),
		.data(RDvalue),
		.read(dataReadDM)
	);
	
	Processor Processor1(
		.reset(reset),
		.clock(clock),
		.interruption(interruption),
		.dataReadDM(dataReadDM),
		.instruction(instruction),
		.IN_Data(IN_Data),
		.RDvalue(RDvalue),
		.OUT(OUT),
		.addressDM(addressDM),
		.addressMI(addressMI),
		.opcode(opcode),
		.LED(LED),
		.flagDM(flagDM),
		.flagOUT(flagOUT)
	);
	
	IN IN1 (
		.data(switches),
		.dataIN(IN_Data)
	);
	
	OUT OUT1 (
		.flagOUT(flagOUT),
		.Value(OUT),
		.OUT_H(OUT_H),
		.OUT_T(OUT_T),
		.OUT_O(OUT_O),
		.OUT_N(OUT_N)
	);
	
endmodule
