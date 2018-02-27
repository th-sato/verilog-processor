module OUT_LCD (
	input clock, //Clock
	input CLOCK_50, //50 MHz clock
	input notExecuteBIOS, //Execução do SO e de processos
	input flagNumProg, //Alterar o valor do programa no LCD
	input [15:0] process, //Numero do processo
	input [15:0] value, //Output
	// LCD Module 16X2
	output LCD_ON, // LCD Power ON/OFF
	output LCD_BLON, // LCD Back Light ON/OFF
	output LCD_RW, // LCD Read/Write Select, 0 = Write, 1 = Read
	output LCD_EN, // LCD Enable
	output LCD_RS, // LCD Command/Data Select, 0 = Command, 1 = Data
	inout [7:0] LCD_DATA // LCD Data bus 8 bits
);
	localparam [15:0] OK = 16'd65535, ERROR = 16'd65534, OPTION = 16'd65533,
							CS = 16'd65532, EXECUTE = 16'd65531, EXECUTE_N = 16'd65530,
							RENAME = 16'd65529, CREATE = 16'd65528, DELETE = 16'd65527,
							SHOW = 16'd65526, OTHER_NAME = 16'd65525, NOT_FOUND = 16'd65524;
	
	wire [6:0] myclock;
	// reset delay gives some time for peripherals to initialize
	wire DLY_RST;
	Reset_Delay r0(.iCLK(CLOCK_50), .oRESET(DLY_RST));

	// turn LCD ON
	assign LCD_ON   = 1'b1;
	assign LCD_BLON = 1'b1;
	
	wire [3:0] hex3, hex2, hex1, hex0;
	wire [3:0] prog3, prog2, prog1, prog0;
	reg [15:0] proc;
	reg [255:0] dataLCD;
	
	LCD_Display u1(
		// Host Side
		.iCLK_50MHZ(CLOCK_50),
		.iRST_N(DLY_RST),
		.dataLCD(dataLCD),
		// LCD Side
		.DATA_BUS(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_E(LCD_EN),
		.LCD_RS(LCD_RS)
	);
	
	BinaryCodedDecimal b3 (
		.binary(value),
		.thousand(hex3),
		.hundred(hex2),
		.ten(hex1),
		.one(hex0)
	);
	
	BinaryCodedDecimal b4 (
		.binary(proc),
		.thousand(prog3),
		.hundred(prog2),
		.ten(prog1),
		.one(prog0)
	);
	
	always@(posedge clock)begin
		if(flagNumProg == 1) 
			proc = process;
	end
	
	always@(*) begin
		if(notExecuteBIOS == 0) begin //BIOS
			case(value)
				OK: dataLCD =
						{ // Linha 1: "BIOS"
							8'h42, 8'h49, 8'h4F, 8'h53, {12{8'h20}},
							//Linha 2: "Output: OK"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h4F, 8'h4B, {6{8'h20}}
						};
				ERROR: dataLCD =
						{ // Linha 1: "BIOS"
							8'h42, 8'h49, 8'h4F, 8'h53, {12{8'h20}},
							//Linha 2: "Output: ERROR"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h45, 8'h52, 8'h52, 8'h4F, 8'h52, {3{8'h20}}
						};
				default: dataLCD =
						{ // Linha 1: "BIOS"
							8'h42, 8'h49, 8'h4F, 8'h53, {12{8'h20}},
							//Linha 2: "Output: valor" (Valor com quatro dígitos)
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							{4'h0, hex3}, {4'h0, hex2}, {4'h0, hex1}, {4'h0, hex0}, {4{8'h20}}
						};
			endcase
		end
		else if(proc == 16'd0) begin //SO
			case(value)
				OK: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: OK"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h4F, 8'h4B, {6{8'h20}}
						}; 
				ERROR: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: ERROR"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h45, 8'h52, 8'h52, 8'h4F, 8'h52, {3{8'h20}}
						}; 
				OPTION: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: OPTION"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h4F, 8'h50, 8'h54, 8'h49, 8'h4F, 8'h4E, {2{8'h20}}
						}; 
				CS: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: CS"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h43, 8'h53,  {6{8'h20}}
						}; 
				EXECUTE: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: EXEC"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h45, 8'h58, 8'h45, 8'h43, {4{8'h20}}
						}; 
				EXECUTE_N: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: EXEC_N"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h45, 8'h58, 8'h45, 8'h43, 8'h5F, 8'h4E, {2{8'h20}}
						};
				RENAME: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: RENAME"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h52, 8'h45, 8'h4E, 8'h41, 8'h4D, 8'h45, {2{8'h20}}
						};
				CREATE: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: CREATE"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h43, 8'h52, 8'h45, 8'h41, 8'h54, 8'h45, {2{8'h20}}
						};
				DELETE: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: DELETE"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h44, 8'h45, 8'h4C, 8'h45, 8'h54, 8'h45, {2{8'h20}}
						};
				SHOW: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: SHOW"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h53, 8'h48, 8'h4F, 8'h57, {4{8'h20}}
						};
				OTHER_NAME: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: OtherNam"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h4F, 8'h74, 8'h68, 8'h65, 8'h72, 8'h4E, 8'h61, 8'h6D
						};
				NOT_FOUND: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: NotFound"
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							8'h4E, 8'h6F, 8'h74, 8'h46, 8'h6F, 8'h75, 8'h6E, 8'h64
						};
				default: dataLCD =
						{ // Linha 1: SO
							8'h53, 8'h4F, {14{8'h20}},
							//Linha 2: "Output: valor" (Valor com quatro dígitos)
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							{4'h0, hex3}, {4'h0, hex2}, {4'h0, hex1}, {4'h0, hex0}, {4{8'h20}}
						}; 
				
			endcase
			
		end
		else //Processo --> Alterar para programa no LCD
			dataLCD = { // Linha 1: "Process: P00" (Valor com dois dígitos)
							8'h50, 8'h72, 8'h6F, 8'h63, 8'h65, 8'h73, 8'h73, 8'h3A, 8'h20,
							8'h50, {4'h0, prog1}, {4'h0, prog0}, {4{8'h20}},
							//Linha 2: "Output: valor" (Valor com quatro dígitos)
							8'h4F, 8'h75, 8'h74, 8'h70, 8'h75, 8'h74, 8'h3A, 8'h20,
							{4'h0, hex3}, {4'h0, hex2}, {4'h0, hex1}, {4'h0, hex0}, {4{8'h20}}
						 };
	end
	

endmodule
