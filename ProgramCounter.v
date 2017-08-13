module ProgramCounter (clock, reset, flagPC, newAddress, address);
	parameter flag = 2, addr = 20; //2^10*2^10 = 1024 * 1024
	//Como cada posição da matriz tem 32 bits, temos um total de 4Mb.
	integer initialize = 0;
	input reset, clock;
	input [flag-1:0] flagPC;
	input [addr-1:0] newAddress;
	output reg [addr-1:0] address;
	
	always@ (posedge clock) begin
		if (initialize == 0) begin
			address = 20'd0;
			initialize = 1;
		end
		if (reset == 1) //Começa a executar o programa da primeira linha.
			address = 20'd0;
		else case (flagPC)
			1: address = address + 1;
			2: address = newAddress; //Jump, Branch, Jump register
			default: begin
			end			
		endcase
	end
	
endmodule
