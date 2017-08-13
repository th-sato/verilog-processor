module MUXRD (reset, clock, IN, State, flagALU, flagMUXRD, flagDM, flagJAL, flagLI, opcode, funct, shamt, immediate, newAddress, addressJAL, RSvalue, RTvalue, RDvalue, RD_LI, flagBRANCH);
	parameter flag = 2, bitsOP = 6, bitsS = 5, bits = 32, st = 3, addr = 20;
	input reset, clock, flagJAL, flagLI;
	input [st-1:0] State;
	input [flag-1:0] flagALU, flagMUXRD, flagDM;
	input [bitsOP-1:0] opcode, funct;
	input [bitsS-1:0] shamt;
	input [bits-1:0] immediate, IN;
	input [addr-1:0] newAddress, addressJAL;
	input [bits-1:0] RSvalue, RTvalue, RD_LI;
	output reg [bits-1:0] RDvalue;
	output flagBRANCH;
	
	wire [bits-1:0] RDvalue1, RDvalue2;
	reg [addr-1:0] addrJAL;
		
	ArithmeticLogicUnit A1 (.clock(clock), .State(State), .OPCODE(opcode), .flagALU(flagALU), .FUNCT(funct), .RDvalue(RDvalue1), .RSvalue (RSvalue), .RTvalue(RTvalue), .shamt(shamt), .immediate(immediate), .flagBRANCH(flagBRANCH));
	DataMemory D2 (.clock(clock), .reset(reset), .flagDM(flagDM), .address(newAddress), .data(RSvalue), .read(RDvalue2));
	
	always@ (posedge clock) begin	
		if (flagMUXRD == 2'd1) RDvalue = RDvalue1; //ALU
		else if (flagMUXRD == 2'd2) RDvalue = RDvalue2; //Memoria
		else if (flagMUXRD == 2'd3) RDvalue = IN; //Valor de entrada
		else if (flagJAL == 1) begin
			addrJAL = addressJAL + 1;
			RDvalue = {12'd0, addrJAL}; //Jump and Link
		end
		else if (flagLI == 1) RDvalue = RD_LI; //Load imediato
	end
	
endmodule
