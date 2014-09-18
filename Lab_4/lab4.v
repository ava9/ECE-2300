module lab4(CLK50, RESET, CLK_SEL, NEXT, PLAYER_A, PLAYER_B, TEST_LOAD, SIGNAL, SCORE_A, SCORE_B, A_INC, B_INC, WINNER, STATE, FALSE_START, ADDRESS, DATA, CLK, LEDARRAYRED, LEDARRAYGREEN, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LOAD_MUX);
  input         CLK50;
  input         RESET;
  input  [2:0]  CLK_SEL;
  input         NEXT;
  input         PLAYER_A;
  input         PLAYER_B;
  input         TEST_LOAD;

  output        SIGNAL;
  output [3:0]  SCORE_A;
  output [3:0]  SCORE_B;
  output        A_INC;
  output        B_INC;
  output [3:0]  WINNER;
  output [3:0]  STATE;
  output        FALSE_START;
  output [2:0]  ADDRESS;
  output [9:0]  DATA;
  output        CLK;
  output [17:0] LEDARRAYRED;
  output [8:0]  LEDARRAYGREEN;
  output [6:0]  HEX7;
  output [6:0]  HEX6;
  output [6:0]  HEX5;
  output [6:0]  HEX4;
  output [6:0]  HEX3;
  output [6:0]  HEX2;
  output [6:0]  HEX1;
  output [6:0]  HEX0;
  output LOAD_MUX;



  
  reg           SIGNAL;
  reg    [3:0]  SCORE_A;
  reg    [3:0]  SCORE_B;
  reg    		 A_INC;
  reg           B_INC;
  reg    [3:0]  WINNER;
  reg    [3:0]  STATE;
  reg           FALSE_START;
  reg           LOAD_MUX;
 



  // ADD YOUR CODE BELOW THIS LINE
 
	wire DONE;
	reg LOAD;
	wire [9:0] data;
	assign data = (~LOAD_MUX) ? DATA : 10'b0000001001;

	
	always @ (posedge CLK) begin 
		if (RESET == 1'b1) begin
			SCORE_A <= 4'b0000; 
			SCORE_B <= 4'b0000;
		end
		else if (A_INC) begin
			SCORE_A <= SCORE_A + 4'b0001;
			SCORE_B <= 4'b0000;
		end
		else if (B_INC) begin
			SCORE_B <= SCORE_B + 4'b0001;
			SCORE_A <= 4'b0000;
		end
	end
	//assign SCORE_B = (B_INC) ? (SCORE_B + 4'b0001) : SCORE_B;	
	
  countdown counting(
	.RESET(RESET),
	.CLK(CLK),
	.LOAD(LOAD || LOAD_MUX),
	.DATA(data),
	.DONE(DONE)
  );
  
  prandom prand(
  .ADDRESS(ADDRESS),
  .DATA(DATA)
  );
  
  address_generator address_gen(
  .RESET(RESET),
  .CLK(CLK),
  .Address(ADDRESS)
  );
  
  reg [3:0] NEXTSTATE;
	
  //OUTPUT
  always @ (*) begin
		case (STATE) 
			4'b0000: begin LOAD <= 1'b1; SIGNAL <= 1'b0; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0001: begin LOAD <= 1'b0; SIGNAL <= 1'b0; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0010: begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0011: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b1; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0100: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b1; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0101: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b1; end
			4'b0110:	begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b0111: begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b1; B_INC <= 1'b0; FALSE_START <= 1'b1; LOAD_MUX <= 1'b0; end
			4'b1000: begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b1; FALSE_START <= 1'b1; LOAD_MUX <= 1'b0; end
			4'b1001: begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b1010; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b1010: begin LOAD <= 1'b0; SIGNAL <= 1'b1; WINNER <= 4'b1011; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b1011: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
			4'b1100: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b1010; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b1; LOAD_MUX <= 1'b0; end
			4'b1101: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b1011; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b1; LOAD_MUX <= 1'b0; end
			4'b1110: begin LOAD <= 1'b1; SIGNAL <= 1'b1; WINNER <= 4'b0000; A_INC <= 1'b0; B_INC <= 1'b0; FALSE_START <= 1'b1; LOAD_MUX <= 1'b0; end

			
			default : begin LOAD <= 1'b1; SIGNAL <= 1'b0; WINNER <= 4'b0000; A_INC <= 4'b0000; B_INC <= 4'b0000; FALSE_START <= 1'b0; LOAD_MUX <= 1'b0; end
		endcase
	end
	
	//NEXTSTATE
	always @ (*) begin
		case (STATE) 
			4'b0000 : begin 
					if ((~NEXT)) NEXTSTATE <= 4'b0001; 
					else NEXTSTATE <= 4'b0000; end
			4'b0001 : begin 
					if ((PLAYER_A) && (PLAYER_B) && (DONE)) NEXTSTATE <= 4'b0101;
					else if ((PLAYER_A) && (PLAYER_B) && (~DONE)) NEXTSTATE <= 4'b0001;
					else if ((PLAYER_A) && (~PLAYER_B)) NEXTSTATE <= 4'b0111;
					else if (~PLAYER_A) NEXTSTATE <= 4'b1000;
					else NEXTSTATE <= 4'b0001; end
			4'b0010: begin
					if ((PLAYER_A) && (PLAYER_B)) NEXTSTATE <= 4'b0010;
					else if ((PLAYER_A) && (~PLAYER_B)) NEXTSTATE <= 4'b0100;
					else if (~PLAYER_A) NEXTSTATE <= 4'b0011;
					else NEXTSTATE <= 4'b0010; end
			4'b0011: begin
					if (SCORE_A) NEXTSTATE <= 4'b1001;
					else if ((~SCORE_A) && (NEXT)) NEXTSTATE <= 4'b1011;
					else if ((~SCORE_A) && (~NEXT)) NEXTSTATE <= 4'b0001;
					end
			4'b0100: begin
					if (SCORE_B) NEXTSTATE <= 4'b1010;
					else if ((~SCORE_B) && (NEXT)) NEXTSTATE <= 4'b1011;
					else if ((~SCORE_B) && (~NEXT)) NEXTSTATE <= 4'b0001;
					end
			4'b0101: begin
					if ((PLAYER_A) && (PLAYER_B)) NEXTSTATE <= 4'b0110;
					else if ((PLAYER_A) && (~PLAYER_B)) NEXTSTATE <= 4'b0111;
					else if (~PLAYER_A) NEXTSTATE <= 4'b1000;
					end
			4'b0110: begin
					if ((PLAYER_A) && (PLAYER_B) && (DONE)) NEXTSTATE <= 4'b0010;
					else if ((PLAYER_A) && (PLAYER_B) && (~DONE)) NEXTSTATE <= 4'b0110;
					else if ((PLAYER_A) && (~PLAYER_B)) NEXTSTATE <= 4'b0111;
					else if (~PLAYER_A) NEXTSTATE <= 4'b1000;
					else NEXTSTATE <= 4'b0110; end
			4'b0111: begin
					if (SCORE_A) NEXTSTATE <= 4'b1100;
					else if ((~SCORE_A) && (NEXT)) NEXTSTATE <= 4'b1110;
					else if ((~SCORE_A) && (~NEXT)) NEXTSTATE <= 4'b0001;
					end
			4'b1000: begin
					if (SCORE_B) NEXTSTATE <= 4'b1101;
					else if ((~SCORE_B) && (NEXT)) NEXTSTATE <= 4'b1110;
					else if ((~SCORE_B) && (~NEXT)) NEXTSTATE <= 4'b0001;
					end
			4'b1001: NEXTSTATE <= 4'b1001;
			4'b1010: NEXTSTATE <= 4'b1010;
			4'b1011: begin
					if (~NEXT) NEXTSTATE <= 4'b0001;
					else NEXTSTATE <= 4'b1011; end
			4'b1100: NEXTSTATE <= 4'b1100;
			4'b1101: NEXTSTATE <= 4'b1101;
			4'b1110: begin
					if (~NEXT) NEXTSTATE <= 4'b0001;
					else NEXTSTATE <= 4'b1110; end
	
			default : NEXTSTATE <= 4'b0000;
		endcase 
	end
	
	//TRANSITION
	always @ (posedge CLK) begin
		if (RESET==1'b1) begin
			STATE <= 4'b0000;
			//SCORE_A <= 4'b0000;
			//SCORE_B <= 4'b0000; 
			end
		else begin
			STATE <= NEXTSTATE;
			//SCORE_A <= SCORE_A;
			//SCORE_B <= SCORE_B; 
			end
	end
  // ADD YOUR CODE ABOVE THIS LINE



  // VARIABLE CLOCK MODULE
  var_clk clockGenerator(
    .clock_50MHz(CLK50),
    .clock_sel(CLK_SEL),
    .var_clock(CLK)
  );
  
  // LED ARRAY BROADCASTER
  assign LEDARRAYRED = FALSE_START ? 18'h3FFFF : 18'b0;
  assign LEDARRAYGREEN = SIGNAL ? 9'h1FF : 9'b0;

  // SEVEN-SEGMENT DISPLAY DRIVERS

  // replace unused segments with code to disable display
  assign HEX7 = 7'b1111111;
  assign HEX5 = 7'b1111111;
  assign HEX2 = 7'b1111111;
  assign HEX1 = 7'b1111111;

  hex_to_seven_seg scoreADisplay(
    .B(SCORE_A),
    .SSEG_L(HEX6)
  );

  hex_to_seven_seg scoreBDisplay(
    .B(SCORE_B),
    .SSEG_L(HEX4)
  );

  hex_to_seven_seg winnerDisplay(
    .B(WINNER),
    .SSEG_L(HEX3)
  );

  hex_to_seven_seg stateDisplay(
    .B(STATE),
    .SSEG_L(HEX0)
  );

endmodule