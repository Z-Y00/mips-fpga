`timescale 1ns / 1ps

module MEM_WB(
	input clk,
	input rst,
	input en,
	input bubble,
	input [31:0] I_PC, I_IR,
	input I_RegWrite, I_MemtoReg, I_jal, 
	input [31:0] I_res1, I_MemOut,
	input [4:0] I_Wnum,

	output reg [31:0] O_PC, O_IR,
	output reg O_RegWrite, O_MemtoReg, O_jal, 
	output reg [31:0] O_res1, O_MemOut,
	output reg [4:0] O_Wnum
    );

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
	O_PC <= 0; O_IR <= 0;
	O_RegWrite <= 0; O_MemtoReg <= 0; O_jal <= 0; 
	O_res1 <= 0; O_MemOut <= 0;
	O_Wnum <= 0;
	end
	else if(bubble)
	begin
	O_PC <= 0; O_IR <= 0;
	O_RegWrite <= 0; O_MemtoReg <= 0; O_jal <= 0; 
	O_res1 <= 0; O_MemOut <= 0;
	O_Wnum <= 0;
	end
	else if(~en)
	begin
	O_PC <= I_PC; O_IR <= I_IR;
	O_RegWrite <= I_RegWrite; O_MemtoReg <= I_MemtoReg; O_jal <= I_jal; 
	O_res1 <= I_res1; O_MemOut <= I_MemOut;
	O_Wnum <= I_Wnum;
	end
end
endmodule
