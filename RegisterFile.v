module RegisterFile (
	input clock,
	input reset,
	input flagRF, //Determina o funcionamento do banco de registradores
	input [4:0] addressWrite,
	input [4:0] addressRD,
	input [4:0] addressRS,
	input [4:0] addressRT,
	input [31:0] data, //Dado de escrita
	output [31:0] readW,
	output [31:0] readRD, //Valores lidos
	output [31:0] readRS,
	output [31:0] readRT
);

	integer initialize = 1;
	
	reg [31:0] registers[31:0]; //Banco de Registradores
	
	assign readW = registers[addressWrite];
	assign readRD = registers[addressRD];
	assign readRS = registers[addressRS];
	assign readRT = registers[addressRT];
	
	always@ (posedge clock) begin
		if(initialize == 1) begin
			registers[0] = 32'd0;
			initialize = 0;
		end
		else if (flagRF == 1) begin //Escrever no registrador
			if(addressWrite != 5'd0)
				registers[addressWrite] = data;
		end
	end	
endmodule
