module ArithmeticLogicUnit (
	input clock,
	input [5:0] funct,
	input [31:0] RSvalue, //Operando 1
	input [31:0] RTvalue, //Operando 2
	input [31:0] immediate, //Valor imediato
	output reg [31:0] RDvalue //Resultado
);
	localparam [5:0] ADD = 6'd0, ADDI = 6'd1, SUB = 6'd2, SUBI = 6'd3, AND = 6'd4, ANDI = 6'd5,
							OR = 6'd6, ORI = 6'd7, XOR = 6'd8, NOR = 6'd9, NOT = 6'd10,
							SLT = 6'd11, SLE = 6'd12, SGT = 6'd13, SGE = 6'd14, EQ = 6'd15,
							NEQ = 6'd16, MULT = 6'd17, DIV = 6'd18;
	
	always@ (*) begin
		case (funct)
			ADD: RDvalue = RSvalue + RTvalue; //ADD
			ADDI: RDvalue = RSvalue + immediate; //ADDI
			SUB: RDvalue = RSvalue - RTvalue; //SUB: Complemento de 2
			SUBI: RDvalue = RSvalue - immediate; //SUBI
			AND: RDvalue = RSvalue & RTvalue; //AND
			ANDI: RDvalue = RSvalue & immediate; //ANDI
			OR: RDvalue = RSvalue | RTvalue; //OR
			ORI: RDvalue = RSvalue | immediate; //ORI
			XOR: RDvalue = RSvalue ^ RTvalue; //XOR
			NOR: RDvalue = ~(RSvalue | RTvalue); //NOR
			NOT: RDvalue = ~RSvalue; //NOT
			SLT: begin //SLT
				if (RSvalue < RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			SLE: begin //SLE
				if (RSvalue <= RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			SGT: begin //SGT
				if (RSvalue > RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			SGE: begin //SGE
				if (RSvalue >= RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			EQ: begin //EQ
				if (RSvalue == RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			NEQ: begin //NEQ
				if (RSvalue != RTvalue) RDvalue = 32'd1;
				else RDvalue = 32'd0;
			end
			//MULT: RDvalue = RSvalue*RTvalue;
			//DIV: RDvalue = RSvalue/RTvalue;
			default: RDvalue = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
	end	
endmodule
