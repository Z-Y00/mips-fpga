`timescale 1ns / 1ps

module top_test();
	reg clr,Go;
	reg clk;
	reg [2:0] Show;
	reg [1:0] Hz;
	wire clk_N;
	wire [7:0] SEG,AN;
	wire [31:0] Leddata,countAll,Count_branch,countJmp;
	wire [31:0] ledShow;

	top top_Unit(clr,Go,clk,Show,Hz,clk_N,SEG,AN);

	initial begin
		clk = 0;
		clr = 0;
		Go = 0;
		Show = 0;
		Hz = 0;
		#5 forever
		#10 clk = ~clk;
	end

	initial begin
		# 30 Go = 1;
	end

endmodule
