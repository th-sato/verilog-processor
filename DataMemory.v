module DataMemory (
	input clock,
	input clock50,
	input flagDM,
	input flagShift,
	input flagSO,
	input [11:0] shift, 
	input [11:0] address,
	input [31:0] data,
	output [31:0] read
);
	integer init = 1; 
	reg [11:0] addrShift;
	reg [11:0] shiftDM;
		
	MemoryD MD (
		.data(data),
		.read_addr(addrShift),
		.write_addr(addrShift),
		.we(flagDM),
		.read_clock(clock50),
		.write_clock(clock),
		.q(read)
	);
	
	always@(*) begin
		if(flagSO != 0)
			addrShift = shiftDM + address;
		else // Sistema operacional
			addrShift = address;
	end
	
	always@(posedge clock) begin
		if (init == 1) begin
			shiftDM = 12'd0;
			init = 0;
		end
		if(flagShift == 1)
			shiftDM = shift;
	end
	
endmodule
