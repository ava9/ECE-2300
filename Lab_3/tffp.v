module tffp(CLK, RESET, T, Q);
	input CLK;		// The clock signal
	input RESET;	// Synchronous reset signal (sets Q = 0)
	input T;			// Signals whether the output should be toggled
	
	output Q;
	reg Q;
	
	always @(posedge CLK) begin
		Q <= RESET ? 1'b0 : (T ? ~Q : Q);
		// If RESET == 1, Q <= 0
		// otherwise, if T == 1, flip Q, otherwise do nothing
	end
endmodule