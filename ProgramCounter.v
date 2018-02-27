module ProgramCounter
#(parameter ADDR_WIDTH=12)
(
	input clock,
	input reset,
	input [2:0] flagPC,
	input [(ADDR_WIDTH-1):0] newAddress,
	output reg [(ADDR_WIDTH-1):0] address
);
	integer initialize = 1;
	localparam [2:0] INCREASE = 3'd1, JUMP = 3'd2, DELAY = 3'd3;
	
	wire [31:0] delay;
	reg [31:0] count;
	
	assign delay = 32'd750000;
	
	always@ (posedge clock) begin
		if(initialize == 1) begin
			address = 12'd0;		//Endereço para execução da instrução
			count = 32'd0;
			initialize = 0;
		end
		if (reset == 1) begin 	//Começa a executar o programa da primeira linha.
			address = 12'd0;
			count = 32'd0;
		end
		else begin
			case(flagPC)
				INCREASE: address = address + 12'd1;
				JUMP: address = newAddress;
				DELAY: begin
					if(count < delay) count = count + 32'd1;
					else begin
						count = 32'd0;
						address = address + 12'd1;
					end		
				end
			endcase	
		end
	end
	
endmodule
