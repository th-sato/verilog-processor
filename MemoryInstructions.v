module MemoryInstructions (
	input reset,
	input clock50,
	input clock,
	input flagMI,
	input [1:0] flagShift,
	input [11:0] shift,
	input [11:0] address,
	input [11:0] addressWrite,
	input [31:0] receiveInstruction,
	output [31:0] instruction
);	
	wire [11:0] addrShift;
	reg [11:0] shiftMI;

	assign addrShift = address + shiftMI;
	//addressWrite deve ser alterado --> sobreescrever o SO
	
	Memory MI(
		.data(receiveInstruction),
		.read_addr(addrShift),
		.write_addr(addressWrite),
		.we(flagMI),
		.read_clock(clock50),
		.write_clock(clock),
		.q(instruction)
	);
	
	
	always@(posedge clock) begin
		if (reset == 1) 
			shiftMI = 12'd0;
		if (flagShift == 2'd1) //BIOS, SO
			shiftMI = 12'd0;
		else if (flagShift == 2'd2) //Processos
			shiftMI = shift;
	end
	
endmodule
