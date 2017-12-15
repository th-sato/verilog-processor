module Processor (
	input reset,
	input clock,
	input interruption,
	input [31:0] dataReadDM,
	input [31:0] instruction,
	input [31:0] IN_Data,
	input [31:0] dataFromHD,
	output [31:0] RDvalue,
	output [31:0] RSvalue,
	output [31:0] RTvalue,
	output [31:0] RWValue,
	output [31:0] OUT,
	output [11:0] addressDM,
	output [11:0] addressMI,
	output [5:0] opcode,
	output flagHD,
	output flagDataToHD,
	output flagMI,
	output flagShift,
	output LED,
	output flagDM, //Escrita na memoria de dados
	output flagOUT,
	output executeMI,
	output flagSO
);

	wire flagJR, flagLSR, flagRF, flagJB, flagAddrRF, flagMP;
	wire [1:0] flagBQ;
	wire [2:0] flagPC, flagMuxRF, flagUpdateData;
		
	Datapath Datapath1 (
		.reset(reset),
		.clock(clock),
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagAddrRF(flagAddrRF),
		.flagMP(flagMP),
		.flagUpdateData(flagUpdateData),
		.flagPC(flagPC),
		.flagBQ(flagBQ),
		.flagMuxRF(flagMuxRF),
		.dataReadDM(dataReadDM),
		.instruction(instruction),
		.IN(IN_Data),
		.dataFromHD(dataFromHD),
		.executeMI(executeMI),
		.flagSO(flagSO),
		.flagJB(flagJB),
		.opcode(opcode),
		.addressMI(addressMI),
		.addressDM(addressDM),
		.RDvalue(RDvalue),
		.RSvalue(RSvalue),
		.RTvalue(RTvalue),
		.RWValue(RWValue),
		.OUT(OUT)
	);
	
	ControlUnit ControlUnit1 (
		.clock(clock),
		.reset(reset),
		.interruption(interruption),
		.flagJB(flagJB),
		.opcode(opcode),
		.flagDM(flagDM), 					//Outputs
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagAddrRF(flagAddrRF),
		.flagOUT(flagOUT),
		.flagPC(flagPC),
		.flagBQ(flagBQ),
		.flagMuxRF(flagMuxRF),
		.flagHD(flagHD),
		.flagDataToHD(flagDataToHD),
		.flagShift(flagShift),
		.flagMI(flagMI),
		.flagMP(flagMP),
		.flagUpdateData(flagUpdateData),
		.LED(LED)
	);
	
endmodule
