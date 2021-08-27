module Satempox_prototype(CLOCK_50, reset, rx, led, delay, capture, LCD_DATA, LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_N, LCD_P);
	
	input CLOCK_50;       //50 MHz
	
	// VARIABLES MÓDULO BLUETOOTH
    
	input reset;	
	input rx;      
	output [7:0] led;  
	output delay; 
	output capture;
	
	// VARIABLES MÓDULO LCD
	reg [7:0] SAT = 'b 0000_0000;
	reg [7:0] OX = 'b 0000_0000;
	reg [7:0] TEMP = 'b 0000_0000;
	output [7:0] LCD_DATA; 
	output LCD_ON;        
	output LCD_BLON;      
	output LCD_RW;        
	output LCD_EN;        
	output LCD_RS;        
	output LCD_N;        
	output LCD_P;        
	
	// VARIABLES DIVISOR DE FRECUENCIA
	reg [26:0] frecuencia = 'd 1000;
	wire CLOCK_Frec;
	
	always @ (posedge CLOCK_Frec) begin
	
		SAT  = 'd 35;
		OX   = 'd 62;
		TEMP = 'd 97;

	end
	
	Divisor_de_frecuencia(CLOCK_50, frecuencia, CLOCK_Frec);
	
	bluetooth(CLOCK_50, reset, rx, led, delay, capture);
	
	LCD_top(CLOCK_50, SAT, OX, TEMP, LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA, LCD_N, LCD_P);
               

endmodule
