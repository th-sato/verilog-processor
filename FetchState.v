module FetchState (reset, clock, flagPC, flagJR, newAddress, RSvalue, instruction, address);
	parameter bits =  32, add = 10, addr = 20, flag = 2;
	input reset, clock, flagJR;
	input [flag-1:0] flagPC;
	input [addr-1:0] newAddress;
	input [bits-1:0] RSvalue;
	output [bits-1:0] instruction;
	output [addr-1:0] address;

	reg [add-1:0] newAddr;
	
	ProgramCounter P1 (.clock(clock), .reset(reset), .flagPC(flagPC), .newAddress(newAddr), .address(address));
	MemoryInstructions M1 (.clock(clock), .address(address), .instruction(instruction));

	always@ (posedge clock) begin
		if (flagJR == 1)
			newAddr = RSvalue [addr-1:0];
		else 
			newAddr = newAddress;
	end

endmodule
