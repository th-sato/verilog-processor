module BinaryCodedDecimal (binary, hundred, ten, one);
	parameter bits = 10, number = 4;
	integer i;
	input [bits-1:0] binary;
	output reg [number-1:0] hundred, ten, one;
	reg [bits-1:0] conversion;
	
	always@ (binary) begin
		if(binary[bits-1] == 1) begin
			conversion = binary - 1;
			conversion = ~conversion;
		end
		else conversion = binary;
		hundred = 4'd0;
		ten = 4'd0;
		one = 4'd0;
		for (i=bits-1; i>=0; i=i-1) begin
			if(hundred >= 5) hundred = hundred + 3;
			if(ten >= 5) ten = ten + 3;
			if(one >= 5) one = one + 3;
				
			hundred = hundred << 1;
			hundred[0] = ten[3];
			ten = ten << 1;
			ten[0] = one[3];
			one = one << 1;
			one[0] = conversion[i];
		end
	end
	
endmodule
