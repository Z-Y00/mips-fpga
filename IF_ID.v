`timescale 1ns / 1ps

module IF_ID(
	input clk,
	input rst,
	input en,
	input bubble,
	input [31:0] I_PC,
	input [31:0]I_IR,
	output reg [31:0]O_PC,
	output reg [31:0]O_IR
    );

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		O_PC <= 0;
		O_IR <= 0;
	end
	else if(bubble)
	begin
		O_PC <= 0;
		O_IR <= 0;
	end
	else if(~en)
	begin
		O_PC <= I_PC;
		O_IR <= I_IR;
	end
end
endmodule
