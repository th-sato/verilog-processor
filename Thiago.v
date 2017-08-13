module Thiago (reset, clock50, interruption, enter, switches, OUT_H, OUT_T, OUT_O, OUT_N, LED);
	parameter number = 7, read = 15;
	
	input reset, clock50, interruption, enter;
	input [read-1:0] switches;
	output LED;
	output [number-1:0] OUT_H, OUT_T, OUT_O, OUT_N;
	
	wire clock;
	
	Divisor d1 (.CLOCK(clock50), .NEW_CLOCK(clock));
	Processor P1(.reset(reset), .clock(clock), .interruption(interruption), .enter(enter), .switches(switches), .OUT_H(OUT_H), .OUT_T(OUT_T), .OUT_O(OUT_O), .OUT_N(OUT_N), .LED(LED));
	
endmodule
