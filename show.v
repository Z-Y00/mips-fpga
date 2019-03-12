`timescale 1ns / 1ps

module show(
	input clk,
	input mod, 	// 1 repr base 16
	input [31:0] data,
	output [7:0] seg,
	output [7:0] an
    );

reg [2:0] pos = 0;
reg [3:0] dig;
wire clk_N;

divider     div (clk, clk_N);
display_num display_num_Unit(dig, pos, 0, 0, seg, an);

always @(*)
begin 
	case(pos)
	0:
	dig = mod? data[3:0]:    data % 10;
	1:
	dig = mod? data[7:4]:   (data % 100)/10;
	2:
	dig = mod? data[11:8]:  (data % 1000)/100;
	3:
	dig = mod? data[15:12]: (data % 10000)/1000;
	4:
	dig = mod? data[19:16]: (data % 100000)/10000;
	5:
	dig = mod? data[23:20]: (data % 1000000)/100000;
	6:
	dig = mod? data[27:24]: (data % 10000000)/1000000;
	7:
	dig = mod? data[31:28]: (data % 100000000)/10000000;
	endcase
end

always @(posedge clk_N)
begin 
	pos <= pos + 1;
end

endmodule

module divider #(parameter N = 1_500_00)(
	input clk,
	output reg clk_N
	);

reg [31:0] counter = 0;

always @(posedge clk)
begin 
	if(counter == ((N/2 - 1)))
	begin 
		clk_N = ~clk_N;
		counter = 0;	
	end
	else
	begin 
		counter = counter + 1;
	end
end

endmodule //divider


module display_num(
	input [3:0]dig,	//带显示16进制数字的4位二进制编码
	input [2:0]pos,	//带显示数码管编号
	input point, //显示小数点
	input off, //关闭显示
	output [7:0]seg,	//数码管驱动信号
	output [7:0]an		//数码管片选信号，低电平有效
    );
	
	decoder3_8 decoder(pos, off, an);
	pattern show16(dig, point, seg);
endmodule //display_num

module decoder3_8(
	input [2:0] pos,
	input off,
	output reg [7:0] an 
	);
	always @(*)
	if(off == 1)
		an = ~8'b00000000;
	else
	begin
		case (pos)	//注意低电平有效！
            3'o0: an =~ 8'b00000001;
            3'o1: an =~ 8'b00000010;
            3'o2: an =~ 8'b00000100;
            3'o3: an =~ 8'b00001000;
            
            3'o4: an =~ 8'b00010000;
            3'o5: an =~ 8'b00100000;
            3'o6: an =~ 8'b01000000;
            3'o7: an =~ 8'b10000000;   

            default: an =~ 8'b00000000;
        endcase // pos
    end 
endmodule // decoder3_8

module pattern(
	input [3:0]dig,
	input point,
	output reg [7:0] seg
	);
    always @(*)
    begin
	    case({dig, point})
	        {4'b0000,1'b0} : seg = 8'b11000000;
	        {4'b0000,1'b1} : seg = 8'b01000000;
	        {4'b0001,1'b0} : seg = 8'b11111001;
	        {4'b0001,1'b1} : seg = 8'b01111001;
	        {4'b0010,1'b0} : seg = 8'b10100100;
	        {4'b0010,1'b1} : seg = 8'b00100100;
	        {4'b0011,1'b0} : seg = 8'b10110000;
	        {4'b0011,1'b1} : seg = 8'b00110000;
	        
	        {4'b0100,1'b0} : seg = 8'b10011001;
	        {4'b0100,1'b1} : seg = 8'b00011001;
	        {4'b0101,1'b0} : seg = 8'b10010010;
	        {4'b0101,1'b1} : seg = 8'b00010010;
	        {4'b0110,1'b0} : seg = 8'b10000010;
	        {4'b0110,1'b1} : seg = 8'b00000010;
	        {4'b0111,1'b0} : seg = 8'b11111000;
	        {4'b0111,1'b1} : seg = 8'b01111000;
	        
	        {4'b1000,1'b0} : seg = 8'b10000000;
	        {4'b1000,1'b1} : seg = 8'b00000000;
	        {4'b1001,1'b0} : seg = 8'b10011000;
	        {4'b1001,1'b1} : seg = 8'b00011000;
	        {4'b1010,1'b0} : seg = 8'b10001000;
	        {4'b1010,1'b1} : seg = 8'b00001000;
	        {4'b1011,1'b0} : seg = 8'b10000011;
	        {4'b1011,1'b1} : seg = 8'b00000011;
	        
	        {4'b1100,1'b0} : seg = 8'b11000110;
	        {4'b1100,1'b1} : seg = 8'b01000110;
	        {4'b1101,1'b0} : seg = 8'b10100001;
	        {4'b1101,1'b1} : seg = 8'b00100001;
	        {4'b1110,1'b0} : seg = 8'b10000110;
	        {4'b1110,1'b1} : seg = 8'b00000110;
	        {4'b1111,1'b0} : seg = 8'b10001110;
	        {4'b1111,1'b1} : seg = 8'b00001110;
	        default: seg = 8'b11111111;
	    endcase 
    end
endmodule
