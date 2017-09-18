module OUT (
	input flagOUT,
	input [31:0] Value,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O,
	output [6:0] OUT_N
);
	wire [3:0] H, T, O;
	wire [9:0] Value_B;
	reg [3:0] HD, TD, OD, N;
	
	assign Value_B = Value[9:0];
	
	BinaryCodedDecimal b1 (.binary(Value_B), .hundred(H), .ten(T), .one(O));
	Display7 dN (.Q(N), .OUT(OUT_N)); //Sinal negativo
	Display7 dH (.Q(HD), .OUT(OUT_H)); //Centena
	Display7 dT (.Q(TD), .OUT(OUT_T)); //Dezena
	Display7 dO (.Q(OD), .OUT(OUT_O)); //Unidade
	
	always@ (*) begin
		if (flagOUT == 0) begin //Display desligado
			N = 4'd10;
			HD = 4'd10;
			TD = 4'd10;
			OD = 4'd10;
		end
		else begin
			if (Value[9] == 1) N = 4'd11; //Negativo
			else N = 4'd10;
			HD = H;
			TD = T;
			OD = O;
		end
	end
	
endmodule
