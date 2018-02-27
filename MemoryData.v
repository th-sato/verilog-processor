module MemoryData (
	input reset,
	input clock,
	input clock50,
	input flagMD,
	input [1:0] flagShift,
	input [11:0] shift, 
	input [11:0] address,
	input [31:0] data,
	output [31:0] read
);

	wire [11:0] addrShift;
	reg [11:0] shiftMD;
	
	assign addrShift = shiftMD + address;
	
	Memory MD (
		.data(data),
		.read_addr(addrShift),
		.write_addr(addrShift),
		.we(flagMD),
		.read_clock(clock50),
		.write_clock(clock),
		.q(read)
	);
	
	
	always@(posedge clock) begin
		if (reset == 1)
			shiftMD = 12'd0;
		if(flagShift == 2'd1) //Processos
			shiftMD = 12'd0;
		else if (flagShift == 2'd2)  //BIOS, SO
			shiftMD = shift;
	end
	
endmodule

