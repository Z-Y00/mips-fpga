`timescale 1ns / 1ps

module top(clr,Go,clk,Show,Hz,clk_N,SEG,AN,probe,inter1_in,inter2_in,inter3_in,inter_running1,inter_running2,inter_running3);
	input clr,Go;
	input clk;
	input [2:0] Show;
	input [1:0] Hz;
	input inter1_in,inter2_in,inter3_in;
	output wire  inter_running1,inter_running2,inter_running3;
	output reg clk_N;
	output [7:0] SEG,AN;
	wire [31:0] Leddata,countAll,Count_branch,countJmp;
	wire [31:0] ledShow;
	reg [31:0] N;
	reg [31:0] counter;                 
	wire mod;
    wire [31:0] mem_probe;
	input [3:0] probe;
	reg inter1,inter2,inter3;
	initial begin
	 inter1=0;inter2=0;inter3=0;
	end
	always @(posedge clk_N or posedge inter1_in  )
	begin
		if (inter1_in) begin
			inter1=1;
		end
		else begin
			#8
			inter1=0;
		end
	end
		always @(posedge clk_N or posedge inter2_in )
	begin
		if (inter2_in) begin
			inter2=1;
		end
		else begin
			#8
			inter2=0;
		end

	end
			always @(posedge clk_N or posedge inter3_in )
	begin
		if (inter3_in) begin
			inter3=1;
		end
		else begin
			#8
			inter3=0;
		end
	end



    initial begin
        clk_N = 0;
        N = 0;
        counter = 0;
    end
    
	assign ledShow = (Show == 3'b000) ? Leddata :
					 (Show == 3'b010) ? countJmp :
					 (Show == 3'b001) ? Count_branch :
					 (Show == 3'b100) ? mem_probe:
					 	countAll; 
  
	assign mod = (Show == 2'b00) ? 1'b1 : 1'b0;

	show show(clk,mod,ledShow,SEG,AN);	
	MIPS_CPU MIPS_CPU(clr,Go,clk_N,Leddata,countAll,Count_branch,countJmp,mem_probe,probe,inter1,inter2,inter3,inter_running1,inter_running2,inter_running3);
	
	always @(*) begin 
		case(Hz)
			2'b00: N = 10;
			2'b01: N = 100000;
			2'b10: N = 1000000;
			2'b11: N = 10000000;
		endcase
	end
	// for DEBUG
		//  always @(*) begin 
		//  	case(Hz)
		//  		2'b00: N = 2;
		//  		2'b01: N = 2;
		//  		2'b10: N = 2;
		//  		2'b11: N = 2;
		//  	endcase
		//  end

	
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
