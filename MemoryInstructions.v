module MemoryInstructions (
	input clock,
	input clock50,
	input flagMI,
	input flagShift,
	input flagSO,
	input [11:0] shift,
	input [11:0] address,
	input [11:0] addressWrite,
	input [31:0] receiveInstruction,
	output [31:0] instruction
);
	integer init = 1;
	
	reg [11:0] addrShift;
	reg [11:0] shiftMI;

	MemoryI MI(
		.data(receiveInstruction),
		.read_addr(addrShift),
		.write_addr(addressWrite),
		.we(flagMI),
		.read_clock(clock50),
		.write_clock(clock),
		.q(instruction)
	);
	
	always@(*) begin
		if(flagSO != 0)
			addrShift = address + shiftMI;
		else // Sistema operacional
			addrShift = address;
	end
	
	always@(posedge clock) begin
		if (init == 1) begin
			shiftMI = 12'd0;
			init = 0;
		end
		if(flagShift == 1)
			shiftMI = shift;
	end
	
endmodule
