module RegisterFile (
	input clock,
	input reset,
	input flagRF, //Determina o funcionamento do banco de registradores
	//address RW --> Determina o endereço de acordo com o valor da variável em uma iteração (FOR).
	input [4:0] addrRW, //Endereço para escrita
	input [4:0] addrRD, //Endereço RD
	input [4:0] addrRS, //Endereço RS
	input [4:0] addrRT, //Endereço RT
	input [31:0] data,  //Dado de escrita
	output [31:0] readRW,  //Leitura RW --> Determina o valor da variável de iteração.
	output [31:0] readRD,  //Leitura RD
	output [31:0] readRS,  //Leitura RS
	output [31:0] readRT,  //Leitura RT
	output [31:0] regOUT   //Valor de saída
);

	integer initialize = 1; 
	
	reg [31:0] registers[31:0]; //Banco de Registradores
	
	assign readRW = registers[addrRW];
	assign readRD = registers[addrRD];
	assign readRS = registers[addrRS];
	assign readRT = registers[addrRT];
	assign regOUT = registers[6];
	
	always@ (posedge clock) begin
		if(initialize == 1) begin
			registers[0] = 32'd0;
			initialize = 0;
		end
		else if (flagRF == 1) begin //Escrever no registrador
			if(addrRW != 5'd0)
				registers[addrRW] = data;
		end
	end	
endmodule
