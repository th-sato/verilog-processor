module Processor (
	input reset,
	input clock,
	input interruption,
	input enter,
	input [14:0] switches,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O,
	output [6:0] OUT_N,
	output [5:0] opcode,
	output LED
);

	wire flagDM, flagJR, flagLSR, flagRF, flagOUT, flagJB;
	wire [1:0] flagPC, flagBQ;
	wire [2:0] flagMuxRF;
	wire [31:0] IN_Data;
	wire [31:0] OUT;
		
	Datapath Datapath1 (
		.reset(reset),
		.clock(clock),
		.flagDM(flagDM),
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagPC(flagPC),
		.flagBQ(flagBQ),
		.flagMuxRF(flagMuxRF),
		.IN(IN_Data),
		.flagJB(flagJB),
		.opcode(opcode),
		.OUT(OUT)
	);
	
	ControlUnit ControlUnit1 (
		.reset(reset),
		.clock(clock),
		.interruption(interruption),
		.flagJB(flagJB),
		.opcode(opcode),
		.flagDM(flagDM), //Outputs
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagOUT(flagOUT),
		.flagPC(flagPC),
		.flagBQ(flagBQ),
		.flagMuxRF(flagMuxRF),
		.LED(LED)
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
