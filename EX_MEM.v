`timescale 1ns / 1ps

module EX_MEM(
	input clk,
	input rst,
	input en,
	input bubble,
	input [31:0] I_PC, I_IR,
	input I_RegWrite, I_MemtoReg, I_MemWrite, I_JAL, I_Halt,
	input [31:0] I_res1, I_mem_din,
	input [4:0] I_Wnum,
	input [1:0] I_mode,

	output reg [31:0] O_PC, O_IR, 
	output reg O_RegWrite, O_MemtoReg, O_MemWrite, O_JAL, O_Halt,
	output reg [31:0] O_res1, O_mem_din,
	output reg [4:0] O_Wnum,
	output reg [1:0] O_mode
    );

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
	O_PC <= 0; O_IR <= 0; 
	O_RegWrite <= 0; O_MemtoReg <= 0; O_MemWrite <= 0; O_JAL <= 0; O_Halt <= 0; 
	O_res1 <= 0; O_mem_din <= 0; 
	O_Wnum <= 0; 
	O_mode <= 0; 
	end
	else if(bubble)
	begin
	O_PC <= 0; O_IR <= 0; 
	O_RegWrite <= 0; O_MemtoReg <= 0; O_MemWrite <= 0; O_JAL <= 0; O_Halt <= 0; 
	O_res1 <= 0; O_mem_din <= 0; 
	O_Wnum <= 0; 
	O_mode <= 0; 
	end
	else if(~en)
	begin
	O_PC <= I_PC; O_IR <= I_IR; 
	O_RegWrite <= I_RegWrite; O_MemtoReg <= I_MemtoReg; O_MemWrite <= I_MemWrite; O_JAL <= I_JAL; O_Halt <= I_Halt; 
	O_res1 <= I_res1; O_mem_din <= I_mem_din; 
	O_Wnum <= I_Wnum; 
	O_mode <= I_mode; 
	end
end
endmodule
