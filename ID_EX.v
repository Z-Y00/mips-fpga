`timescale 1ns / 1ps

module ID_EX(
	input clk,
	input rst,
	input en,
	input bubble,
	input [31:0] I_PC, I_IR,
	input I_RegWrite, I_MemtoReg, I_MemWrite, 
	input [1:0] I_Mode,
	input I_ALU_SRC, I_BEQ, I_BNE, I_JR, I_JMP, I_JAL, I_BGTZ, I_Shamt,
	input [3:0] I_ALU_OP,
	input I_syscall, 
	input [4:0] I_Wnum,
	input [31:0] I_R1, I_R2, I_Imm,
	input I_R1_EX, I_R1_MEM, I_R2_EX, I_R2_MEM,

	output reg [31:0] O_PC, O_IR,
	output reg O_RegWrite, O_MemtoReg, O_MemWrite,
	output reg [1:0] O_Mode,
	output reg O_ALU_SRC, O_BEQ, O_BNE, O_JR, O_JMP, O_JAL, O_BGTZ, O_Shamt,
	output reg [3:0] O_ALU_OP,
	output reg O_syscall, 
	output reg [4:0] O_Wnum,
	output reg [31:0] O_R1, O_R2, O_Imm,
	output reg R1_EX, R1_MEM, R2_EX, R2_MEM
	);

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		O_PC <= 0; O_IR <= 0;
		O_RegWrite <= 0; O_MemtoReg <= 0; O_MemWrite <= 0; O_Mode <= 0;
		O_ALU_SRC <= 0; O_BEQ <= 0; O_BNE <= 0; O_JR <= 0; O_JMP <= 0; O_JAL <= 0; O_BGTZ <= 0; O_Shamt <= 0;
		O_ALU_OP <= 0;
		O_syscall <= 0; 
		O_Wnum <= 0;
		O_R1 <= 0; O_R2 <= 0; O_Imm <= 0;	
		R1_EX <= 0; R1_MEM <= 0; R2_EX <= 0; R2_MEM <= 0;
	end
	else if(bubble)
	begin
		O_PC <= 0; O_IR <= 0;
		O_RegWrite <= 0; O_MemtoReg <= 0; O_MemWrite <= 0; O_Mode <= 0;
		O_ALU_SRC <= 0; O_BEQ <= 0; O_BNE <= 0; O_JR <= 0; O_JMP <= 0; O_JAL <= 0; O_BGTZ <= 0; O_Shamt <= 0;
		O_ALU_OP <= 0;
		O_syscall <= 0; 
		O_Wnum <= 0;
		O_R1 <= 0; O_R2 <= 0; O_Imm <= 0;
		R1_EX <= 0; R1_MEM <= 0; R2_EX <= 0; R2_MEM <= 0;
	end
	else if(~en)
	begin
		O_PC <= I_PC; O_IR <= I_IR;
		O_RegWrite <= I_RegWrite; O_MemtoReg <= I_MemtoReg; O_MemWrite <= I_MemWrite; O_Mode <= I_Mode;
		O_ALU_SRC <= I_ALU_SRC; O_BEQ <= I_BEQ; O_BNE <= I_BNE; O_JR <= I_JR; O_JMP <= I_JMP; O_JAL <= I_JAL; O_BGTZ <= I_BGTZ; O_Shamt <= I_Shamt;
		O_ALU_OP <= I_ALU_OP;
		O_syscall <= I_syscall; 
		O_Wnum <= I_Wnum;
		O_R1 <= I_R1; O_R2 <= I_R2; O_Imm <= I_Imm;
		R1_EX <= I_R1_EX; R1_MEM <= I_R1_MEM; R2_EX <= I_R2_EX; R2_MEM <= I_R2_MEM;
	end
end
endmodule
