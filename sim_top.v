`timescale 1ns / 1ps

module sim_top();
	reg clr,Go;
	reg clk;
	reg [2:0] Show;
	reg [1:0] Hz;
	reg [3:0]probe = 0;
	wire clk_N;
	wire [7:0] SEG,AN;

	top top_Unit(clr,Go,clk,Show,Hz,clk_N,SEG,AN, probe);

	initial begin
		clk = 0;
		clr = 1;
		Go = 0;
		Show = 2'b00;
		Hz = 0;
		#5000
		# 5 clk = ~clk;
		# 5 clk = ~clk;
		# 50 clr = 0;
		# 5 forever
		# 10 clk = ~clk;
		# 10000 
		clr = 1;
		# 10 
		clr = 0;
	end

	// initial begin
	// 	# 30 Go = 1;
	// 	# 30 Go = 0;
	// 	# 19000
	// end

endmodule