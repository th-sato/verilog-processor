module HardDisk(
	input clock,
	input clock50,
	input flagHD,
	input [3:0] sector, //Identificar o setor
	input [9:0] track, //Identificar a trilha
	input [31:0] data,
	output [31:0] dataOut //Enviar instrucao
); //(Sector, track) --> Max: 250 instructions= 250 * 32 bits = 8000 bits

	wire [13:0] addr;
	
	assign addr = {sector, track};

	Memory_HD MHD(
		.data(data),
		.read_addr(addr),
		.write_addr(addr),
		.we(flagHD),
		.read_clock(clock50),
		.write_clock(clock),
		.q(dataOut)
	);
	
endmodule
