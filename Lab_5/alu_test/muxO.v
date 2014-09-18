module muxO(OSEL, Oout, shifterResult, logicalResult);
  
  // inputs
  input [1:0] OSEL;
  input [7:0] shifterResult;
  input [7:0] logicalResult;
  
  // outputs
  output [7:0] Oout;

  // MUX LOGIC:
  //   if   OSEL == 0 => Oout = 0
  //   else           => Oout = 1
  assign Oout = (OSEL == 2'b00) ? 2'b00 : (OSEL == 2'b01) ? shifterResult : (OSEL == 2'b10) ? logicalResult : 8'b00000000;

endmodule