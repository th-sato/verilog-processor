module IN (
	input [15:0] data,
	output [31:0] dataIN
);

	assign dataIN = {16'd0, data};
	
endmodule

