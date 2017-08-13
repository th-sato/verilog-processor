module RegisterFile (clock, reset, flagRF, addressW, addressR1, addressR2, data, read1, read2);
	integer i;
	//32 registradores (5 bits para mapear) de 32 bits
	parameter bits = 32, bitsR = 5, flag = 2;
	input reset, clock;
	//Banco de Registradores
	reg [bits-1:0] registers[bits-1:0];
	//Endereços de leitura e de escrita
	input [bitsR-1:0] addressR1, addressR2, addressW;
	//Dado de escrita
	input [bits-1:0] data;
	//Determina o funcionamento do banco de registradores
	input [flag-1:0] flagRF;
	//Valores lidos
	output [bits-1:0] read1, read2;
	
	assign read1 = registers[addressR1];
	assign read2 = registers[addressR2];
	
	always@ (posedge clock) begin
		if(reset) begin
			for (i=31; i>=0; i=i-1) begin
				registers[i] = 32'd0;
			end
		end
		else if (flagRF == 1)//Escrever no registrador
			registers[addressW] = data;
		else if (flagRF == 2) begin //Transferencia de dados entre registradores
			registers[addressR1] <= registers[addressR2];
			registers[addressR2] <= registers[addressR1];
		end
	end	
endmodule
