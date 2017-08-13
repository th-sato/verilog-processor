module MUXADDR (reset, clock, IN, State, flagALU, flagMUXRD, flagDM, flagJAL, flagLI, opcode, funct, shamt, immediate, newAddress, addressJAL, RSvalue, RTvalue, RDvalue, RD_LI, flagRR, flagBRANCH);
	parameter flag = 2, bitsOP = 6, bitsS = 5, bits = 32, st = 3, addr = 20;
	input reset, clock, flagJAL, flagLI, flagRR;
	input [st-1:0] State;
	input [flag-1:0] flagALU, flagMUXRD, flagDM;
	input [bitsOP-1:0] opcode, funct;
	input [bitsS-1:0] shamt;
	input [bits-1:0] immediate, IN;
	input [addr-1:0] newAddress, addressJAL;
	input [bits-1:0] RSvalue, RTvalue, RD_LI;
	output reg [bits-1:0] RDvalue;
	output flagBRANCH;
	
	reg [addr-1:0] newAddr;
	
	MUXRD muxrd1 (.reset(reset), .clock(clock), .IN(IN), .State(State), .flagALU(flagALU), .flagMUXRD(flagMUXRD), .flagDM(flagDM), .flagJAL(flagJAL), .flagLI(flagLI), .opcode(opcode), .funct(funct), .shamt(shamt), .immediate(immediate), .newAddress(newAddr), .addressJAL(addressJAL), .RSvalue(RSvalue), .RTvalue(RTvalue), .RDvalue(RDvalue), .RD_LI(RD_LI), .flagBRANCH(flagBRANCH));	

	always@ (posedge clock) begin	
		if(flagRR == 1)
			newAddr = RTvalue[addr-1:0];
		else 
			newAddr = newAddress;
	end
endmodule
