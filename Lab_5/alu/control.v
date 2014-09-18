module control(OP, A, B, BSEL, CISEL, OSEL, SHIFT_LA, SHIFT_LR, LOGICAL_OP); // add other inputs and outputs here

  // inputs (add others here)
  input  [2:0]  OP;
  input [7:0] A;
  input [7:0] B;
  
  // outputs (add others here)
  output 		BSEL;
  output       CISEL;
  output [1:0]	OSEL;
  output			SHIFT_LA;
  output			SHIFT_LR;
  output			LOGICAL_OP;

  // reg and internal variable definitions
  
  
  // implement module here (add other control signals below)
  parameter ADD = 3'b000;
  parameter SUB = 3'b001;
  parameter SRA = 3'b010;
  parameter SRL = 3'b011;
  parameter SLL = 3'b100;
  parameter AND = 3'b101;
  parameter  OR = 3'b110;
  
  assign BSEL 	= (OP == SUB) ? 1'b1 : 1'b0;
  assign CISEL = (OP == SUB) ? 1'b1 : 1'b0;
  assign OSEL 	= (OP == ADD || OP == SUB) ? 2'b00 : (OP == SRA || OP == SRL || OP == SLL) ? 2'b01 : (OP == AND || OP == OR) ? 2'b10 : 2'b11;
  assign SHIFT_LA = (OP == SRA) ? 1'b1 : 1'b0;
  assign SHIFT_LR = (OP == SLL) ? 1'b0 : 1'b1;
  assign LOGICAL_OP = (OP == AND) ? 1'b0: 1'b1;
  
endmodule