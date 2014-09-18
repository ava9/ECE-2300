module address_generator(RESET, CLK, Address);
	input RESET;
	input CLK;

	output [2:0] Address;
	
	reg [2:0] Address;
	always @(posedge CLK) begin
		if(RESET) begin
			Address<=3'b0;
		end
		else begin
			Address<= Address + 3'b1;
		end	
	end

endmodule
