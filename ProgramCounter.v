module ProgramCounter (
	input clock,
	input reset,
	input flagMP,
	input [2:0] flagUpdateData,
	input [2:0] flagPC,
	input [9:0] delay,
	input [11:0] data,
	input [11:0] newAddress,
	output reg execute_process,
	output reg flagSO,
	output reg [11:0] address,
	output reg [11:0] processPC
);
	integer initialize = 1;
	localparam [2:0] INCREASE = 3'd1, JUMP = 3'd2, DELAY = 3'd3, CLEAN = 3'd4,
							CONT_MULTIPROG = 3'd5;
	//Como cada posição da matriz tem 32 bits, temos um total de 4Mb.
	reg [11:0] delay_ext, count, scheduler, quantum, addrContextSwitch;
	reg flagMultiprogramming;
	
	always@ (posedge clock) begin
		if(initialize == 1) begin
			address = 12'd0;
			flagMultiprogramming = 0;
			execute_process = 0;
			count = 12'd0;
			scheduler = 12'd0;
			flagSO = 1;
			initialize = 0;
		end
		if (reset == 1) begin //Começa a executar o programa da primeira linha.
			address = 12'd0;
			flagMultiprogramming = 0;
			execute_process = 0;
			scheduler = 12'd0;
			flagSO = 1;
			count = 12'd0;
		end
		else begin
			case(flagPC)
				INCREASE: address = address + 12'd1;
				JUMP: address = newAddress;
				DELAY: begin
					if(count != delay_ext) count = count + 12'd1;
					else begin
						count = 12'd0;
						address = address + 12'd1;
					end		
				end
				CLEAN: begin
					address = 12'd0;
					execute_process = 1;
				end
				CONT_MULTIPROG: begin
					address = processPC;
					scheduler = 12'd0;
					flagSO = 0;
				end
			endcase	
		end
		
		if(flagUpdateData == 3'd1) quantum = data;
		else if(flagUpdateData == 3'd2) addrContextSwitch = data;
		else if(flagUpdateData == 3'd3) processPC = data;
		
		if(flagMultiprogramming == 1) begin
			if(scheduler < quantum) scheduler = scheduler + 12'd1;
			else begin
				processPC = address;
				address = addrContextSwitch;
				scheduler = 12'd0;
				flagSO = 1;
			end
		end
		else begin
			scheduler = 12'd0;
		end
		
		if(flagMP == 1) begin
			if(data[0] == 1) flagMultiprogramming = 1;
			else flagMultiprogramming = 0;
		end
	end
	
	
	always@(*) begin
		delay_ext = {2'd0, delay};
	end
	
endmodule
