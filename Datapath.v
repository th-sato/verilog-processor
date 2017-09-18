module Datapath (
	input reset,
	input clock,
	input flagDM, //Escrita na memoria de dados
	input flagJR, //Jump Register
	input flagLSR, //Load Register, Store Register
	input flagRF, //Escrita no banco de registradores
	input [1:0] flagPC, //Incremento no endereço da memoria de instruçoes
	input [1:0] flagBQ, //Branches
	input [2:0] flagMuxRF, //Valor a ser escrito no banco de registradores
	input [31:0] IN, //Entrada de dados
	output reg flagJB, //Flag para BRANCH
	output [5:0] opcode, //OPCODE
	output reg [31:0] OUT //Valor de saida (Display)
);
	wire [4:0] RD, RS, RT; //Endereços
	wire [5:0] funct; //Campo function
	wire [9:0] imed_op; //Imediato para operaçoes aritmeticas
	wire [20:0] imed_load; //Load imediato
	wire [19:0] addressMI; //Endereço da instrucao
	wire [31:0] RDvalue, RSvalue, RTvalue; //Valores lidos
	wire [31:0] resultALU; //Resultado da operacao
	wire [31:0] instruction; //Instruçao
	wire [31:0] dataReadDM;
	
	reg [19:0] addressDM; //Endereço para escrita do dado
	reg [19:0] newAddress; //Endereço para salto
	reg [31:0] imed_op_ext; //Valor imediato (10 bits)
	reg [31:0] imed_load_ext; //Valor imediato (21 bits)
	reg [31:0] data; //Valor de escrita no banco de registradores
	
	
	RegisterFile RegisterFile1 (
		.clock(clock),
		.reset(reset),
		.flagRF(flagRF),
		.addressRD(RD),
		.addressRS(RS),
		.addressRT(RT),
		.data(data),
		.readRD(RDvalue),
		.readRS(RSvalue),
		.readRT(RTvalue)
	);
	
	ProgramCounter ProgramCounter1 (
		.clock(clock),
		.reset(reset),
		.flagPC(flagPC),
		.newAddress(newAddress),
		.address(addressMI)
	);
	
	MemoryInstructions MemoryInstructions1 (
		.address(addressMI),
		.instruction(instruction)
	);
	
	ArithmeticLogicUnit ArithmeticLogicUni1 (
		.clock(clock),
		.funct(funct),
		.RDvalue(resultALU),
		.RSvalue (RSvalue),
		.RTvalue(RTvalue),
		.immediate(imed_op_ext)
	);
	
	DataMemory DataMemory1 (
		.clock(clock),
		.flagDM(flagDM),
		.address(addressDM),
		.data(RDvalue),
		.read(dataReadDM)
	);
	
	assign opcode = instruction [31:26];
	assign RD = instruction [25:21];
	assign RS = instruction [20:16];
	assign RT = instruction [15:11];
	
	//assign shamt = instruction [10:6];
	assign funct = instruction [5:0];
	assign imed_op = instruction [15:6];
	assign imed_load = instruction[20:0];
	
	always@ (*) begin
		if(imed_op[9] == 1) imed_op_ext = {20'hfffff, 2'b11, imed_op};
		else imed_op_ext = {22'd0, imed_op};
		
		if(imed_load[20] == 1) imed_load_ext = {11'b11111111111, imed_load};
		else imed_load_ext = {11'd0, imed_load};
	end
	
	always@ (*) begin
		if(flagBQ != 2'd0) //Branch
			newAddress = {4'd0, instruction [15:0]};
		else if (flagJR == 1) //Jump Register
			newAddress = RDvalue [19:0];
		else newAddress = instruction [19:0];
	end
	
	always@ (*) begin	
		if(flagBQ == 2'd1) begin
			if(RDvalue == RSvalue) //BEQ
				flagJB = 1;
			else flagJB = 0;
		end
		else if (flagBQ == 2'd2) begin
			if(RDvalue != RSvalue) //BNQ
				flagJB = 1;
			else flagJB = 0;
		end
		else flagJB = 0;
	end
	
	always@ (*) begin
		if(flagLSR == 1) //Load Register, Store Register
			addressDM = RSvalue [19:0];
		else addressDM = instruction [19:0];
	end
	
	always@ (*) begin
		if(flagMuxRF == 3'd1) data = resultALU;
		else if(flagMuxRF == 3'd2) data = dataReadDM;
		else if(flagMuxRF == 3'd3) data = IN;
		else if(flagMuxRF == 3'd4) data = imed_load_ext;
		else data = 32'd0;
	end
	
	always@ (*) begin
		if(flagMuxRF == 3'd3) OUT = IN;
		else OUT = RDvalue;
	end
endmodule
