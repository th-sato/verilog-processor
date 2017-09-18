module ControlUnit (
	input reset,
	input clock,
	input interruption,
	input flagJB,
	input [5:0] opcode,
	output reg flagDM, //Escrita na memoria de dados
	output reg flagJR, //Jump Register
	output reg flagLSR, //Load Register, Store Register
	output reg flagRF, //Escrita no banco de registradores
	output reg flagOUT, //Apresentar valor
	output reg [1:0] flagPC, //Incremento no endereço da memoria de instruçoes
	output reg [1:0] flagBQ, //Branches
	output reg [2:0] flagMuxRF,
	output reg LED //LED indicando leitura de valor
);
	localparam [5:0] ALU = 6'd0, LW = 6'd1, LI = 6'd2, LR = 6'd3, SW = 6'd4, SR = 6'd5,
							BEQ = 6'd6, BNQ = 6'd7, JMP = 6'd8, JR = 6'd9, NOP = 6'd10,
							HLT = 6'd11, IN = 6'd12, OUT = 6'd13;
	
	always@ (*) begin
		if(reset == 1) begin
			flagDM = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagOUT = 0;
			flagPC = 2'd0;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
			LED = 0;
		end
		else if (interruption == 0) begin
			case (opcode)
				ALU: begin //Operações lógicas e aritméticas
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagOUT = 0;
					flagPC = 2'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd1;
					LED = 0;
				end
				LW: begin //Load Word
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagOUT = 0;
					flagPC = 2'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
					LED = 0;
				end
				LI: begin //LOADI
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagOUT = 0;
					flagPC = 2'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd4;
					LED = 0;
				end
				SW: begin //Store Word
					flagDM = 1;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagPC = 2'd1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
				BEQ: begin //Branch Equal
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd1;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 2'd2;
					else flagPC = 2'd1;
					LED = 0;
				end
				BNQ: begin //Branch Not Equal
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd2;
					flagMuxRF = 3'd0;
					if(flagJB == 1)
						flagPC = 2'd2;
					else flagPC = 2'd1;
					LED = 0;
				end
				JMP: begin //Jump
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd2;
					LED = 0;
				end
				JR: begin //Jump register
					flagDM = 0;
					flagJR = 1;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd2;
					LED = 0;
				end
				NOP: begin //No operation
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd1;
					LED = 0;
				end
				HLT: begin //HALT
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd0;
					LED = 0;
				end
				IN: begin //IN
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 1;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd3;
					flagPC = 2'd1;
					LED = 1;
				end
				OUT: begin //OUT
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 1;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd1;
					LED = 0;
				end
				LR: begin //LOADR
					flagDM = 0;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 1;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd2;
					flagPC = 2'd1;
					LED = 0;
				end
				SR: begin //STORER
					flagDM = 1;
					flagJR = 0;
					flagLSR = 1;
					flagRF = 0;
					flagOUT = 0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					flagPC = 2'd1;
					LED = 0;
				end
				default: begin
					flagDM = 0;
					flagJR = 0;
					flagLSR = 0;
					flagRF = 0;
					flagOUT = 0;
					flagPC = 2'd0;
					flagBQ = 2'd0;
					flagMuxRF = 3'd0;
					LED = 0;
				end
			endcase
		end
		else begin
			flagDM = 0;
			flagJR = 0;
			flagLSR = 0;
			flagRF = 0;
			flagOUT = 0;
			flagPC = 2'd0;
			flagBQ = 2'd0;
			flagMuxRF = 3'd0;
			LED = 0;
		end
	end
endmodule
