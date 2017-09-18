module ProgramCounter (
	input clock,
	input reset,
	input [1:0] flagPC,
	input [19:0] newAddress,
	output reg [19:0] address
);
	//Como cada posição da matriz tem 32 bits, temos um total de 4Mb.
	integer initialize = 1;
	
	always@ (posedge clock) begin
		if (initialize == 1) begin
			address = 20'd0;
			initialize = 0;
		end
		if (reset == 1) //Começa a executar o programa da primeira linha.
			address = 20'd0;
		else if (flagPC == 2'd1)
			address = address + 20'd1;
		else if (flagPC == 2'd2)
			address = newAddress; //Jump, Branch, Jump register
	end
	
endmodule
