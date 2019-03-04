`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kyle
// 
// Create Date: 2019/02/19 14:08:15
// Design Name: 
// Module Name: register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register(Data_in,Enable,clk,clr,Data_out);
	parameter WIDTH = 32;
	//WIDTH:��������ʵ����ʱ������ʹ�ô˲�����չData��λ��
	input wire [WIDTH-1:0] Data_in;
	//clr ������ �첽����Data_out
	//ʹ�ܶ�Ϊ0ʱ,����ʱ��
	//ʹ�ܶ�Ϊ1ʱ,ʱ�������ظ���Data_out
	input wire Enable;
	input wire clk;
	input wire clr;
	output reg [WIDTH-1:0] Data_out;
	
	initial begin
		Data_out = 0;
	end
	
	always @(posedge clr or posedge clk) begin
		if(clr == 1) begin
			Data_out = 0;
		end
		else if(Enable == 1) begin
			Data_out = Data_in;
		end
	end
endmodule
