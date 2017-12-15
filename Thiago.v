module Thiago (
	input reset,
	input clock50,
	input enter,
	input [15:0] switches,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O,
	output [6:0] OUT_Th,
	output LED
);
	
	integer initialize = 1;
	
	wire clock, flagOUT, flagDM, flagHD, flagMI, flagDataToHD;
	wire flagShift;
	wire execute, executeMI;
	wire [5:0] opcode;
	wire [11:0] executionAddress, addressDM, shiftMI, shiftDM;
	wire [31:0] instructionHDToMI, RDvalue, RSvalue, RTvalue, RWvalue, dataReadDM, IN_Data, OUT;
	wire [31:0] instructionBIOS, instructionMI;
	wire [31:0] dataFromHD, dataToHD, HD_to_RF_data;
	
	//HD
	wire [3:0] sector;
	wire [9:0] track;
	wire [11:0] addressWriteMI;
	
	reg interruption;
	reg [31:0] instruction;
	
	assign addressWriteMI = RDvalue[11:0]; 	//Endereço MI
	assign sector = RSvalue[3:0];					//Setor
	assign track = RTvalue[9:0];					//Trilha
	assign shiftMI = RDvalue[11:0];				//Shift para as memorias
	assign shiftDM = RSvalue[11:0];				//Shift para as memorias
	
	assign instructionHDToMI = dataFromHD;
	assign HD_to_RF_data = dataFromHD;
	
	assign dataToHD = (flagDataToHD == 0)? RWvalue: RDvalue;
	
	BIOS Bios1(
		.clock(clock),
		.address(executionAddress),
		.instruction(instructionBIOS)
	);
	
	HardDisk HD1(
		.clock(clock),
		.clock50(clock50),
		.flagHD(flagHD),
		.sector(sector),
		.track(track),
		.data(dataToHD),
		.dataOut(dataFromHD)
	);
	
	Divisor Divisor1 (
		.enter(enter),
		.CLOCK(clock50),
		.opcode(opcode),
		.NEW_CLOCK(clock)
	);
	
	MemoryInstructions MemoryInstructions1 (
		.clock(clock),
		.clock50(clock50),
		.flagMI(flagMI),
		.flagShift(flagShift),
		.shift(shiftMI),
		.flagSO(flagSO),
		.address(executionAddress),
		.addressWrite(addressWriteMI),
		.receiveInstruction(instructionHDToMI),
		.instruction(instructionMI)
	);
	
	DataMemory DataMemory1 (
		.clock(clock),
		.clock50(clock50),
		.flagDM(flagDM),
		.flagShift(flagShift),
		.shift(shiftDM),
		.flagSO(flagSO),
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
		.dataFromHD(HD_to_RF_data),
		.RDvalue(RDvalue),
		.RSvalue(RSvalue),
		.RTvalue(RTvalue),
		.RWValue(RWvalue),
		.OUT(OUT),
		.flagHD(flagHD),
		.flagDataToHD(flagDataToHD),
		.flagMI(flagMI),
		.flagShift(flagShift),
		.addressDM(addressDM),
		.addressMI(executionAddress),
		.opcode(opcode),
		.LED(LED),
		.flagDM(flagDM),
		.flagOUT(flagOUT),
		.executeMI(executeMI),
		.flagSO(flagSO)
	);
	
	IN IN1 (
		.data(switches),
		.dataIN(IN_Data)
	);
	
	OUT OUT1 (
		.flagOUT(flagOUT),
		.Value(OUT),
		.OUT_Th(OUT_Th),
		.OUT_H(OUT_H),
		.OUT_T(OUT_T),
		.OUT_O(OUT_O)
	);
	
	OUT_PROCESS OUT2 (
		.flagProcess(),
		.Value(),
		.OUT_T(),
		.OUT_O(),
	);
	
	always@ (posedge clock) begin
		if(initialize == 1) begin
			interruption = 0;
			initialize = 0;
		end	
	end
	
	always@(*) begin
		if(executeMI == 0) instruction = instructionBIOS;
		else instruction = instructionMI;
	end
	
endmodule
