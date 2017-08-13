module MemoryInstructions (clock, address, instruction);
	parameter addr = 20, bits = 32, size = 150; //SIZE: 2^10 =1024
	integer initialize = 1; //Responsável por inicializar a matriz de instruções.
	input clock;
	//Endereço da linha e da coluna da instrução
	input [addr-1:0] address;
	output [bits-1:0] instruction;
	reg [bits-1:0] instructionM [size-1:0];
	
	always@ (posedge clock) begin
		if (initialize == 1) begin
/*instructionM[0] = {6'd2, 5'd1, 21'd5}; //R[1] = 5;
instructionM[1] = {6'd2, 5'd2, 21'd3}; //R[2] = 3;
instructionM[2] = {6'd2, 5'd30, 21'd0}; //ASG: R[30] = 0; //Reg1
instructionM[3] = {6'd2, 5'd31, 21'd0}; //LOADI: R[31] = 0; Resultado
instructionM[4] = {6'd0, 5'd30, 5'd30, 5'd2, 5'bx, 6'd0}; //SUM: R[30] = R[30] + R[2];
instructionM[5] = {6'd0, 5'd31, 5'd31, 10'd1, 6'd1}; //ADDI: R[31] = R[31] + 1;
instructionM[6] = {6'd0, 5'd29, 5'd30, 5'd1, 5'd0, 6'd11}; //R[30] < R[1] ? Sim. R[29] = 1
instructionM[7] = {6'd7, 5'd29, 5'd0, 16'd4}; //BNQ: R[29] != R[0]? Sim. Pula
instructionM[8] = {6'd0, 5'd31, 5'd31, 10'd1, 6'd3}; //ADDI: R[31] = R[31] - 1;
instructionM[9] = {6'd15, 5'd31, 21'bx}; //OUT = R[31];
instructionM[10] = {6'd8, 6'd0, 20'd9};
instructionM[11] = {6'd12, 26'd0};*/
instructionM[0] = {6'd8, 6'bxxxxxx, 20'd50};
instructionM[1] = {6'd1, 5'd11, 1'bx, 20'd3};
instructionM[2] = {6'd1, 5'd12, 1'bx, 20'd4};
instructionM[3] = {6'd1, 5'd13, 1'bx, 20'd5};
instructionM[4] = {6'd1, 5'd14, 1'bx, 20'd6};
instructionM[5] = {6'd2, 5'd21, 21'd0};
instructionM[6] = {6'd3, 5'd21, 1'bx, 20'd7};
instructionM[7] = {6'd1, 5'd15, 1'bx, 20'd7};
instructionM[8] = {6'd2, 5'd22, 21'd0};
instructionM[9] = {6'd0, 5'd1, 5'd15, 5'd22, 5'bxxxxx, 6'd14};
instructionM[10] = {6'd6, 5'd1, 5'd0, 16'd48};
instructionM[11] = {6'd2, 5'd22, 21'd2};
instructionM[12] = {6'd0, 5'd1, 5'd11, 5'd22, 5'bxxxxx, 6'd11};
instructionM[13] = {6'd6, 5'd1, 5'd0, 16'd17};
instructionM[14] = {6'd0, 5'd1, 5'd11, 5'd12, 5'bxxxxx, 6'd0};
instructionM[15] = {6'd3, 5'd1, 1'bx, 20'd7};
instructionM[16] = {6'd0, 5'd15, 5'd1, 10'd0, 6'd1};
instructionM[17] = {6'd2, 5'd22, 21'd2};
instructionM[18] = {6'd0, 5'd1, 5'd12, 5'd22, 5'bxxxxx, 6'd13};
instructionM[19] = {6'd6, 5'd1, 5'd0, 16'd25};
instructionM[20] = {6'd0, 5'd1, 5'd15, 5'd12, 5'bxxxxx, 6'd0};
instructionM[21] = {6'd0, 5'd1, 5'd1, 5'd13, 5'bxxxxx, 6'd0};
instructionM[22] = {6'd3, 5'd1, 1'bx, 20'd7};
instructionM[23] = {6'd0, 5'd15, 5'd1, 10'd0, 6'd1};
instructionM[24] = {6'd8, 6'bxxxxxx, 20'd29};
instructionM[25] = {6'd2, 5'd22, 21'd3};
instructionM[26] = {6'd0, 5'd1, 5'd15, 5'd22, 5'bxxxxx, 6'd17};
instructionM[27] = {6'd3, 5'd1, 1'bx, 20'd7};
instructionM[28] = {6'd0, 5'd15, 5'd1, 10'd0, 6'd1};
instructionM[29] = {6'd2, 5'd22, 21'd4};
instructionM[30] = {6'd0, 5'd1, 5'd14, 5'd22, 5'bxxxxx, 6'd12};
instructionM[31] = {6'd6, 5'd1, 5'd0, 16'd47};
instructionM[32] = {6'd2, 5'd22, 21'd0};
instructionM[33] = {6'd0, 5'd1, 5'd13, 5'd22, 5'bxxxxx, 6'd15};
instructionM[34] = {6'd6, 5'd1, 5'd0, 16'd38};
instructionM[35] = {6'd2, 5'd31, 21'd0};
instructionM[36] = {6'd1, 5'd30, 1'bx, 20'd2};
instructionM[37] = {6'd9, 5'd30, 21'd0};
instructionM[38] = {6'd2, 5'd22, 21'd0};
instructionM[39] = {6'd0, 5'd1, 5'd15, 5'd22, 5'bxxxxx, 6'd16};
instructionM[40] = {6'd6, 5'd1, 5'd0, 16'd47};
instructionM[41] = {6'd2, 5'd22, 21'd1};
instructionM[42] = {6'd0, 5'd1, 5'd14, 5'd22, 5'bxxxxx, 6'd2};
instructionM[43] = {6'd0, 5'd1, 5'd15, 5'd1, 5'bxxxxx, 6'd18};
instructionM[44] = {6'd0, 5'd31, 5'd1, 10'd0, 6'd1};
instructionM[45] = {6'd1, 5'd30, 1'bx, 20'd2};
instructionM[46] = {6'd9, 5'd30, 21'd0};
instructionM[47] = {6'd8, 6'bxxxxxx, 20'd7};
instructionM[48] = {6'd1, 5'd30, 1'bx, 20'd2};
instructionM[49] = {6'd9, 5'd30, 21'd0};
instructionM[50] = {6'd14, 5'd29, 21'd0};
instructionM[51] = {6'd0, 5'd1, 5'd29, 10'd0, 6'd1};
instructionM[52] = {6'd2, 5'd11, 21'd0};
instructionM[53] = {6'd2, 5'd22, 21'd0};
instructionM[54] = {6'd0, 5'd2, 5'd11, 5'd22, 5'bxxxxx, 6'd0};
instructionM[55] = {6'd17, 5'd1, 5'd2, 16'd0};
instructionM[56] = {6'd2, 5'd22, 21'd0};
instructionM[57] = {6'd0, 5'd1, 5'd11, 5'd22, 5'bxxxxx, 6'd0};
instructionM[58] = {6'd2, 5'd21, 21'd1};
instructionM[59] = {6'd3, 5'd21, 1'bx, 20'd3};
instructionM[60] = {6'd16, 5'd1, 5'd1, 16'd0};
instructionM[61] = {6'd3, 5'd1, 1'bx, 20'd4};
instructionM[62] = {6'd2, 5'd21, 21'd3};
instructionM[63] = {6'd3, 5'd21, 1'bx, 20'd5};
instructionM[64] = {6'd2, 5'd21, 21'd4};
instructionM[65] = {6'd3, 5'd21, 1'bx, 20'd6};
instructionM[66] = {6'd2, 5'd21, 21'd69};
instructionM[67] = {6'd3, 5'd21, 1'bx, 20'd2};
instructionM[68] = {6'd8, 6'bxxxxxx, 20'd1};
instructionM[69] = {6'd0, 5'd1, 5'd31, 10'd0, 6'd1};
instructionM[70] = {6'd2, 5'd11, 21'd0};
instructionM[71] = {6'd2, 5'd22, 21'd1};
instructionM[72] = {6'd0, 5'd2, 5'd11, 5'd22, 5'bxxxxx, 6'd0};
instructionM[73] = {6'd17, 5'd1, 5'd2, 16'd0};
instructionM[74] = {6'd2, 5'd22, 21'd1};
instructionM[75] = {6'd0, 5'd1, 5'd11, 5'd22, 5'bxxxxx, 6'd0};
instructionM[76] = {6'd16, 5'd1, 5'd1, 16'd0};
instructionM[77] = {6'd0, 5'd29, 5'd1, 10'd0, 6'd1};
instructionM[78] = {6'd15, 5'd29, 21'd0};
instructionM[79] = {6'd12, 5'd29, 21'd0};





		initialize <= 0;
		end
	end
	
	assign instruction = instructionM[address];
	
endmodule
