
module LCD_top(
                CLOCK_50,  //50 MZ
					  SAT,      //Valor de Saturación
					  OX,       //Valor de Oxigencaión
					  TEMP,     //Valor de Temperatura
                 LCD_ON,   //LCD Power ON/OFF
                 LCD_BLON, //LCD Back Light ON/OFF
                 LCD_RW,   //LCD Read/Write Select, 0 = Write, 1 = Read
                 LCD_EN,   //LCD Enable
                 LCD_RS,   //LCD Command/Data Select, 0 = Command, 1 = Data
                 LCD_DATA, //LCD Data bus 8 bits
                 LCD_N,    //Negativo Diodo Back Light
                 LCD_P     //Positivo Diodo Back Light
               );
               
input CLOCK_50;       //50 MHz
input [7:0] SAT;      //Valor de Saturación
input [7:0] TEMP;     //Valor de Temperatura
input [7:0] OX;       //Valor de Oxigencaión
inout [7:0] LCD_DATA; //LCD Data bus 8 bits

output LCD_ON;        //LCD Power ON/OFF
output LCD_BLON;      //LCD Back Light ON/OFF
output LCD_RW;        //LCD Read/Write Select, 0 = Write, 1 = Read
output LCD_EN;        //LCD Enable
output LCD_RS;        //LCD Command/Data Select, 0 = Command, 1 = Data
output LCD_N;         //Negativo Diodo Back Light
output LCD_P;         //Positivo Diodo Back Light

//LCD ON
assign LCD_ON =   1'b1;
assign LCD_BLON = 1'b1;
//Back Light ON

wire DLY_RST;

Reset_Delay r0 ( .iCLK(CLOCK_50), .oRESET(DLY_RST)  );

LCD_TEST u5 (//Host Side
             .iCLK(CLOCK_50),
				 .iSAT(SAT),
				 .iTEMP(TEMP),
				 .iOX(OX),
             .iRST_N(DLY_RST),
             //    LCD Side
             .LCD_DATA(LCD_DATA),
             .LCD_RW(LCD_RW),
             .LCD_EN(LCD_EN),
             .LCD_RS(LCD_RS),   
				 .LCD_N(LCD_N),                            
				 .LCD_P(LCD_P)
             );

endmodule
