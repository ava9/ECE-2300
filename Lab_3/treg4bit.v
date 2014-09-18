module treg4bit(CLK, RESET, IN, OUT);
	input 			CLK;	// The clock signal
	input 			RESET;// The reset signal
	input 	[3:0] IN;	// The inputs for the flip-flops, connects to T
	
	output	[3:0] OUT;	// The outputs from the flip-flops, connects to Q
	
	tffp reg0 (.CLK(CLK), .RESET(RESET), .T(IN[0]), .Q(OUT[0]));
	tffp reg1 (.CLK(CLK), .RESET(RESET), .T(IN[1]), .Q(OUT[1]));
	tffp reg2 (.CLK(CLK), .RESET(RESET), .T(IN[2]), .Q(OUT[2]));
	tffp reg3 (.CLK(CLK), .RESET(RESET), .T(IN[3]), .Q(OUT[3]));
	
	
	
endmodule