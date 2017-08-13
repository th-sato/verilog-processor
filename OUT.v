module OUT (flagOUT, Value, OUT_H, OUT_T, OUT_O, OUT_N);
	parameter bits = 32, bits2 = 10, number = 4, number2 = 7;
	input flagOUT;
	input [bits-1:0] Value;
	output [number2-1:0] OUT_H, OUT_T, OUT_O, OUT_N;
	
	wire [number-1:0] H, T, O;
	wire [bits2-1:0] Value_B;
	reg [number-1:0] HD, TD, OD, N;
	
	assign Value_B = Value[bits2-1:0];
	
	BinaryCodedDecimal b1 (.binary(Value_B), .hundred(H), .ten(T), .one(O));
	Display7 dN (.Q(N), .OUT(OUT_N)); //Sinal negativo
	Display7 dH (.Q(HD), .OUT(OUT_H)); //Centena
	Display7 dT (.Q(TD), .OUT(OUT_T)); //Dezena
	Display7 dO (.Q(OD), .OUT(OUT_O)); //Unidade
	
	always@ (flagOUT) begin
		if (flagOUT == 0) begin //Display desligado
			N = 4'd10;
			HD = 4'd10;
			TD = 4'd10;
			OD = 4'd10;
		end
		else begin
			if (Value[bits2-1] == 1) N = 4'd11; //Negativo
			else N = 4'd10;
			HD = H;
			TD = T;
			OD = O;
		end
	end
	
endmodule
