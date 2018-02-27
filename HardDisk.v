module HardDisk(
	input clock, //Clock para escrita
	input clock50, //Clock para leitura
	input flagHD, //Flag para escrita no HD
	input [3:0] sector, //Identificar o setor
	input [9:0] track, //Identificar a trilha
	input [31:0] dataW, //Dado para escrita
	output [31:0] dataR //Enviar dado
); //(Sector, track) --> Max: 250 instructions= 250 * 32 bits = 8000 bits

	wire [13:0] addr;
	
	assign addr = {sector, track};

	Memory_HD MHD(
		.data(dataW),
		.read_addr(addr),
		.write_addr(addr),
		.we(flagHD),
		.read_clock(clock50),
		.write_clock(clock),
		.q(dataR)
	);
	
endmodule
