module IN (
	input [14:0] data,
	output reg [31:0] dataIN
);

	always@ (data) begin
		if (data[14] == 1) dataIN = {17'b11111111111111111, data};
		else dataIN = {17'd0, data};
	end
	
endmodule

