module muxB(BSEL, Bout, BInput);
  
  // inputs
  input  BSEL;
  input [7:0] BInput;  
  // outputs
  output [7:0] Bout;

  // MUX LOGIC:
  //   if   BSEL == 0 => Bout = 0
  //   else           => Bout = 1
  assign Bout = (BSEL == 1'b0) ? BInput : ~BInput;

endmodule