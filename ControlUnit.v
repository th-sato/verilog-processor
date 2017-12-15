module ControlUnit (
	input clock,
	input reset,
	input interruption,
	input flagJB,
	input [5:0] opcode,
	output reg flagDM, //Escrita na memoria de dados
	output reg flagJR, //Jump Register
	output reg flagLSR, //Load Register, Store Register
	output reg flagRF, //Escrita no banco de registradores
	output reg flagAddrRF, //Enndereço do RF para escrita
	output reg flagOUT, //Apresentar valor
	output reg [2:0] flagPC, //Incremento no endereço da memoria de instruçoes
	output reg [1:0] flagBQ, //Branches
	output reg [2:0] flagMuxRF,
	output reg flagHD,
	output reg flagDataToHD,
	output reg flagShift,
	output reg flagMI,
	output reg flagMP,
	output reg [2:0] flagUpdateData,
	output reg LED //LED indicando leitura de valor
);
	localparam [5:0] ALU = 6'd0, LW = 6'd1, LI = 6'd2, LR = 6'd3, SW = 6'd4, SR = 6'd5,
							BEQ = 6'd6, BNQ = 6'd7, JMP = 6'd8, JR = 6'd9, NOP = 6'd10,
							HLT = 6'd11, IN = 6'd12, OUT = 6'd13, DLY_OUT = 6'd14,
							DLY_NOT_OUT = 6'd15,  END_BIOS = 6'd16,
							LOAD_IM_FROM_HD = 6'd17, RF_to_HD = 6'd18, HD_to_RF = 6'd19,
							HD_to_MD = 6'd20, WRITE_DATA_HD = 6'd21, SET_MULTIPROG = 6'd22,
							SET_QUANTUM = 6'd23, SET_ADDR_CS = 6'd24, SET_PC_PROCESS = 6'd25,
							GET_PC_PROCESS = 6'd26, EXEC_PROCESS_X = 6'd27, SET_PROCESS = 6'd28;
		
	always@ (*) begin
		if (reset == 1) begin
			flagShift = 0;
			flagHD = 0;
			flagDataToHD = 0;
			flagMP = 0;
			flagUpdateData = 3'd0;
			flagMI = 0;
			flagDM = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagAddrRF = 0;
			flagOUT = 0;
			flagPC = 3'd0;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
			LED = 0;
		end
		else if (interruption == 0) begin
			case (opcode)
				ALU: begin //Operações lógicas e aritméticas
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd1;
					LED = 0;
				end
				LW: begin //Load Word
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
					LED = 0;
				end
				LI: begin //LOADI
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd4;
					LED = 0;
				end
				SW: begin //Store Word
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 1;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				BEQ: begin //Branch Equal
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd1;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 3'd2;
					else flagPC = 3'd1;
					LED = 0;
				end
				BNQ: begin //Branch Not Equal
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd2;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 3'd2;
					else flagPC = 3'd1;
					LED = 0;
				end
				JMP: begin //Jump
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd2;
					LED = 0;
				end
				JR: begin //Jump register
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 1;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd2;
					LED = 0;
				end
				NOP: begin //No operation
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd1;
					LED = 0;
				end
				HLT: begin //HALT
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd0;
					LED = 0;
				end
				IN: begin //IN
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd3;
					flagPC = 3'd1;
					LED = 1;
				end
				OUT: begin //OUT
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd1;
					LED = 0;
				end
				LR: begin //LOADR
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
					flagPC = 3'd1;
					LED = 0;
				end
				SR: begin //STORER
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 1;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 3'd1;
					LED = 0;
				end
				DLY_OUT: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 1;
					flagPC = 3'd3;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				DLY_NOT_OUT: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd3;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				END_BIOS: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 1;
					flagPC = 3'd4;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				LOAD_IM_FROM_HD: begin
					flagShift = 0;
					flagDM = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagHD = 0;
					flagMI = 1;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				RF_to_HD: begin
					flagShift = 0;
					flagDM = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 1;
					flagOUT = 0;
					flagHD = 1;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				HD_to_RF: begin
					flagShift = 0;
					flagDM = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 1;
					flagOUT = 0;
					flagHD = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd5;
					LED = 0;
				end
				HD_to_MD: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd5;
					LED = 0;
				end
				WRITE_DATA_HD: begin
					flagShift = 0;
					flagHD = 1;
					flagDataToHD = 1;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				SET_MULTIPROG: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 1;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				SET_QUANTUM: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd1;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				SET_ADDR_CS: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 1;
					flagUpdateData = 3'd2;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				SET_PC_PROCESS: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd3;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				GET_PC_PROCESS: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd7;
					LED = 0;
				end
				EXEC_PROCESS_X: begin
					flagShift = 1;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagAddrRF = 0;
					flagOUT = 0;
					flagDM = 0;
					flagMI = 0;
					flagPC = 3'd5;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				SET_PROCESS: begin
				
				end
				default: begin
					flagShift = 0;
					flagHD = 0;
					flagDataToHD = 0;
					flagMP = 0;
					flagUpdateData = 3'd0;
					flagMI = 0;
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagAddrRF = 0;
					flagOUT = 0;
					flagPC = 3'd0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
			endcase
		end
		else begin
			flagShift = 0;
			flagHD = 0;
			flagDataToHD = 0;
			flagMP = 0;
			flagUpdateData = 3'd0;
			flagMI = 0;
			flagDM = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagAddrRF = 0;
			flagOUT = 0;
			flagPC = 3'd0;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
			LED = 0;
		end
	end
endmodule
