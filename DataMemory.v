module DataMemory (
	input clock,
	input flagDM,
	input [19:0] address,
	input [31:0] data,
	output [31:0] read
);
	parameter size = 100;
	integer i;
	
	reg [31:0] DataM[size-1:0];
	
	assign read = DataM[address]; //Leitura
	
	always@ (posedge clock) begin
		if(flagDM == 1) //Escrita
			DataM[address] = data;
	end
endmodule
