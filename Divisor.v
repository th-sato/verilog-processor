module Divisor(
	input CLOCK,
	input enter,
	input [5:0] opcode,
	output reg NEW_CLOCK
);
	reg[24:0] contador;
	
	always@(posedge CLOCK) begin
		if(opcode == 6'd12) NEW_CLOCK = enter;
		else begin 
			contador = contador + 25'd1;
			NEW_CLOCK = contador[15]; //10
		end
	end
endmodule
