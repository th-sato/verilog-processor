module Divisor(CLOCK, NEW_CLOCK);
	input CLOCK;
	output NEW_CLOCK;
	reg[24:0] contador;
	always@(posedge CLOCK) begin
		contador <= contador + 1;
	end
	assign NEW_CLOCK = contador[10]; //22
endmodule