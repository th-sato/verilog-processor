module OUT (
	input flagOUT,
	input [31:0] Value,
	output [6:0] OUT_Th,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O
);
	wire [3:0] Th, H, T, O;
	wire [15:0] Value_B;
	reg [3:0] ThD, HD, TD, OD;
	
	assign Value_B = Value[15:0];
	
	BinaryCodedDecimal b1 (.binary(Value_B), .thousand(Th), .hundred(H), .ten(T), .one(O));
	Display7 dTh (.Q(ThD), .OUT(OUT_Th)); //Sinal negativo
	Display7 dH (.Q(HD), .OUT(OUT_H)); //Centena
	Display7 dT (.Q(TD), .OUT(OUT_T)); //Dezena
	Display7 dO (.Q(OD), .OUT(OUT_O)); //Unidade
	
	always@ (*) begin
		if (flagOUT == 0) begin //Display desligado
			ThD = 4'd10;
			HD = 4'd10;
			TD = 4'd10;
			OD = 4'd10;
		end
		else begin
			ThD = Th;
			HD = H;
			TD = T;
			OD = O;
		end
	end
	
endmodule
