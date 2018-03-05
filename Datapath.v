module Datapath (
	input reset,
	input clock,
	input flagJR, //Jump Register
	input flagLSR, //Load Register, Store Register
	input flagRF, //Escrita no banco de registradores
	input flagAddrRF, //Endereço do RF para escrita/leitura
	input flagHALT, //Inicia a execução do SO
	input flagExecProc, //Executar um processo
	input [1:0] flagBQ, //Branches
	input [1:0] flagSetValue, //Define o valor de uma das variáveis da multiprogramação
	input [2:0] flagPC, //Incremento no endereço da memoria de instruçoes
	input [2:0] flagMuxRF, //Valor a ser escrito no banco de registradores
	input [31:0] dataReadMD, //Leitura da memoria de dados
	input [31:0] instruction, //Instruçao
	input [31:0] IN, //Entrada de dados
	input [31:0] dataHD,
	output reg flagJB, //Flag para BRANCH
	output reg flagCS, //Para a execução e inicia a troca de contexto
	output reg [1:0] flagShift, //Alterar o valor do shift
	output [5:0] opcode, //OPCODE
	output [11:0] addressMI, //Endereço da instrucao
	output reg [11:0] addressMD, //Endereço para escrita do dado
	output [15:0] outTest, //Saída para testar valores
	output [31:0] RWvalue, //Valores lidos
	output [31:0] RDvalue,
	output [31:0] RSvalue,
	output [31:0] RTvalue,
	output [31:0] OUT_LCD //Valor de saida --> LCD
);

	wire [4:0] RD, RS, RT, addrRW; //Endereços
	wire [5:0] funct; //Campo function
	wire [9:0] imed_op; //Imediato para operaçoes aritmeticas
	wire [20:0] imed_load; //Load imediato
	wire [31:0] resultALU; //Resultado da operacao
	
	reg multProg; //Executar ou não com multiprogramação
	reg [11:0] newAddress; //Endereço para salto
	reg [11:0] addrCS; //Endereço para troca de contexto (context switch)
	reg [11:0] processPC; //Program Counter do processo que sofreu preempção
	reg [31:0] quantum; //Valor do quantum
	reg [31:0] imed_op_ext; //Valor imediato (10 bits)
	reg [31:0] imed_load_ext; //Valor imediato (21 bits)
	reg [31:0] data; //Valor de escrita no banco de registradores
	reg [31:0] contQ; //Contador para troca de contexto (Quantum)
	
	RegisterFile RegisterFile1 (
		.clock(clock),
		.reset(reset),
		.flagRF(flagRF),
		.addrRW(addrRW),
		.addrRD(RD),
		.addrRS(RS),
		.addrRT(RT),
		.data(data),
		.readRW(RWvalue),
		.readRD(RDvalue),
		.readRS(RSvalue),
		.readRT(RTvalue),
		.regOUT(OUT_LCD)
	);
	
	
	ProgramCounter ProgramCounter1 (
		.clock(clock),
		.reset(reset),
		.flagPC(flagPC),
		.newAddress(newAddress),
		.address(addressMI)
	);
	
	ArithmeticLogicUnit ArithmeticLogicUni1 (
		.clock(clock),
		.funct(funct),
		.RDvalue(resultALU),
		.RSvalue (RSvalue),
		.RTvalue(RTvalue),
		.immediate(imed_op_ext)
	);
	
	//assign outTest = {4'd0,addressMI};
	//assign outTest = {4'd0, addrCS};
	assign outTest = contQ[15:0];
	//IF (flagAddrRF == 1) addrRW = RDvalue[4:0]; //Endereço para escrita no registrador está em um registrador
	//ELSE addrRW = RD; //Endereço está na própria instrução
	assign addrRW = (flagAddrRF == 1)? RDvalue[4:0] : RD;
	assign opcode = instruction [31:26]; //Define a operação a ser executada
	assign RD = instruction [25:21]; //Endereço RD (Banco de registradores)
	assign RS = instruction [20:16]; //Endereço RS (Banco de registradores)
	assign RT = instruction [15:11]; //Endereço RT (Banco de registradores)
	
	assign funct = instruction [5:0]; //FUNCTION (ULA)
	assign imed_op = instruction [15:6]; //OPERAÇÕES COM IMEDIATO (ULA)
	assign imed_load = instruction[20:0]; //LOAD IMEDIATO
//----------------------------------------------------------------------------------------------//
//-------------------- Variáveis responsáveis por controlar a multiprogramação -----------------//
//----------------------------------------------------------------------------------------------//	
	always@ (posedge clock) begin
		if (reset == 1) begin 	//Começa a executar o programa da primeira linha.
			quantum = 32'd500000;
			multProg = 0;
			addrCS = 12'd0;
			processPC = 12'd0;
		end
		else begin
			if(flagSetValue == 2'd1) //Define o valor do quantum.
				quantum = RDvalue;
			else if(flagSetValue == 2'd2) //Define a multiprogramação.
				multProg = imed_load_ext[0];
			else if(flagSetValue == 2'd3) //Define o endereço que deve ir quando acontecer a troca de contexto. 
				addrCS = RDvalue[11:0];
			if((flagCS == 1) || (flagHALT == 1))
				processPC = addressMI;
		end
	end
//----------------------------------------------------------------------------------------------//
//-------------------------------- Alterar o valor do shift ------------------------------------//
//----------------------------------------------------------------------------------------------//	
	always@(*) begin
		if((flagHALT == 1) || (flagCS == 1)) //Executar SO
			flagShift = 2'd1;
		else if(flagExecProc == 1) //Executar processo
			flagShift = 2'd2;
		else //Não alterar o valor do shift
			flagShift = 2'd0;
	end
//----------------------------------------------------------------------------------------------//
//------------------------------- Controla a troca de contexto ---------------------------------//
//----------------------------------------------------------------------------------------------//	
	always@ (posedge clock) begin
		if(reset == 1)
			contQ = 32'd0;
		else if((multProg == 1) && (flagCS == 0)) begin //Multiprogramação ativada
			if((flagHALT == 1) || (flagPC == 3'd3)) //FIM, Delay
				contQ = 32'd0;
			else if(contQ < quantum) //Verifica se é preciso trocar o contexto
				contQ = contQ + 32'd1;
			else contQ = 32'd0;
		end
		else contQ = 32'd0;
	end
	
	always@(*) begin
		if(contQ == quantum) //Verifica se é preciso trocar o contexto
			flagCS = 1; //Indica a troca de contexto
		else flagCS = 0;
	end

//----------------------------------------------------------------------------------------------//
//------------------------------------- Extensão de bits ---------------------------------------//
//----------------------------------------------------------------------------------------------//	
	always@ (*) begin
		//Imediato de 10 bits
		if(imed_op[9] == 1) imed_op_ext = {20'hfffff, 2'b11, imed_op};
		else imed_op_ext = {22'd0, imed_op};
		//Imediato de 21 bits
		if(imed_load[20] == 1) imed_load_ext = {11'b11111111111, imed_load};
		else imed_load_ext = {11'd0, imed_load};
	end
//----------------------------------------------------------------------------------------------//
//--------------------------------- Novo endereço para salto -----------------------------------//
//----------------------------------------------------------------------------------------------//
	always@ (*) begin
		if (flagHALT == 1) begin //Executa o SO
			if(multProg == 1) newAddress = addrCS;
			else newAddress = 12'd0;
		end
		else if(flagCS == 1) //Troca de contexto
			newAddress = addrCS;
		else if (flagJR == 1) //Jump Register
			newAddress = RDvalue [11:0];
		else //Branch
			newAddress = instruction [11:0];
	end
//----------------------------------------------------------------------------------------------//
//--------------------------- Verificar a condição do branch -----------------------------------//
//----------------------------------------------------------------------------------------------//
	always@ (*) begin	
		if(flagBQ == 2'd1) begin //BEQ
			if(RDvalue == RSvalue)
				flagJB = 1; //Realiza o salto
			else flagJB = 0; //Não realiza o salto
		end
		else if (flagBQ == 2'd2) begin //BNQ
			if(RDvalue != RSvalue) 
				flagJB = 1; //Realiza o salto
			else flagJB = 0; //Não realiza o salto
		end
		else flagJB = 0; //Não é um branch
	end
//----------------------------------------------------------------------------------------------//
//----------- Da onde vem o endereço utilizado para acessar a memória de dados? ----------------//
//----------------------------------------------------------------------------------------------//	
	always@ (*) begin
		if(flagLSR == 1) //Load Register, Store Register
			addressMD = RSvalue [11:0]; //Registrador
		else addressMD = instruction [11:0]; //Imediato
	end
//----------------------------------------------------------------------------------------------//
//---------------------------------- De onde vem o dado? ---------------------------------------//
//----------------------------------------------------------------------------------------------//		
	always@ (*) begin
		if(flagMuxRF == 3'd1) data = resultALU; //ALU
		else if(flagMuxRF == 3'd2) data = dataReadMD; //Leitura da Memória de Dados
		else if(flagMuxRF == 3'd3) data = IN; //Entrada
		else if(flagMuxRF == 3'd4) data = imed_load_ext; //Valor imediato
		else if(flagMuxRF == 3'd5) data = {20'd0, processPC}; //PC do último processo executado
		else if(flagMuxRF == 3'd6) data = dataHD;
		else data = 32'd0;
	end
	
endmodule
