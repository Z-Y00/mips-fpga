`timescale 1ns / 1ps

module DataRelate(
	input [5:0] OP, F,
	input [4:0] EX_WriteNo, MEM_WriteNo, ID_R1No, ID_R2No,
	input EX_Write, MEM_Write,
	output R1_EX, R1_MEM, R2_EX, R2_MEM
    );

wire R1_Used, R2_Used;

assign R1_Used = ~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] & ~F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] & ~F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] &  F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] &  F[3] & ~F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] &  F[3] & ~F[2] &  F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] &  F[3] & ~F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] &  F[3] &  F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] &  OP[2] & ~OP[1] & ~OP[0] |
~OP[5] & ~OP[4] & ~OP[3] &  OP[2] & ~OP[1] &  OP[0] |
~OP[5] & ~OP[4] &  OP[3] & ~OP[2] & ~OP[1] & ~OP[0] |
~OP[5] & ~OP[4] &  OP[3] &  OP[2] & ~OP[1] & ~OP[0] |
~OP[5] & ~OP[4] &  OP[3] & ~OP[2] & ~OP[1] &  OP[0] |
~OP[5] & ~OP[4] &  OP[3] & ~OP[2] &  OP[1] & ~OP[0] |
~OP[5] & ~OP[4] &  OP[3] &  OP[2] & ~OP[1] &  OP[0] |
 OP[5] & ~OP[4] & ~OP[3] & ~OP[2] &  OP[1] &  OP[0] |
 OP[5] & ~OP[4] &  OP[3] & ~OP[2] &  OP[1] &  OP[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] & ~F[3] &  F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] &  F[0] |
 OP[5] & ~OP[4] &  OP[3] & ~OP[2] & ~OP[1] & ~OP[0] |
~OP[5] & ~OP[4] & ~OP[3] &  OP[2] &  OP[1] &  OP[0];

assign R2_Used = ~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] & ~F[3] & ~F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] & ~F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] & ~F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] &  F[2] &  F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] &  F[3] & ~F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] &  F[3] & ~F[2] &  F[1] &  F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] &  F[3] &  F[2] & ~F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] &  OP[2] & ~OP[1] & ~OP[0] |
~OP[5] & ~OP[4] & ~OP[3] &  OP[2] & ~OP[1] &  OP[0] |
 OP[5] & ~OP[4] &  OP[3] & ~OP[2] &  OP[1] &  OP[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] & ~F[5] & ~F[4] & ~F[3] &  F[2] &  F[1] & ~F[0] |
~OP[5] & ~OP[4] & ~OP[3] & ~OP[2] & ~OP[1] & ~OP[0] &  F[5] & ~F[4] & ~F[3] & ~F[2] &  F[1] &  F[0] |
 OP[5] & ~OP[4] &  OP[3] & ~OP[2] & ~OP[1] & ~OP[0];


assign R1_EX = (ID_R1No != 5'h0) & ((ID_R1No == EX_WriteNo) & R1_Used & EX_Write);
assign R1_MEM = (ID_R1No != 5'h0) & ((ID_R1No == MEM_WriteNo) & R1_Used & MEM_Write);

assign R2_EX = (ID_R2No != 5'h0) & ((ID_R2No == EX_WriteNo) & R2_Used & EX_Write);
assign R2_MEM = (ID_R2No != 5'h0) & ((ID_R2No == MEM_WriteNo) & R2_Used & MEM_Write);

endmodule
