module shifter(
		input [7:0] A,
		
		input LA,
		// Left is 0, right is 1
		input LR,
		
		output reg [7:0] Y,
		
		output C,
		output V,
		output N,
		output Z); // add all inputs and outputs inside parentheses
  
	// reg and internal variable definitions
	
	// implement module here
	assign V = 1'b0;
	assign C = (LR == 1'b0) ? A[7] : A[0];
	assign N = Y[7] == 1'b1 ? 1'b1 : 1'b0;
	assign Z = Y == 8'b00000000 ? 1'b1 : 1'b0;
	
	always @(*) begin
		// Left shift
		if (LR == 1'b0) begin
			Y[7:1] <= A[6:0];
			Y[0] <= 1'b0;
		end else begin
			// Logical right
			if (LA == 1'b0) begin
				Y[6:0] <= A[7:1];
				Y[7] <= 1'b0;
			end else begin
				Y[6:0] <= A[7:1];
				Y[7] <= A[7];
			end
		end
	end
  
  

  
endmodule