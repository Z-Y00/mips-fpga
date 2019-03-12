`timescale 1ns / 1ps

module MIPS_CPU(
	input rst, Go, clk, //branch 是条件跳转，jmp 是无条件跳转
	output [31:0] Leddata, Count_cycle, Count_branch, Count_jmp,
	input [3:0] probe,
	output [31:0] mem_probe
    );

// control 接出
wire Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext,
 Regdst, Beq, Bne, Jr, Jmp, Jal, Shift,  Bgtz;

//PC
reg [31:0] PC;
wire [31:0] ID_PC, EX_PC, MEM_PC, WB_PC;
wire [31:0] ID_IR, EX_IR, MEM_IR, WB_IR;

// 控制器
wire [5:0] OP, Func;
wire [3:0] ALU_OP;
wire [31:0] instr;
wire [1:0] Mode;
assign OP = ID_IR[31:26];
assign Func = ID_IR[5:0];
control control1(OP, Func, ALU_OP, Memtoreg, Memwrite, Alu_src, 
	Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, 
    Jal, Shift, Bgtz, Mode);
wire [15:0]high = ID_IR[15] ? 16'hFFFF : 16'h0;
wire [31:0]imm = (Signedext) ? {high, ID_IR[15:0]} : {16'h0, ID_IR[15:0]};

wire LoadUse;
wire branch;
// 流水使能
wire EN1, EN2, EN3, EN4;
assign EN1 = LoadUse | ~run;
assign EN2 = ~run;
assign EN3 = ~run;
assign EN4 = ~run;

// 流水气泡
wire bubble1, bubble2, bubble3, bubble4;
assign bubble1 = branch;
assign bubble2 = branch | LoadUse;
assign bubble3 = 0;
assign bubble4 = 0;

ROM ROM1(PC[11:0], instr);
// IF/ID
IF_ID IF_ID1(clk, rst, EN1, bubble1, PC, instr, ID_PC, ID_IR);

// Regfile
wire [4:0] R1_in, R2_in, W_in;
wire [31:0] R1_out, R2_out, Din;

assign R1_in = (Syscall == 1) ? 5'b00010 : ID_IR[25:21];
assign R2_in = (Syscall == 1) ? 5'b00100 : ID_IR[20:16];
assign W_in = (Jal == 1) ? 5'b11111 : 
			  (Regdst == 0) ? ID_IR[20:16] : ID_IR[15:11];

// ID/EX
wire EX_RegWrite, EX_MemtoReg, EX_MemWrite;
wire [1:0]EX_Mode;
wire EX_ALU_SRC, EX_BEQ, EX_BNE, EX_JR, EX_JMP, EX_JAL, EX_BGTZ;
wire [3:0] EX_ALU_OP;
wire EX_syscall, EX_Shamt;//这个EX_Shamt是标志位，不要和shamt弄混
wire [4:0] EX_Wnum;
wire [31:0] EX_R1, EX_R2, EX_Imm;
wire R1_EX, R1_MEM, R2_EX, R2_MEM;//数据相关标志
wire I_R1_EX, I_R1_MEM, I_R2_EX, I_R2_MEM;


assign LoadUse = (I_R1_EX | I_R2_EX) & EX_MemtoReg & ~EX_JAL;
ID_EX ID_EX1(clk, rst, EN2, bubble2, ID_PC, ID_IR, Regwrite, 
	Memtoreg, Memwrite, Mode, Alu_src, Beq, Bne, Jr, Jmp, Jal, 
	Bgtz, Shift, ALU_OP, Syscall, W_in, R1_out, R2_out, imm, 
	I_R1_EX, I_R1_MEM, I_R2_EX, I_R2_MEM,
	//输出信号
	EX_PC, EX_IR, EX_RegWrite, EX_MemtoReg, EX_MemWrite, EX_Mode,
	EX_ALU_SRC, EX_BEQ, EX_BNE, EX_JR, EX_JMP, EX_JAL, EX_BGTZ, 
	EX_Shamt, EX_ALU_OP, EX_syscall, EX_Wnum, EX_R1, EX_R2, EX_Imm,
	R1_EX, R1_MEM, R2_EX, R2_MEM);


//这里的EX_O_R1和EX_O_R2是重定向得到的
//ALU
wire [31:0] EX_O_R1, EX_O_R2;
wire [31:0] X, Y;
wire [4:0] shamt;
wire [31:0] EX_res1;
wire equal;
assign X = EX_O_R1;
assign Y = EX_ALU_SRC ? EX_Imm : EX_O_R2;
assign shamt = (EX_Shamt == 1) ? EX_O_R1 : EX_IR[10:6];
ALU alu1 (X, Y, EX_ALU_OP, shamt, EX_res1, equal);

//syscall板块
LedData led(EX_syscall, EX_O_R1, EX_O_R2, clk, rst, Leddata);
wire EX_Halt = EX_syscall & (EX_O_R1 != 32'h22);

wire MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite, MEM_JAL, MEM_Halt;
wire [31:0] MEM_res1, MEM_MemDin;
wire [4:0] MEM_Wnum;
wire [1:0] MEM_mode;

wire [31:0] EX_MemDin = EX_O_R2;

// EX/MEM
EX_MEM EX_MEM1(
	clk, rst, EN3, bubble3, EX_PC, EX_IR, EX_RegWrite, EX_MemtoReg,
	EX_MemWrite, EX_JAL, EX_Halt, EX_res1, EX_MemDin, 
	EX_Wnum, EX_Mode,
	//输出信号
	MEM_PC, MEM_IR, 
	MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite, MEM_JAL, MEM_Halt,
	MEM_res1, MEM_MemDin,
	MEM_Wnum, 
	MEM_mode
	);

// 控制运行与暂停
reg run;
assign rstn = rst | Go;
always @(posedge clk or posedge rstn) begin : proc_run
	if(rstn) begin
		run <= 1;
	end else if(MEM_Halt) begin
		run <= 0;
	end 
end

//RAM
wire [31:0]MEM_MemOut;

parameter RAM_Width = 7;
RAM RAM1(MEM_res1[RAM_Width - 1:0], MEM_MemDin, MEM_mode, 
	MEM_MemWrite, clk, rst, MEM_MemOut, mem_probe, probe);
//MEM_res1是地址

wire WB_RegWrite, WB_MemtoReg, WB_jal; 
wire [31:0] WB_res1, WB_MemOut;
wire [4:0] WB_Wnum;

// MEM/WB
MEM_WB MEM_WB1(
	clk, rst, EN4, bubble4, MEM_PC, MEM_IR,
	MEM_RegWrite,  MEM_MemtoReg, MEM_JAL, 
	MEM_res1, MEM_MemOut, MEM_Wnum,
	WB_PC, WB_IR,
	WB_RegWrite, WB_MemtoReg, WB_jal, 
	WB_res1, WB_MemOut,
	WB_Wnum
	);
wire [31:0] WB_NPC;
assign WB_NPC = WB_PC + 4;

assign Din = (WB_jal == 1) ? WB_NPC : 
			  (WB_MemtoReg == 1) ? WB_MemOut : WB_res1;//顺序

RegFile regFile1(R1_in, R2_in, WB_Wnum, Din, WB_RegWrite, clk,
	R1_out, R2_out);

DataRelate DataRelate1(OP, Func, EX_Wnum, MEM_Wnum, R1_in, R2_in, 
	EX_RegWrite, MEM_RegWrite, I_R1_EX, I_R1_MEM, I_R2_EX, I_R2_MEM);

wire Branch_Rel = (EX_BNE & ~equal) | (EX_BEQ & equal) | 
	(EX_BGTZ & (EX_O_R1 > 0));
wire Branch_Abs = EX_JMP | EX_JAL;
wire Branch_Reg = EX_JR;
assign branch = Branch_Rel | Branch_Abs | Branch_Reg;
wire [31:0]RelateAddr = EX_PC + 32'h4 + (EX_Imm << 2);
wire [31:0]AbsoluteAddr = {EX_PC[31:28], EX_IR[25:0], 2'b00};
wire [31:0]RegAddr = EX_O_R1;
assign EX_O_R1 = R1_EX ? MEM_res1 : R1_MEM ? Din : EX_R1;
assign EX_O_R2 = R2_EX ? MEM_res1 : R2_MEM ? Din : EX_R2;

always @(posedge clk or posedge rst) begin : proc_PC
	if(rst) begin
		PC <= 0;
	end else if(run & ~LoadUse) begin
		PC <= Branch_Reg ? RegAddr : 
			  Branch_Abs ? AbsoluteAddr : 
			  Branch_Rel ? RelateAddr : PC + 4;
	end
end

// 计数
Counter count1(run, clk, rst, Count_cycle);
Counter count2(run & Branch_Rel, clk, rst, Count_branch);//条件分支
Counter count3(run & (Branch_Abs | Branch_Reg), 
				clk, rst, Count_jmp);//无条件分支

endmodule
