module DataMemory (clock, reset, flagDM, address, data, read);
	parameter flag = 2, bits = 32, addr = 20, size = 100; //SIZE: 2^20
	integer i;
	input reset, clock;
	input [flag-1:0] flagDM;
	input [addr-1:0] address;
	input [bits-1:0] data;
	output [bits-1:0] read;
	reg [bits-1:0] DataM[size-1:0];
	
	assign read = DataM[address]; //Leitura
	
	always@ (posedge clock) begin
		if (reset == 1) begin
			for (i=size-1; i>=0; i=i-1) begin
				DataM[i] = 32'd0;
			end
		end
		else if (flagDM == 2'd1) DataM[address] = data; //Escrita
	end
	
endmodule
