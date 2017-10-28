module Processor (
	input reset,
	input clock,
	input interruption,
	input enter,
	input [31:0] dataReadDM,
	input [31:0] instruction,
	input [31:0] IN_Data,
	output [31:0] RDvalue,
	output [31:0] OUT,
	output [19:0] addressDM,
	output [19:0] addressMI,
	output [5:0] opcode,
	output LED,
	output flagDM, //Escrita na memoria de dados
	output flagOUT
);

	wire flagJR, flagLSR, flagRF, flagJB;
	wire [1:0] flagPC, flagBQ;
	wire [2:0] flagMuxRF;
		
	Datapath Datapath1 (
		.reset(reset),
		.clock(clock),
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagPC(flagPC),
		.flagBQ(flagBQ),
		.flagMuxRF(flagMuxRF),
		.dataReadDM(dataReadDM),
		.instruction(instruction),
		.IN(IN_Data),
		.flagJB(flagJB),
		.opcode(opcode),
		.addressMI(addressMI),
		.addressDM(addressDM),
		.RDvalue(RDvalue),
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
	
endmodule
