`timescale 1ns / 1ps

module top_test();
	reg clr,Go;
	reg clk;
	reg [2:0] Show;
	reg [1:0] Hz;
	wire clk_N;
	wire [3:0]probe;
	wire [7:0] SEG,AN;
	wire [31:0] Leddata,countAll,Count_branch,countJmp;
	wire [31:0] ledShow;
      reg inter1,inter2,inter3;
      wire  inter_running1,inter_running2,inter_running3;

	top top_Unit(clr,Go,clk,Show,Hz,clk_N,SEG,AN,probe,inter1,inter2,inter3,inter_running1,inter_running2,inter_running3);

	initial begin
		clk = 0;
		clr = 0;
		Go = 0;
		Show = 0;
		Hz = 0;
		inter1=0;
		inter2=0;
		inter3=0;
		#1 forever
		#1 clk = ~clk;
	end

	initial begin

		//用来检测高级打断低级
		//3-》1
		//  # 30 Go = 1;
		//  # 90 inter1=1;
   		//  # 1 inter1=0;
   		//  # 800 inter3=1;
   		//  # 1 inter3=0;
		// 	//3-》2
		//  # 30 Go = 1;
		//  # 1 inter2=1;
   		//  # 1 inter2=0;
   		//   # 190 inter3=1;
   		//   # 1 inter3=0;
		//2-》1
		//  # 30 Go = 1;
		//  # 1 inter1=1;
   		//  # 1 inter1=0;
   		//  # 120 inter2=1;
   		//  # 1 inter2=0;
		//3->2-》1
		 # 30 Go = 1;
		 # 90 inter1=1;
   		 # 1 inter1=0;
   		 # 120 inter2=1;
   		 # 1 inter2=0;
		# 120 inter3=1;
   		 # 1 inter3=0;
		//用来检测每个级别的中断
		//  # 30 Go = 1;
		//  # 1 inter1=1;
   		//  # 80 inter1=0;

		//   # 30 Go = 1;
		//  # 1 inter3=1;
   		//   # 1 inter3=0;

		   //用来检测高级中断的时候，发生了低级中断
		//  # 30 Go = 1;
		//  # 1 inter3=1;
   		//  # 1 inter3=0;
   		//  # 120 inter1=1;
   		//  # 1 inter1=0;

	end

endmodule
