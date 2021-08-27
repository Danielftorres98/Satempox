module num_to_digit(numero, D1, D2, D3);
	
	input [7:0] numero;
	output [3:0] D1, D2, D3;
	
	assign D1 = numero / 'd100; 
	assign D2 = (numero - D1*'d100) / 'd10;
	assign D3 = (numero - D1*'d100 - D2*'d10);

endmodule

