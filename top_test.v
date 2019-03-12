`timescale 1ns / 1ps

module top_test();
	reg clr,Go;
	reg clk;
	reg [2:0] Show;
	reg [1:0] Hz;
	wire clk_N;
	wire [7:0] SEG,AN;

	top top_Unit(clr,Go,clk,Show,Hz,clk_N,SEG,AN);

	initial begin
		clk = 0;
		clr = 0;
		Go = 0;
		Show = 2'b00;
		Hz = 0;
		# 5 forever
		# 10 clk = ~clk;
		# 10000 
		clr = 1;
		# 10 
		clr = 0;
	end

	initial begin
		# 30 Go = 1;
		# 30 Go = 0;
		# 190000
		Go = 1;
	end

endmodule
