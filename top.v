`timescale 1ns / 1ps

module top(clr,Go,clk,Show,Hz,clk_N,SEG,AN);
	input clr,Go;
	input clk;
	input [2:0] Show;
	input [1:0] Hz;
	output wire clk_N;
	output [7:0] SEG,AN;
	wire [31:0] Leddata,countAll,Count_branch,countJmp;
	wire [31:0] ledShow;
	reg [31:0] N;
	reg [31:0] counter;             

	assign ledShow = (Show == 2'b00) ? Leddata :
					 (Show == 2'b10) ? countJmp :
					 (Show == 2'b11) ? Count_branch :
					 countAll; 

	show show(clk,ledShow,SEG,AN);	
	MIPS_CPU MIPS_CPU(clr,Go,clk_N,Leddata,countAll,Count_branch,countJmp);
	
	always @(*) begin 
		case(Hz)
			2'b00: N = 10000;
			2'b01: N = 100000;
			2'b10: N = 1000000;
			2'b11: N = 10000000;
		endcase
	end
	
	always @(posedge clk)begin    
		
		if(counter % N == 0)
			begin
				clk_N = ~ clk_N;		
				counter = 1;		
			end
		else
			begin
				counter = counter + 1;
			end
	end                           

endmodule
