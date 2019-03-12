`timescale 1ns / 1ps

module top(clr,Go,clk,Show,Hz,clk_N,SEG,AN, ShowRam);
	input clr,Go;
	input clk;
	input [2:0] Show;
	input [1:0] Hz;
	input ShowRam;

	output reg clk_N;
	output [7:0] SEG,AN;
	wire [31:0] Leddata,countAll,Count_branch,countJmp;
	wire [31:0] ledShow;
	wire mod;
	reg [31:0] N;
	reg [31:0] counter;

	
	reg [31:0] ShowRam_addr;
	wire [31:0] ShowRam_data;

    initial begin
        clk_N = 0;
        N = 0;
        counter = 0;
        ShowRam_addr = 0;
    end
    
	assign ledShow =  ShowRam ? ShowRam_data :
					 (Show == 2'b00) ? Leddata :
					 (Show == 2'b10) ? countJmp :
					 (Show == 2'b11) ? Count_branch :
					 countAll; 

	assign mod = (Show == 2'b00) ? 1'b1 : 1'b0;

	show show(clk,mod,ledShow,SEG,AN);	
	MIPS_CPU MIPS_CPU(clr,Go,clk_N,Leddata,countAll,Count_branch,countJmp, ShowRam, ShowRam_addr, ShowRam_data);
	
	   always @(*) begin 
	   	case(Hz)
	   		2'b00: N = 10000;
	   		2'b01: N = 100000;
	   		2'b10: N = 1000000;
	   		2'b11: N = 10000000;
	   	endcase
	   end

 	//for DEBUG
//	 always @(*) begin 
//	 	case(Hz)
//	 		2'b00: N = 2;
//	 		2'b01: N = 2;
//	 		2'b10: N = 2;
//	 		2'b11: N = 2;
//	 	endcase
//	 end


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

	always @(posedge clk_N) begin
		if(ShowRam && ShowRam_addr < 64)
			ShowRam_addr = ShowRam_addr + 4;
		else
			ShowRam_addr = 0;
	end
endmodule
