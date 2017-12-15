module BinaryCodedDecimal (
	input [15:0] binary,
	output reg [3:0] thousand,
	output reg [3:0] hundred,
	output reg [3:0] ten,
	output reg [3:0] one
);
	integer i;
	
	always@ (binary) begin
		thousand = 4'd0;
		hundred = 4'd0;
		ten = 4'd0;
		one = 4'd0;
		for (i=15; i>=0; i=i-1) begin
			if(thousand >= 5) thousand = thousand + 4'd3;
			if(hundred >= 5) hundred = hundred + 4'd3;
			if(ten >= 5) ten = ten + 4'd3;
			if(one >= 5) one = one + 4'd3;
			
			thousand = thousand << 1;
			thousand[0] = hundred[3];
			hundred = hundred << 1;
			hundred[0] = ten[3];
			ten = ten << 1;
			ten[0] = one[3];
			one = one << 1;
			one[0] = binary[i];
		end
	end
	
endmodule
