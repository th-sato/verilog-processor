module Divisor(
	input CLOCK,
	input reset,
	input enter,
	input flagIN,
	output reg NEW_CLOCK
);
	reg[24:0] contador;
	
	always@(posedge CLOCK) begin
		if(flagIN == 1) begin
				NEW_CLOCK = enter;
		end
		else begin 
			contador = contador + 25'd1;
			NEW_CLOCK = contador[5]; //15, 13.
		end
	end
endmodule
