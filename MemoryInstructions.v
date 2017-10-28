module MemoryInstructions (
	input clock,
	input [19:0] address,
	output [31:0] instruction
);
	parameter size = 110;
	integer initialize = 1;
	reg [31:0] instructionM [size-1:0];
	
	assign instruction = instructionM[address];
	
	always@ (posedge clock) begin
		if (initialize == 1) begin
instructionM[0] <= {6'd8, 6'bxxxxxx, 20'd1};
instructionM[1] <= {6'd2, 5'd21, 21'd10};
instructionM[2] <= {6'd2, 5'd22, 21'd3};
instructionM[3] <= {6'd2, 5'd27, 21'd0};
instructionM[4] <= {6'd2, 5'd28, 21'd0};
instructionM[5] <= {6'd0, 5'd27, 5'd27, 5'd22, 5'bxxxxx, 6'd0};
instructionM[6] <= {6'd0, 5'd28, 5'd28, 10'd1, 6'd1};
instructionM[7] <= {6'd0, 5'd26, 5'd27, 5'd21, 5'bxxxxx, 6'd11};
instructionM[8] <= {6'd7, 5'd26, 5'd0, 16'd5};
instructionM[9] <= {6'd0, 5'd28, 5'd28, 10'd1, 6'd3};
instructionM[10] <= {6'd0, 5'd1, 5'd28, 10'd0, 6'd1};
instructionM[11] <= {6'd0, 5'd29, 5'd1, 10'd0, 6'd1};
instructionM[12] <= {6'd13, 5'd29, 21'd0};
instructionM[13] <= {6'd11, 5'd29, 21'd0};



			initialize = 0;
		end
	end
	
endmodule
