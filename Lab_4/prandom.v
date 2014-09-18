module prandom(ADDRESS, DATA);
  input  [2:0] ADDRESS;
  
  output [9:0] DATA;
  
  reg    [9:0] DATA;

  always @(*) begin
    case(ADDRESS)
      3'd0:    DATA <= 10'd200;
      3'd1:    DATA <= 10'd700;
      3'd2:    DATA <= 10'd350;
      3'd3:    DATA <= 10'd500;
      3'd4:    DATA <= 10'd650;
      3'd5:    DATA <= 10'd300;
      3'd6:    DATA <= 10'd150;
      3'd7:    DATA <= 10'd550;
      default: DATA <= 10'bxxxxxxxxxx;
    endcase
  end

endmodule