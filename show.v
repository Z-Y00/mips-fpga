`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kyle
// 
// Create Date: 2019/02/20 11:14:34
// Design Name: 
// Module Name: show
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

module show(clk,Leddata,SEG, AN);
	input clk;              // ϵͳʱ��
	input [31:0] Leddata;
	output [7:0] SEG;  		// �ֱ��ӦCA��CB��CC��CD��CE��CF��CG��DP
	output [7:0] AN;        // 8λ�����Ƭѡ�ź�
	wire [2:0] num;
	wire [3:0] code;
	// ����ʵ��
	top_of_divider_counter instantiation_1(clk,num);
	ram8x4 instantiation_2(clk,num,Leddata,code);
	decoder3_8 instantiation_3(num,AN);
	pattern instantiation_4(code,SEG);
endmodule

module ram8x4(clk,addr,data_in,data_out);
	input clk;
	input wire [2:0] addr;
	input wire [31:0] data_in;
	output reg [3:0] data_out;

	reg [3: 0] mem [7: 0];      //  8��4λ�Ĵ洢��
	reg [3:0] data;
	initial   begin             // ��ʼ���洢��
		mem[0]=4'b0000;
		mem[1]=4'b0000;
		mem[2]=4'b0000;
		mem[3]=4'b0000;
		mem[4]=4'b0000;
		mem[5]=4'b0000;
		mem[6]=4'b0000;
		mem[7]=4'b0000;          
	end
	
	always @(posedge clk)begin
		mem[0] = data_in[3:0];
		mem[1] = data_in[7:4];
		mem[2] = data_in[11:8];
		mem[3] = data_in[15:12];
		mem[4] = data_in[19:16];
		mem[5] = data_in[23:20];
		mem[6] = data_in[27:24];
		mem[7] = data_in[31:28];
	end
	always @(negedge clk) begin
		case(addr[2:0])
			3'b000     : data_out=mem[7];
			3'b001     : data_out=mem[6];
			3'b010     : data_out=mem[5];
			3'b011     : data_out=mem[4];
			3'b100     : data_out=mem[3];
			3'b101     : data_out=mem[2];
			3'b110     : data_out=mem[1];
			3'b111     : data_out=mem[0];
		endcase
	end                         // ��ȡaddr��Ԫ��ֵ���                      
endmodule


module top_of_divider_counter(clk, out);
	input clk;                    // ����ʱ��
	output [2:0] out;             // ����ֵ
	wire [2:0] out;				  // ��always����ж�out���и�ֵ������Ϊreg
	wire clk_N;                  //����Ϊreg�������޸�Ϊwire�󲻱���


	divider instantiation_of_divider(clk,clk_N);//ʵ����divider
	counter1 instantiation_of_counter(clk_N,out);
endmodule

module divider #(parameter N = 1_500_00 ) (clk, clk_N);
	input clk;                      // ϵͳʱ��
	output clk_N;                   // 
	reg [31:0] counter;             /* ������������ͨ������ʵ�ַ�Ƶ��
									   ����������0������(N/2-1)ʱ��
									   ���ʱ�ӷ�ת������������ */
	reg clk_N;						//��always����ж�clk_N��ֵ������Ϊreg
									   
	initial begin
		counter = 0;
	end

	always @(posedge clk)begin    // ʱ��������
		// ����ʵ��
		if(counter == ((N/2)-1))
			begin
			clk_N = ~ clk_N;		//���ʱ�ӷ�ת
			counter = 0;		//����������
			end
		else
			begin
			counter = counter + 1;//��������һ
			end
	end                           
endmodule

module counter1(clk, out);
	input clk;                    // ����ʱ��
	output [2:0] out;             // ����ֵ
	reg [2:0] out;				  // ��always����ж�out���и�ֵ������Ϊreg

	initial begin
		out = 0;
	end

	always @(posedge clk)  begin  // ��ʱ�������ؼ�������1
								  // ����ʵ��
		out = out + 1;
	end                           
endmodule

module decoder3_8(num, sel);
	input [2: 0] num;       // ����ܱ�ţ�0~7
	output reg [7:0] sel;       // 7�������Ƭѡ�źţ��͵�ƽ��Ч

						  // ����ʵ��
	always begin
	case(num[2:0])
				3'b000:  sel[7:0] = 8'b01111111;
				3'b001:  sel[7:0] = 8'b10111111;
				3'b010:  sel[7:0] = 8'b11011111;
				3'b011:  sel = 8'b11101111;
				3'b100:  sel = 8'b11110111;
				3'b101:  sel = 8'b11111011;
				3'b110:  sel = 8'b11111101;
				3'b111:  sel = 8'b11111110;
	endcase	
	end
endmodule

module pattern(code, patt);
	input [3: 0] code;       // 16�������ֵ�4λ�����Ʊ���
	output reg [7:0] patt;       // 7��������������͵�ƽ��Ч
	// ����ʵ��
	always 
	begin
	case(code[3:0])
		4'b0000:  patt[7:0] = 8'b11000000;
		4'b0001:  patt[7:0] = 8'b11111001;
		4'b0010:  patt[7:0] = 8'b10100100;
		4'b0011:  patt = 8'b10110000;
		4'b0100:  patt = 8'b10011001;
		4'b0101:  patt = 8'b10010010;
		4'b0110:  patt = 8'b10000010;
		4'b0111:  patt = 8'b11111000;
		4'b1000:  patt = 8'b10000000;
		4'b1001:  patt = 8'b10011000;
		4'b1010:  patt = 8'b10001000;
		4'b1011:  patt = 8'b10000011;  
		4'b1100:  patt = 8'b11000110;
		4'b1101:  patt = 8'b10100001;
		4'b1110:  patt = 8'b10000110;
		4'b1111:  patt = 8'b10001110;
	endcase
	end
endmodule
