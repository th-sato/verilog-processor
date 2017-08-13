module IN (data, dataIN);
	parameter sizeIN = 15, size = 32;
	input [sizeIN-1:0] data;
	output reg [size-1:0] dataIN;
	reg [sizeIN-1:0] extender;
	
	always@ (data) begin
		extender = data;
		if (extender[sizeIN-1] == 1) dataIN = {17'b11111111111111111, extender};
		else dataIN = {17'd0, extender};
	end
	
endmodule

