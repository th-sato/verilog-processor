module Datapath (reset, clock, State, opcode, flagRF, flagALU, flagPC, flagDM, flagJAL, flagMUXRD, flagJR, flagLI, flagBRANCH, flagRR, IN, OUT);
	//Memory: Quantidade de bits para endereçamento da memória
	//opFunc: Quantidade de bits para os campos: opcode e function
	parameter flag = 2, memory = 10, bits = 32, opFunc = 6, registers = 5, addr = 20, st = 3;
	
	input clock, reset, flagJR, flagJAL, flagLI, flagRR;
	input [flag-1:0] flagRF, flagALU, flagPC, flagDM, flagMUXRD;
	input [st-1:0] State;
	input [bits-1:0] IN;
	
	reg [registers-1:0] RD, RS, RT, shamt;
	reg [addr-1:0] newAddress;
	reg [bits-1:0] immediate, RD_LI;
	reg [9:0] extender;
	reg [20:0] extender2;

	wire [bits-1:0] instruction;
	wire [bits-1:0] RDvalue, RSvalue, RTvalue;
	wire [addr-1:0] addressJAL;
	wire [opFunc-1:0] funct;
	
	output [opFunc-1:0] opcode;
	output flagBRANCH;
	output [bits-1:0] OUT;
	
		
	FetchState F1 (.reset(reset), .clock(clock), .flagPC(flagPC), .flagJR(flagJR), .newAddress(newAddress), .RSvalue(RSvalue), .instruction(instruction), .address(addressJAL));
	RegisterFile R1 (.clock(clock), .reset(reset), .flagRF(flagRF), .addressW(RD), .addressR1(RS), .addressR2(RT), .data(RDvalue), .read1(RSvalue), .read2(RTvalue));
	MUXADDR MUX1 (.reset(reset), .clock(clock), .IN(IN), .State(State), .flagALU(flagALU), .flagMUXRD(flagMUXRD), .flagDM(flagDM), .flagJAL(flagJAL), .flagLI(flagLI), .opcode(opcode), .funct(funct), .shamt(shamt), .immediate(immediate), .newAddress(newAddress), .addressJAL(addressJAL), .RSvalue(RSvalue), .RTvalue(RTvalue), .RDvalue(RDvalue), .RD_LI(RD_LI), .flagRR(flagRR), .flagBRANCH(flagBRANCH));
	
	assign opcode = instruction [31:26];
	assign funct = instruction [5:0];
	assign OUT = RSvalue;
	
	always@ (opcode) begin
		case (opcode)
			0: begin //Operações lógicas e aritméticas
				RD = instruction [25:21];
				RS = instruction [20:16];
				RT = instruction [15:11];
				extender = instruction [15:6];
				if (extender[9] == 1) immediate = {20'hfffff, 2'b11, extender};
				else immediate = {22'd0, extender};
			end
			1: begin //LW
				RD = instruction [25:21];
				newAddress = instruction [19:0];
			end
			2: begin //LOADI
				RD = instruction [25:21];
				extender2 = instruction[20:0];
				if(extender2[20] == 1) RD_LI = {11'b11111111111, extender2};
				else RD_LI = {11'd0, extender2};
			end
			3: begin //SW
				RS = instruction [25:21];
				newAddress = instruction [19:0];
			end
			4: begin //SRL
				RD = instruction [25:21];
				RS = instruction [20:16];
				shamt = instruction [10:6];
			end
			5: begin //SLL
				RD = instruction [25:21];
				RS = instruction [20:16];
				shamt = instruction [10:6];
			end
			6: begin //BEQ
				RS = instruction [25:21];
				RT = instruction [20:16];
				newAddress = {4'd0, instruction [15:0]};
			end
			7: begin //BNQ
				RS = instruction [25:21];
				RT = instruction [20:16];
				newAddress = {4'd0, instruction [15:0]};
			end
			8: begin //JUMP
				newAddress = instruction [addr-1:0];
			end
			9: begin //JUMP REGISTER
				RS = instruction [25:21];
			end
			10: begin //JUMP AND LINK: subrotinas
				RD = instruction [25:21]; //Guardará o endereço da próxima instrução
				newAddress = instruction [addr-1:0]; //Possui o novo endereço
			end
			11: begin //NOP
				//Faz nada
			end
			12: begin //HLT
				RS = instruction [25:21];
				//Parar processamento
				//Mantém o valor do PC, porém, desativa FLAGs.
			end
			13: begin //MOVE
				RS = instruction [25:21];
				RT = instruction [20:16];
				//Transferência de dados entre registradores, implementado no banco de registradores
			end
			14: begin //IN
				RD = instruction [25:21];
			end
			15: begin //OUT
				RS = instruction [25:21];
			end
			16: begin //LOADR
				RD = instruction [25:21];
				RT = instruction [20:16];
			end
			17: begin //STORER
				RS = instruction [25:21];
				RT = instruction [20:16];
			end
			default: begin
				RD = 5'bxxxxx;
				RS = 5'bxxxxx;
				RT = 5'bxxxxx;
				shamt = 5'dxxxxx;
				immediate = 32'dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
				newAddress = 32'dxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
		endcase
	end
endmodule
