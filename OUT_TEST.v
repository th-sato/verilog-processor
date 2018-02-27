module OUT_TEST (
	input [15:0] Value,
	output [6:0] OUT_Th,
	output [6:0] OUT_H,
	output [6:0] OUT_T,
	output [6:0] OUT_O
);
	wire [3:0] Th, H, T, O;
	
	BinaryCodedDecimal b2 (
		.binary(Value),
		.thousand(Th),
		.hundred(H),
		.ten(T),
		.one(O)
	);
	
	Display7 dTh2 (.Q(Th), .OUT(OUT_Th)); //Milhar
	Display7 dH2 (.Q(H), .OUT(OUT_H)); //Centena
	Display7 dT2 (.Q(T), .OUT(OUT_T)); //Dezena
	Display7 dO2 (.Q(O), .OUT(OUT_O)); //Unidade
	
	
endmodule
