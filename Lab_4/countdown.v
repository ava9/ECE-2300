module countdown(RESET, CLK, LOAD, DATA, DONE);
input RESET;
input CLK;
input LOAD;
input [9:0] DATA;

output DONE;

reg [9:0] COUNT;
reg [3:0] TEN;

always @(posedge CLK) begin
	if(RESET) begin
		COUNT <= 10'b0;
		TEN <= 4'b0;
	end
	else if(LOAD) begin
		COUNT <= DATA;
	end
	else begin
		COUNT <= COUNT - 10'b0000000001;
		TEN <= TEN + 4'b0001;
	end
end
	assign DONE = (LOAD == 1'b0) ? ((COUNT <= 10'b0) ? 1'b1: 1'b0) : ((TEN >= 4'b1001) ? 1'b1 : 1'b0);
	//assign DONE = (COUNT <= 10'b0) ? 1'b1: 1'b0;
	//assign TENCYC = (TEN >= 4'b1010) ? 1'b1 : 1'b0;
endmodule
