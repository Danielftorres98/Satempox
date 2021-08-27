
//Módulo bluetooth HC06 como receptor conectado a la FPGA usando protocolo RS-232. 

module bluetooth(CLOCK_50, reset, rx, led, delay, capture); 
	
	input CLOCK_50; // Clock 50MHz
	input reset;    // Pulsador de reinicio
	input rx;       // Entrada de datos del modulo bluetooth (a DO)
	
	output reg[7:0] led;  // Salida Led por cada Bit recibido
	output reg delay = 0; // Retardo ajustado a la velocidad del módulo Bluetooth
	
	// Estados FSM ----------------------------------------------------------------------
	reg [1:0] presentstate, nextstate;

	// Señales --------------------------------------------------------------------------
	reg control  = 0;              // Indica cuando ocurre el bit de start
	reg done     = 0;              // bandera que indica que termino de recibir los datos
	reg[8:0] tmp = 9'b111_111_111; // registro que recibe los datos enviados
	
	// Contadores -----------------------------------------------------------------------
	reg[3:0]i = 4'b0000; 			 		  // Contador de los bits recibidos
	reg[12:0]c  = 13'b1_111_111_111_111;  // Contador para la definición de delay
	reg[1:0] c2 = 2'b11;						  // Contador para la definición de capture
	
	// Algoritmo para los retardos ------------------------------------------------------
	output reg capture = 0;
	
	parameter EDO_1 = 2'b00;
	parameter EDO_2 = 2'b10;

	//	PROCESO DE RETARDO: --------------------------------------------------------------

	//	868*20ns = 17.36us = 1/57637 Hz  
	//	17.36us*3 = 58.08us
	//	58.08us*2 = 104.16us = 1/9600 baudios o bits/seg
	
	
	always@(posedge CLOCK_50) begin
	
		if(c < 217) c = c + 1;  // 868/4 = 217
	
		else begin
		
			c = 0;
			delay <= ~delay;
			
		end

	end
	

	//	PROCESO DE DEFINICIÓN DEL CONTADOR C2 (VARIABLE DE CONTROL PARA LA CAPTURA) ------
	
	always@(posedge delay) begin

		if (c2 > 1) c2 <= 2'b00;
		else c2 <= c2 + 2'b01;

	end


	//	PROCESO DE DEFINICIÓN DE LA CAPTURA ----------------------------------------------
	
	always@(c2) begin
		
		if (c2 == 1) capture = 1;
		else capture = 0;

	end


	//	FSM - CONDICIÓN DE REINICIO ------------------------------------------------------
	
	always@(posedge capture, negedge reset) begin

		if (reset == 0) presentstate <= EDO_1;
		else presentstate <= nextstate;

	end


	//	DEFINICIÓN FSM -------------------------------------------------------------------
	
	always@(*) begin

		case(presentstate)
		
		EDO_1:
			
			if(rx == 1 && done == 0) begin
				control = 0;
				nextstate = EDO_1;
			end
			
			else if(rx == 0 && done == 0) begin
				control = 1;
				nextstate = EDO_2;
			end
			
			else begin
				control = 0;
				nextstate = EDO_1;
			end
		
		EDO_2:

			if(done == 0) begin
				control = 1;
				nextstate = EDO_2;
			end
			
			else begin
				control = 0;
				nextstate = EDO_1;
			end
		
		default
			nextstate = EDO_1;

		endcase
	end


	//	PROCESO DE RECEPCIÓN DE DATOS ------------------------------------------------------
	
	always@(posedge capture) begin
		
		if (control == 1 && done == 0) tmp <= {rx, tmp[8:1]};

	end

	//	PROCESO DE CONTEO DE BITS (9 BITS) -------------------------------------------------
	
	always@(posedge capture) begin
		
		if (control)
		
			if(i >= 9) begin
			
				i = 0;
				done = 1;
				led <= tmp[8:1];		
				
			end
			else begin
			
				i = i+1;
				done = 0;
				
			end
			
		else done = 0;

	end

endmodule
