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
	wire clock;
	wire [5:0] opcode;
	
	Divisor Divisor1 (
		.enter(enter),
		.CLOCK(clock50),
		.opcode(opcode),
		.NEW_CLOCK(clock)
	);
	
	Processor Processor1(
		.reset(reset),
		.clock(clock),
		.interruption(interruption),
		.enter(enter),
		.switches(switches),
		.OUT_H(OUT_H),
		.OUT_T(OUT_T),
		.OUT_O(OUT_O),
		.OUT_N(OUT_N),
		.opcode(opcode),
		.LED(LED)
	);
	
endmodule
