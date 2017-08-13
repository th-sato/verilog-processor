module ControlUnit (reset, clock, interruption, opcode, flagBRANCH, flagALU, flagRF, flagPC, flagDM, flagMUXRD, flagJAL, flagJR, flagLI, flagOUT, flagRR, State, LED, enter);
	parameter bits = 32, bitsOP = 6, flag = 2, st = 3;
	integer initialize = 0;
	
	input reset, clock, interruption, flagBRANCH, enter;
	input [bitsOP-1:0] opcode;
	
	output reg [st-1:0] State;
	output reg [flag-1:0] flagALU, flagRF, flagPC, flagDM, flagMUXRD;
	output reg flagJR, flagJAL, flagLI, flagOUT, flagRR, LED;
	
	reg Read;
	
	always@ (posedge clock) begin
		if(initialize == 0) begin
			State = 0;
			initialize = 1;
			Read = 1;
			LED = 0;
		end
		if (reset) begin
			State = 0;
			Read = 1;
			LED = 0;
		end
		else if (interruption == 0) begin
			if (Read == 0) State = 2;
			else if (State < 5) State = State + 1;
			else State = 1;
			
			if (State == 1 || State == 0) begin //Busca da instruçao
				flagALU <= 2'd0;
				flagRF <= 2'd0;
				flagPC <= 2'd0;
				flagDM <= 2'd0;
				flagMUXRD <= 2'd0;
				flagJR <= 0;
				flagJAL <= 0;
				flagLI <= 0;
				flagOUT <= 0;
				flagRR <= 0;
			end
			else case (opcode)
				0: begin //Operações lógicas e aritméticas
					case (State)
						3: begin
							flagALU = 2'd1; //ALU
							flagMUXRD = 2'd1; //Define qual RDvalue usar
						end	
						4: flagRF = 2'd1; //Guarda o resultado no banco de registradores
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				end
				1: begin //Load Word
					case (State)
						3: flagMUXRD = 2'd2;
						4: flagRF = 2'd1; //Escreve no banco de registradores
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				end
				2: begin //LOADI
					case (State)
						2: begin
							flagLI = 1;
							flagRF = 2'd1;
						end
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				
				end
				3: begin //Store Word
					case (State)
						2: flagRF = 2'd3; //Leitura dos registradores
						3: flagDM = 2'd1; //Guarda o valor na memoria
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				end
				4: begin //Shift Right Logical
					case (State)
						3: flagALU = 2'd2; //ALU
						4: begin
							flagMUXRD = 2'd1; //Pega o valor da ALU
							flagRF = 2'd1; //Escreve no registrador
						end
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				end
				5: begin //Shift Left Logical
					case (State)
						3: flagALU = 2'd2;//ALU
						4: begin
							flagMUXRD = 2'd1; //Pega o valor da ALU
							flagRF = 2'd1; //Escreve no registrador
						end
						5: flagPC = 2'd1; //Incrementa o valor do PC
					endcase
				end
				6: begin //Branch Equal
					case (State)
						3: flagALU = 2'd2; //ALU
						5: begin
							if (flagBRANCH == 1) flagPC = 2'd2;
							else flagPC = 2'd1;
						end
					endcase
				end
				7: begin //Branch Not Equal
					case (State)
						3: flagALU = 2'd2; //ALU
						5: begin
							if (flagBRANCH == 1) flagPC = 2'd2;
							else flagPC = 2'd1;
						end
					endcase
				end
				8: begin //Jump
					case (State)
						5: flagPC = 2'd2;
					endcase
				end
				9: begin //Jump register
					case (State)
						3: flagJR = 1;
						5: flagPC = 2'd2;
					endcase
				end
				10: begin //Jump and Link
					case (State)
						2: flagJAL = 1;
						3: flagRF = 2'd1;
						5: flagPC = 2'd2;
					endcase
				end
				11: begin //No operation
					case (State)
						5: flagPC = 2'd1;
					endcase
				end
				12: begin //HALT
					flagOUT = 1;
				end
				13: begin //Move
					case (State)
						2: flagRF = 2'd2;
						3: flagRF = 2'd0;
						5: flagPC = 2'd1;
					endcase
				end
				14: begin //IN
					case (State)
						2: begin
							if (enter == 0) begin //Esperando ser lido
								Read = 0;
								LED = 1; //Ligado
							end
							else begin //Foi lido
								Read = 1;
								LED = 0; //Apagado
								flagMUXRD = 2'd3;
							end
						end
						4: flagRF = 2'd1;
						5: flagPC = 2'd1;
					endcase
				end
				15: begin //OUT
					case (State)
						2: flagOUT = 1;
						5: flagPC = 2'd1;
					endcase
				end
				16: begin //LOADR
					case(State)
						2: flagRR = 1;
						3: flagMUXRD = 2'd2;
						4: flagRF = 2'd1;
						5: flagPC = 2'd1;
					endcase
				end
				17: begin //STORER
					case(State)
						2: flagRR = 1;
						3: flagDM = 2'd1;
						5: flagPC = 2'd1;
					endcase
				end
			endcase
		end
		else begin
			flagALU <= 2'd0;
			flagRF <= 2'd0;
			flagPC <= 2'd0;
			flagDM <= 2'd0;
			flagMUXRD <= 2'd0;
			flagJR <= 0;
			flagJAL <= 0;
			flagLI <= 0;
			flagOUT <= 0;
			flagRR <= 0;
		end
	end
endmodule
