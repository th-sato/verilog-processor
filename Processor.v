module Processor (
	input reset, //Reset
	input clock, //Clock
	input interruption, //Para a execução do processador
	input [31:0] dataReadMD, //Dado lido da memória de dados
	input [31:0] instruction, //Instrução a ser executada
	input [31:0] IN_Data, //Valor de entrada
	input [31:0] dataHD, //Valor lido do HD
	output flagMI, //Define a escrita na memória de instruções
	output LED, //LED para indicar que está esperando pela entrada
	output flagMD, //Define a escrita na memória de dados
	output flagHALT, //Indica o fim da BIOS
	output flagHD, //Escrever no HD
	output flagNumProg, //Altera o número do programa em execução
	output [1:0] flagShift, //Alterar o valor do shift
	output [11:0] addressMD, //Endereço da memória de dados
	output [11:0] addressMI, //Endereço da memória de instruções
	output [15:0] outTest, //Saída para testes
	output [31:0] RWvalue, //Valores lidos do banco de registradores
	output [31:0] RDvalue,
	output [31:0] RSvalue,
	output [31:0] RTvalue,
	output [31:0] outLCD //Valor a ser apresentado no LCD
);

	wire flagJR, flagLSR, flagRF, flagJB, flagAddrRF, flagSO;
	wire flagExecProc;
	wire flagCS;
	wire [1:0] flagBQ;
	wire [1:0] flagSetValue;
	wire [2:0] flagPC, flagMuxRF;
	wire [5:0] opcode; //Opcode
	

	Datapath Datapath1 (
/************ INPUT ************/
//1 bit
		.reset(reset),
		.clock(clock),
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagAddrRF(flagAddrRF),
		.flagHALT(flagHALT),
		.flagExecProc(flagExecProc),
//2 bits
		.flagBQ(flagBQ),
		.flagSetValue(flagSetValue),
//3 bits
		.flagPC(flagPC),
		.flagMuxRF(flagMuxRF),
//32 bits
		.dataReadMD(dataReadMD),
		.instruction(instruction),
		.IN(IN_Data),
		.dataHD(dataHD),
/************ OUTPUT ************/
//1 bit
		.flagJB(flagJB),
		.flagCS(flagCS),
//2 bits
		.flagShift(flagShift),
//6 bits
		.opcode(opcode),
//12 bits
		.addressMI(addressMI),
		.addressMD(addressMD),
//16 bits
		.outTest(outTest),
//32 bits
		.RWvalue(RWvalue),
		.RDvalue(RDvalue),
		.RSvalue(RSvalue),
		.RTvalue(RTvalue),
		.OUT_LCD(outLCD)
	);
	
/**********************************************************************************************************************/
/**********************************************************************************************************************/
/**********************************************************************************************************************/	
	
	ControlUnit ControlUnit1 (
/************ INPUT ************/
//1 bit
		.reset(reset),
		.interruption(interruption),
		.flagJB(flagJB),
		.flagCS(flagCS),
//6 bits
		.opcode(opcode), //OPCODE
/************ OUTPUT ************/
//1 bit
		.LED(LED),
		.flagMI(flagMI),
		.flagMD(flagMD),
		.flagJR(flagJR),
		.flagLSR(flagLSR),
		.flagRF(flagRF),
		.flagAddrRF(flagAddrRF),
		.flagHALT(flagHALT),
		.flagExecProc(flagExecProc),
		.flagHD(flagHD),
		.flagNumProg(flagNumProg),
//2 bits
		.flagBQ(flagBQ),
		.flagSetValue(flagSetValue),
//3 bits
		.flagPC(flagPC),
		.flagMuxRF(flagMuxRF)
	);
	
endmodule
