module lab3(CLK50, RESET, CLK_SEL, ENABLE, TIME, CLK, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
  input         CLK50;
  input         RESET;
  input  [2:0]  CLK_SEL;
  input         ENABLE;

  output [19:0] TIME;
  output        CLK;
  output [6:0]  HEX7;
  output [6:0]  HEX6;
  output [6:0]  HEX5;
  output [6:0]  HEX4;
  output [6:0]  HEX3;
  output [6:0]  HEX2;
  output [6:0]  HEX1;
  output [6:0]  HEX0;

  wire   [3:0]  MIN;
  wire   [3:0]  TENSEC;
  wire   [3:0]  SEC;
  wire   [3:0]  DECISEC;
  wire   [3:0]  CENTISEC;
  
  wire h0Nine;
  wire h1Nine;
  wire S0Nine;
  wire S1Five;
  wire  MNine;


  // ADD YOUR CODE BELOW THIS LINE
  assign h0Nine = CENTISEC[3] && CENTISEC[0];
  assign h1Nine = DECISEC[3] && DECISEC[0];
  assign S0Nine = SEC[3] && SEC[0];
  assign S1Five = TENSEC[2] && TENSEC[0];
  assign  MNine = MIN[3] && MIN[0];
  
	tcounter h0(
		.CLR(~(RESET || h0Nine)),
		.ENP(ENABLE),
		.ENT(1'b1),
		.CLK(CLK),
		.Q(CENTISEC));
   tcounter h1(
		.CLR(~(RESET || (h0Nine && h1Nine))),
		.ENP(ENABLE),
		.ENT(h0Nine),
		.CLK(CLK),
		.Q(DECISEC));
   tcounter S0(
		.CLR(~(RESET || (h0Nine && h1Nine && S0Nine))),
		.ENP(ENABLE),
		.ENT(h0Nine && h1Nine),
		.CLK(CLK),
		.Q(SEC));
   tcounter S1(
		.CLR(~(RESET || (h0Nine && h1Nine && S0Nine && S1Five))),
		.ENP(ENABLE),
		.ENT(S0Nine && h1Nine && h0Nine),
		.CLK(CLK),
		.Q(TENSEC));
   tcounter  M(
		.CLR(~(RESET || (h0Nine && h1Nine && S0Nine && S1Five && MNine))),
		.ENP(ENABLE),
		.ENT(S1Five && S0Nine && h1Nine && h0Nine),
		.CLK(CLK),
		.Q(MIN));

  // ADD YOUR CODE ABOVE THIS LINE



  // VARIABLE CLOCK MODULE
  var_clk clockGenerator(
    .clock_50MHz(CLK50),
    .clock_sel(CLK_SEL),
    .var_clock(CLK)
  );

  assign TIME = {MIN, TENSEC, SEC, DECISEC, CENTISEC};

  // SEVEN-SEGMENT DISPLAY DRIVERS

  // replace upper segments with code to disable display
  assign HEX7 = 7'b0000000;
  assign HEX6 = 7'b0000000;
  assign HEX5 = 7'b0000000;

  hex_to_seven_seg minDisplay(
    .B(MIN),
    .SSEG_L(HEX4)
  );

  hex_to_seven_seg tensecDisplay(
    .B(TENSEC),
    .SSEG_L(HEX3)
  );

  hex_to_seven_seg secDisplay(
    .B(SEC),
    .SSEG_L(HEX2)
  );

  hex_to_seven_seg decisecDisplay(
    .B(DECISEC),
    .SSEG_L(HEX1)
  );

  hex_to_seven_seg centisecDisplay(
    .B(CENTISEC),
    .SSEG_L(HEX0)
  );

endmodule
