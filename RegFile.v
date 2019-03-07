`timescale 1ns / 1ps

module RegFile(
	input [4:0] R1_num,
	input [4:0] R2_num, //R1 R2 输入编号
	input [4:0] W_num, //写入寄存器编号
	input [31:0] Din, //写入数据
	input WE, //使能
	input clk, //时钟
	output [31:0] R1_data, //输出寄存器1
	output [31:0] R2_data, //输出寄存器2
	//output [31:0]regProbe0,
	//output [31:0]regProbe1
	input enable_userBackUp,enable_BackUp1,enable_BackUp2,
	input restore_userBackUp,restore_BackUp1,restore_BackUp2

    );

reg [31:0]Reg[31:0]; //32个大小为32的寄存器文件
reg [31:0]Reg0[31:0]; 
reg [31:0]Reg1[31:0]; 
reg [31:0]Reg2[31:0]; 



assign regProbe0=Reg[0];
assign regProbe1=Reg[1];


integer i;
initial begin
  	for (i = 0; i<32 ; i = i+1)
  		Reg[i] = 0;
end

always @(posedge clk)
begin
	if(WE) Reg[W_num] = Din;//写入

	//backup
	if (enable_userBackUp) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg0[i] = Reg[i];
	end
	if (enable_BackUp1) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg1[i] = Reg[i];
	end
	if (enable_BackUp2) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg2[i] = Reg[i];
	end

	//restore
	if (restore_userBackUp) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg[i] = Reg0[i];
	end
		if (restore_BackUp1) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg[i] = Reg1[i];
	end
			if (restore_BackUp2) begin
    	for (i = 0; i<32 ; i = i+1)
    		Reg[i] = Reg2[i];
	end
end

assign R1_data = Reg[R1_num];
assign R2_data = Reg[R2_num];

endmodule
