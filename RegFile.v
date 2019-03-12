`timescale 1ns / 1ps

module RegFile(
	input [4:0] R1_num,
	input [4:0] R2_num, //R1 R2 输入编号
	input [4:0] W_num, //写入寄存器编号
	input [31:0] Din, //写入数据
	input WE, //使能
	input clk, //时钟
	output [31:0] R1_data, //输出寄存器1
	output [31:0] R2_data //输出寄存器2
    );

reg [31:0]Reg[31:0]; //32个大小为32的寄存器文件


integer i;
initial begin
  	for (i = 0; i<32 ; i = i+1)
  		Reg[i] = 0;
end

always @(negedge clk)
begin
	if(WE) Reg[W_num] = Din;//写入
end

assign R1_data = Reg[R1_num];
assign R2_data = Reg[R2_num];

endmodule
