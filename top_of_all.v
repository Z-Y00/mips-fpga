`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/20 11:38:03
// Design Name: 
// Module Name: top_of_all
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

module top_of_all(clr,Go,clk,choose_data_show,choose_Hz,clk_N,SEG,AN);
	input clr,Go;
	input clk;
	input [2:0] choose_data_show;
	//�뿪�ذ󶨣����������Led��ʾ��Դ
	input [1:0] choose_Hz;
	//�뿪�ذ󶨣����������MIPS CPU ��Ƶ��?
	output wire clk_N;
	output [7:0] SEG,AN;
	
	wire [31:0] Leddata,Count_all,Count_branch,Count_jmp;
	wire [31:0] Leddata_show;

	// initial begin
	// 	Leddata_show = 32'h0000_0000;
	// end

	assign Leddata_show = choose_data_show == 2'b00 ? Leddata :
							choose_data_show == 2'b01 ? Count_all :
							choose_data_show == 2'b10 ? Count_jmp :
							 Count_branch; //choose_data_show == 2'b11
	// always @(choose_data_show or Leddata or Count_all or Count_branch) begin
	// 	case(choose_data_show)
	// 		0:Leddata_show = Leddata;
	// 		1:Leddata_show = Count_all;
	// 		2:Leddata_show = Count_jmp;
	// 		3:Leddata_show = Count_branch;
	// 		default:Leddata_show = Leddata;
	// 		//default ������չʹ��
	// 	endcase
	// end
	
	show show(clk,Leddata_show,SEG,AN);	
	MIPS_CPU MIPS_CPU(clr,Go,clk_N,Leddata,Count_all,Count_branch,Count_jmp);
	divider_dif divider_dif(clk,choose_Hz,clk_N);

endmodule

module divider_dif(clk, choose_Hz,clk_N);
//���ļ����ܲ��������ڷ�Ƶ
	input clk;                      // ϵͳʱ��
	input [1:0] choose_Hz;
	//ѡ��Ƶ��
	//00:1000Hz,01:100Hz,10:10Hz,11:1Hz
	output reg clk_N;                   // ��Ƶ���ʱ��
	reg [31:0] N;
	reg [31:0] counter;             /* ������������ͨ������ʵ�ַ�Ƶ��
									   ����������0������(N/2-1)ʱ��
									   ���ʱ�ӷ�ת������������ */ 
	initial begin
		clk_N = 0;
		counter = 0;
		N = 10_000;
	end
	
	always @(choose_Hz) begin
		case(choose_Hz)
			2'b00: N = 10_000;
			2'b01: N = 100_000;
			2'b10: N = 1_000_000;
			2'b11: N = 10_000_000;
		endcase
	end
	
	always @(posedge clk)begin    // ʱ��������
		// ����ʵ��
		if(counter % N == 0)
			begin
				clk_N = ~ clk_N;		//���ʱ�ӷ�ת
				counter = 1;		//����������
			end
		else
			begin
				counter = counter + 1;//��������һ
			end
	end                           
endmodule
