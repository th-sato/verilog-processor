module ControlUnit (
	input reset, //Reset
	input interruption, //Interrupção, para o processador
	input flagJB, //BRANCH
	input flagCS, //Indica a troca de contexto
	input [5:0] opcode, //OPCODE
	output reg LED, //LED indicando leitura de valor
	output reg flagMI, //Escrita na memoria de instruções
	output reg flagMD, //Escrita na memoria de dados
	output reg flagJR, //Jump Register
	output reg flagLSR, //Load Register, Store Register
	output reg flagRF, //Escrita no banco de registradores
	output reg flagAddrRF, //Endereço do RF para escrita
	output reg flagHALT, //Indica o fim da BIOS
	output reg flagExecProc, //Executar um programa
	output reg flagHD, //Controla a escrita no HD
	output reg flagNumProg, //Setar o programa que está sendo executado
	output reg [1:0] flagBQ, //Branches
	output reg [1:0] flagSetValue, //Decide qual variável terá seu valor alterado
	output reg [2:0] flagPC, //Incremento no endereço da memoria de instruçoes
	output reg [2:0] flagMuxRF, //Decide qual dado será escrito na banco de registradores
	//REDES
	output reg flagSend, //Enviar dado para o Arduino
	output reg flagSOControl, //SO controla as execuçoes de rede
	output reg flagReceive
);
	localparam [5:0] ALU = 6'd0, LW = 6'd1, LI = 6'd2, LR = 6'd3, SW = 6'd4, SR = 6'd5,
							BEQ = 6'd6, BNQ = 6'd7, JMP = 6'd8, JR = 6'd9, NOP = 6'd10,
							HLT = 6'd11, IN = 6'd12, OUT = 6'd13, DELAY = 6'd14,
							//Novas instruções
							HD_TRANSFER_MI = 6'd15, SAVE_RF_HD = 6'd16, REC_RF_HD = 6'd17,
							SAVE_RF_HD_IND = 6'd18, REC_RF_HD_IND = 6'd19, SET_MULTIPROG = 6'd20,
							SET_QUANTUM = 6'd21, SET_ADDR_CS = 6'd22, SET_NUM_PROG = 6'd23,
							EXEC_PROCESS = 6'd24, GET_PC_PROCESS = 6'd25,
							//Receive and Send
							SEND = 6'd26, RECEIVE = 6'd27, SEND_SO = 6'd28, RECEIVE_SO = 6'd29;
							//HD_LOAD_MI = 6'd15, HD_LOAD_MD = 6'd16, HD_STORE = 6'd17,
							//SET_MULTIPROG = 6'd18, SET_QUANTUM = 6'd19, SET_ADDR_CS = 6'd20,
							//SET_NUM_PROG = 6'd21, EXEC_PROCESS = 6'd22, GET_PC_PROCESS = 6'd23;
							

//----------------------------------------------------------------------------------------------//
//------------------------ Controlar as instrucoes de send e receive ---------------------------//
// SEND ----------------------------------------------------------------------------------------//
// RECEIVE -------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagSOControl = 0;
		else if((opcode == SEND) || (opcode == RECEIVE))
			flagSOControl = 1;
		else
			flagSOControl = 0;
	end
							

//----------------------------------------------------------------------------------------------//
//------------------------ Transferir dados Arduino para Processador ---------------------------//
// SEND_SO -------------------------------------------------------------------------------------//
// RECEIVE_SO ----------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagSend = 0;
		else if(opcode == SEND_SO)
			flagSend = 1;
		else
			flagSend = 0;
	end
	
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagReceive = 0;
		else if(opcode == RECEIVE_SO)
			flagReceive = 1;
		else
			flagReceive = 0;
	end
							
//----------------------------------------------------------------------------------------------//
//------------------------ Transferir dados para a Memória de Instruções -----------------------//
// HD_TRANSFER_MI ------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagMI = 0;
		else if(opcode == HD_TRANSFER_MI)
			flagMI = 1;
		else
			flagMI = 0;
	end
	
//----------------------------------------------------------------------------------------------//
//------------------------------------------ HD ------------------------------------------------//
// SAVE_RF_HD ----------------------------------------------------------------------------------//
// SAVE_RF_HD_IND ------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagHD = 0;
		else if((opcode == SAVE_RF_HD) || (opcode == SAVE_RF_HD_IND))
			flagHD = 1;
		else
			flagHD = 0;
	end
//----------------------------------------------------------------------------------------------//
//----------------------------------------- HALT -----------------------------------------------//
// HLT -----------------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagHALT = 0;
		else if(opcode == HLT)
			flagHALT = 1;
		else
			flagHALT = 0;
	end
//----------------------------------------------------------------------------------------------//
//-------------------------------- Executar processo -------------------------------------------//
// EXEC_PROCESS --------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagExecProc = 0;
		else if(opcode == EXEC_PROCESS)
			flagExecProc = 1;
		else
			flagExecProc = 0;
	end
//----------------------------------------------------------------------------------------------//
//------------------------- Setar valores para multiprogramação --------------------------------//
// SET_QUANTUM ---------------------------------------------------------------------------------//
// SET_MULTIPROG -------------------------------------------------------------------------------//
// SET_ADDR_CS ---------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagSetValue = 2'd0;
		else if(opcode == SET_QUANTUM)
			flagSetValue = 2'd1;
		else if(opcode == SET_MULTIPROG)
			flagSetValue = 2'd2;
		else if(opcode == SET_ADDR_CS)
			flagSetValue = 2'd3;
		else
			flagSetValue = 2'd0;
	end
//----------------------------------------------------------------------------------------------//
//------------------------- Apresentar no LCD o programa em execução ---------------------------//
// SET_NUM_PROG --------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@(*) begin
		if((reset == 1) || (interruption == 1) || (flagCS == 1))
			flagNumProg = 0;
		else if(opcode == SET_NUM_PROG)
			flagNumProg = 1;
		else
			flagNumProg = 0;
	end
//----------------------------------------------------------------------------------------------//
//----------------------------------- Demais instruções ----------------------------------------//
//----------------------------------------------------------------------------------------------//
	always@ (*) begin
		if((reset == 1) || (interruption == 1)) begin
			LED = 0;
			flagMD = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagAddrRF = 0;
			flagPC = 3'd0;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
		end
		else if(flagCS == 1) begin
			LED = 0;
			flagMD = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagAddrRF = 0;
			flagPC = 3'd2;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
		end
		else begin
			case (opcode)
				ALU: begin //Operações lógicas e aritméticas
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd1;
				end
				LW: begin //Load Word
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
				end
				LI: begin //LOADI
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd4;
				end
				LR: begin //LOADR
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
				end
				SW: begin //Store Word
					LED = 0;
					flagMD = 1;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SR: begin //STORER
					LED = 0;
					flagMD = 1;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				BEQ: begin //Branch Equal
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagBQ = 2'd1;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 3'd2;
					else flagPC = 3'd1;
				end
				BNQ: begin //Branch Not Equal
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagBQ = 2'd2;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 3'd2;
					else flagPC = 3'd1;
				end
				JMP: begin //Jump
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd2;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				JR: begin //Jump register
					LED = 0;
					flagMD = 0;
					flagJR = 1;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd2;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				NOP: begin //No operation
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				HLT: begin //HALT
					//LED = 0;
					LED = 1;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd2;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				IN: begin //IN
					LED = 1;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd3;
				end
				OUT: begin //OUT
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				DELAY: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd3;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				HD_TRANSFER_MI: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SAVE_RF_HD: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				REC_RF_HD: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd6;
				end
				SAVE_RF_HD_IND: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 1;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				REC_RF_HD_IND: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 1;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd6;
				end
				SET_MULTIPROG: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SET_QUANTUM: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SET_ADDR_CS: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SET_NUM_PROG: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				EXEC_PROCESS: begin
					LED = 0;
					flagMD = 0;
					flagJR = 1;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd2;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				GET_PC_PROCESS: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd5;
				end
				SEND: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				RECEIVE: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				SEND_SO: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
				RECEIVE_SO: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd7;
				end
				default: begin
					LED = 0;
					flagMD = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagPC = 3'd0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
				end
			endcase
		end
	end
endmodule
