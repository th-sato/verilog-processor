module ArithmeticLogicUnit (clock, State, OPCODE, flagALU, FUNCT, RDvalue, RSvalue, RTvalue, shamt, immediate, flagBRANCH);
	parameter flag = 2, bitsOP = 6, bitsS = 5, bits = 32, st = 3;
	input clock;
	input [st-1:0] State; //5 estados
	input [flag-1:0] flagALU;
	//Codigo da operacao
	input[bitsOP-1:0] OPCODE, FUNCT; //6 bits
	//Valor do deslocamento
	input[bitsS-1:0] shamt; //5 bits
	//Valor imediato
	input[bits-1:0] immediate; //32 bits
	//Valores dos registradores
	input [bits-1:0] RSvalue, RTvalue; //32 bits
	output reg [bits-1:0] RDvalue; //32 bits
	output reg flagBRANCH;
	always@ (posedge clock) begin //Mudar parâmetro do always?
		if (flagALU == 2'd1) begin
			case (FUNCT)
				0: RDvalue = RSvalue + RTvalue; //ADD
				1: RDvalue = RSvalue + immediate; //ADDI
				2: RDvalue = RSvalue - RTvalue; //SUB: Complemento de 2
				3: RDvalue = RSvalue - immediate; //SUBI
				4: RDvalue = RSvalue & RTvalue; //AND
				5: RDvalue = RSvalue & immediate; //ANDI
				6: RDvalue = RSvalue | RTvalue; //OR
				7: RDvalue = RSvalue | immediate; //ORI
				8: RDvalue = RSvalue ^ RTvalue; //XOR
				9: RDvalue = ~(RSvalue | RTvalue); //NOR
				10: RDvalue = ~RSvalue; //NOT
				11: begin //SLT
					if (RSvalue < RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
//				12: begin //SLTI
//					if (RSvalue < immediate) RDvalue = 32'd1;
//					else RDvalue = 32'd0;
//				end
				12: begin //SLE
					if (RSvalue <= RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
				13: begin //SGT
					if (RSvalue > RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
				14: begin //SGE
					if (RSvalue >= RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
				15: begin //EQ
					if (RSvalue == RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
				16: begin //NEQ
					if (RSvalue != RTvalue) RDvalue = 32'd1;
					else RDvalue = 32'd0;
				end
				17: RDvalue = RSvalue*RTvalue;
				18: RDvalue = RSvalue/RTvalue;
//				13: RDvalue = RSvalue * RTvalue; //MULT: verificar se vai estourar os bits
//				14: RDvalue = RSvalue * immediate; //MULTI
//				15: begin //DIV
//					RDvalue = RSvalue / RTvalue;
//					/*if (RTvalue != 0) 
//					else flagZero = 1; //Enviar uma flag*/
//				end
//				16: begin //DIVI
//					RDvalue = RSvalue / immediate;
//					/*if (immediate != 0) 
//					else flagZero = 1; //Enviar uma flag*/
//				end
				default: RDvalue = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			endcase
		end
		else if (flagALU == 2'd2) begin
			case (OPCODE)
				4: RDvalue = RSvalue >> shamt; //Shift Right Logical
				5: RDvalue = RSvalue << shamt; //Shift Left Logical
				6: begin //BEQ
					if (RSvalue == RTvalue) flagBRANCH = 1;
					else flagBRANCH = 0;
				end
				7: begin //BNQ
					if (RSvalue != RTvalue) flagBRANCH = 1;
					else flagBRANCH = 0;
				end
				default: RDvalue = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			endcase
		end
		if (State == 1 && flagBRANCH == 1) flagBRANCH = 0;
	end
	
endmodule
