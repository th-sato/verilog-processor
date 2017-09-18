module Display7 (
	input [3:0] Q,
	output reg [6:0] OUT
);
	always@(Q) begin
		case(Q)
			0: OUT = 7'b1000000;
			1: OUT = 7'b1111001;
			2: OUT = 7'b0100100;
			3: OUT = 7'b0110000;
			4: OUT = 7'b0011001;
			5: OUT = 7'b0010010;
			6: OUT = 7'b0000010;
			7: OUT = 7'b1111000;
			8: OUT = 7'b0000000;
			9: OUT = 7'b0010000;
			11: OUT = 7'b0111111; //Sinal negativo
			default: begin
				OUT = 7'b1111111;
			end
		endcase
	end
endmodule
