module Processor (reset, clock, interruption, enter, switches, OUT_H, OUT_T, OUT_O, OUT_N, LED);
	parameter flag = 2, bits = 32, op = 6, st = 3, read = 15, number = 7;
	
	input reset, clock, interruption, enter;
	input [read-1:0] switches;
	output [number-1:0] OUT_H, OUT_T, OUT_O, OUT_N;
	output LED;
	
	wire [op-1:0] opcode;
	wire [st-1:0] State;
	wire [flag-1:0] flagALU, flagRF, flagPC, flagDM, flagMUXRD;
	wire flagJR, flagJAL, flagBRANCH, flagLI, flagRR, flagOUT;
	wire [read-1:0] IN_Data;
	wire [bits-1:0] OUT1;
	
	Datapath D1 (.reset(reset), .clock(clock), .State(State), .opcode(opcode), .flagRF(flagRF), .flagALU(flagALU), .flagPC(flagPC), .flagDM(flagDM), .flagJAL(flagJAL), .flagMUXRD(flagMUXRD), .flagJR(flagJR), .flagLI(flagLI), .flagBRANCH(flagBRANCH), .flagRR(flagRR), .IN(IN_Data), .OUT(OUT1));
	ControlUnit C1 (.reset(reset), .clock(clock), .interruption(interruption), .opcode(opcode), .flagBRANCH(flagBRANCH), .flagALU(flagALU), .flagRF(flagRF), .flagPC(flagPC), .flagDM(flagDM), .flagMUXRD(flagMUXRD), .flagJAL(flagJAL), .flagJR(flagJR), .flagLI(flagLI), .flagOUT(flagOUT), .flagRR(flagRR), .State(State), .LED(LED), .enter(enter));
	IN in1 (.data(switches), .dataIN(IN_Data));
	OUT o1 (.flagOUT(flagOUT), .Value(OUT1), .OUT_H(OUT_H), .OUT_T(OUT_T), .OUT_O(OUT_O), .OUT_N(OUT_N));
	

endmodule
