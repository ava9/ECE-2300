module tcounter(CLK, CLR, ENP, ENT, Q);
	input CLK;
	input CLR;
	input ENP;
	input ENT;
	
	output [3:0] Q;
	
	wire ENABLE = ENP & ENT;
	
	wire [3:0] T;
	assign T[0] = ENABLE;
	assign T[1] = ENABLE & Q[0];
	assign T[2] = ENABLE & Q[0] & Q[1];
	assign T[3] = ENABLE & Q[0] & Q[1] & Q[2];
	
	treg4bit counter(.CLK(CLK), .RESET(~CLR), .IN(T), .OUT(Q));
endmodule