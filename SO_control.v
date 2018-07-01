module SO_control (
	input clock,
	input [1:0] address,
	output [31:0] instruction
);

	integer init = 1;
	reg[31:0] ram[2:0];

	assign instruction = ram[address];
	
	always@(posedge clock) begin
		if(init == 1) begin
			//SEND_SO
			ram[0] <= {6'd28, 26'd0};
			//RECEIVE_SO
			ram[1] <= {6'd29, 5'd3, 21'd0};
			init = 0;
		end
	end

endmodule
