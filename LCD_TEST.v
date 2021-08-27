module    LCD_TEST ( //Host Side
                    iCLK, iRST_N, iSAT, iTEMP, iOX,
                    //LCD Side
                    LCD_DATA, LCD_RW, LCD_EN, LCD_RS, LCD_N, LCD_P);
	//Host Side
	input  iCLK, iRST_N;
	input [7:0] iSAT, iTEMP, iOX;
	
	//LCD Side
	output [7:0] LCD_DATA;
	output LCD_RW, LCD_EN, LCD_RS, LCD_N, LCD_P;

	//Internal Wires/Registers
	reg [5:0]  LUT_INDEX;
	reg [8:0]  LUT_DATA;
	reg [5:0]  mLCD_ST;
	reg [17:0] mDLY;
	reg [7:0]  mLCD_DATA;
	reg        mLCD_Start;
	reg        mLCD_RS;
	wire       mLCD_Done;
	
	wire [3:0] SAT_1, SAT_2, SAT_3;
	wire [3:0] TEMP_1, TEMP_2, TEMP_3;
	wire [3:0] OX_1, OX_2, OX_3;
	
	parameter  LCD_INTIAL  = 0;
	parameter  LCD_LINE1   = 5;
	parameter  LCD_CH_LINE = LCD_LINE1 + 16;
	parameter  LCD_LINE2   = LCD_LINE1 + 16 + 1;
	parameter  LUT_SIZE    = LCD_LINE1 + 32 + 1;
	

	num_to_digit(iSAT, SAT_1, SAT_2, SAT_3);
	num_to_digit(iTEMP, TEMP_1, TEMP_2, TEMP_3);
	num_to_digit(iOX, OX_1, OX_2, OX_3);
	

	always@(posedge iCLK or negedge iRST_N) begin
		 
		 if(!iRST_N) begin
			  LUT_INDEX  <= 0;
			  mLCD_ST    <= 0;
			  mDLY       <= 0;
			  mLCD_Start <= 0;
			  mLCD_DATA  <= 0;
			  mLCD_RS    <= 0;
		 end
		 
		 else begin
		 
			  if(LUT_INDEX < LUT_SIZE) begin
			  
					case(mLCD_ST)
					
					0:  begin
					
							  mLCD_DATA  <= LUT_DATA[7:0];
							  mLCD_RS    <= LUT_DATA[8];
							  mLCD_Start <= 1;
							  mLCD_ST    <= 1;
							  
						 end
						 
					1:  begin
					
							  if(mLCD_Done) begin
							  
									mLCD_Start <= 0;
									mLCD_ST    <= 2; 
									
							  end
							  
						 end
						 
					2:  begin
					
							  if(mDLY<18'h3FFFE) mDLY <= mDLY+1;  // 5.2ms
							  else begin
							  
								  mDLY    <= 0;
								  mLCD_ST <= 3;
								  
							  end
							  
						 end
						 
					3:  begin
					
							  LUT_INDEX  <= LUT_INDEX+1;
							  mLCD_ST    <= 0;
						 end
						 
					endcase
					
			  end
			  
		 end
		 
	end

	always @(posedge iCLK) begin
	
		 case(LUT_INDEX)
		 
		 //Initial
		 LCD_INTIAL+0:    LUT_DATA    <=    9'h038; //Fun set
		 LCD_INTIAL+1:    LUT_DATA    <=    9'h00C; //dis on
		 LCD_INTIAL+2:    LUT_DATA    <=    9'h001; //clr dis
		 LCD_INTIAL+3:    LUT_DATA    <=    9'h006; //Ent mode
		 LCD_INTIAL+4:    LUT_DATA    <=    9'h080; //set ddram address
		 
		 //Line 1
		 LCD_LINE1+0:     LUT_DATA    <=    9'h100 + 9'h053; // S
		 LCD_LINE1+1:     LUT_DATA    <=    9'h100 + 9'h041; // A
		 LCD_LINE1+2:     LUT_DATA    <=    9'h100 + 9'h054; // T
		 LCD_LINE1+3:     LUT_DATA    <=    9'h100 + 9'h03A; // :
		 LCD_LINE1+4:     LUT_DATA    <=    9'h130 + SAT_1; // 
		 LCD_LINE1+5:     LUT_DATA    <=    9'h130 + SAT_2; //
		 LCD_LINE1+6:     LUT_DATA    <=    9'h130 + SAT_3; // 
		 LCD_LINE1+7:     LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE1+8:     LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE1+9:     LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE1+10:    LUT_DATA    <=    9'h100 + 9'h04F; // O
		 LCD_LINE1+11:    LUT_DATA    <=    9'h100 + 9'h058; // X
		 LCD_LINE1+12:    LUT_DATA    <=    9'h100 + 9'h03A; // :
		 LCD_LINE1+13:    LUT_DATA    <=    9'h130 + OX_1; // 
		 LCD_LINE1+14:    LUT_DATA    <=    9'h130 + OX_2; // 
		 LCD_LINE1+15:    LUT_DATA    <=    9'h130 + OX_3; // 
		 
		 //Change Line
		 LCD_CH_LINE:     LUT_DATA    <=    9'h0C0;
		 
		 //Line 2
		 LCD_LINE2+0:     LUT_DATA    <=    9'h100 + 9'h054; // T
		 LCD_LINE2+1:     LUT_DATA    <=    9'h100 + 9'h045; // E
		 LCD_LINE2+2:     LUT_DATA    <=    9'h100 + 9'h04D; // M
		 LCD_LINE2+3:     LUT_DATA    <=    9'h100 + 9'h050; // P
		 LCD_LINE2+4:     LUT_DATA    <=    9'h100 + 9'h03A; // :
		 LCD_LINE2+5:     LUT_DATA    <=    9'h130 + TEMP_1; // 
		 LCD_LINE2+6:     LUT_DATA    <=    9'h130 + TEMP_2; // 
		 LCD_LINE2+7:     LUT_DATA    <=    9'h130 + TEMP_3; //
		 LCD_LINE2+8:     LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+9:     LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+10:    LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+11:    LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+12:    LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+13:    LUT_DATA    <=    9'h100 + 9'h020; // 
		 LCD_LINE2+14:    LUT_DATA    <=    9'h100 + 9'h020; //
		 LCD_LINE2+15:    LUT_DATA    <=    9'h100 + 9'h020; //
		 default:         LUT_DATA    <=    9'h000;
		 
		 endcase
	
	end

	LCD_Controller u0 ( //Host Side
							 .iDATA(mLCD_DATA),
							 .iRS(mLCD_RS),
							 .iStart(mLCD_Start),
							 .oDone(mLCD_Done),
							 .iCLK(iCLK),
							 .iRST_N(iRST_N),
							 //LCD Interface
							 .LCD_DATA(LCD_DATA),
							 .LCD_RW(LCD_RW),
							 .LCD_EN(LCD_EN),
							 .LCD_RS(LCD_RS),
							 .LCD_N(LCD_N),                            
							 .LCD_P(LCD_P));

endmodule
