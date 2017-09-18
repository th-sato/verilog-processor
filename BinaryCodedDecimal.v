module BinaryCodedDecimal (
	input [9:0] binary,
	output reg [3:0] hundred,
	output reg [3:0] ten,
	output reg [3:0] one
);
	integer i;
	reg [9:0] conversion;
	
	always@ (binary) begin
		if(binary[9] == 1) begin
			conversion = binary - 10'd1;
			conversion = ~conversion;
		end
		else conversion = binary;
		hundred = 4'd0;
		ten = 4'd0;
		one = 4'd0;
		for (i=9; i>=0; i=i-1) begin
			if(hundred >= 5) hundred = hundred + 4'd3;
			if(ten >= 5) ten = ten + 4'd3;
			if(one >= 5) one = one + 4'd3;
				
			hundred = hundred << 1;
			hundred[0] = ten[3];
			ten = ten << 1;
			ten[0] = one[3];
			one = one << 1;
			one[0] = conversion[i];
		end
	end
	
endmodule
