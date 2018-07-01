module Divisor(
	input CLOCK,
	input reset,
	input enter,
	input flagIN,
	input flagSend,
	input flagReceive,
	input send_confirmS,
	input send_confirmR,
	output reg NEW_CLOCK
);
	reg[24:0] contador;
	
	always@(posedge CLOCK) begin
		if(flagIN == 1) begin
			NEW_CLOCK = enter;
		end
		else if (flagSend == 1) begin
			NEW_CLOCK = send_confirmS;
		end
		else if (flagReceive == 1) begin
			NEW_CLOCK = send_confirmR;
		end
		else begin 
			contador = contador + 25'd1;
			NEW_CLOCK = contador[5]; //15, 13.
		end
	end
endmodule
