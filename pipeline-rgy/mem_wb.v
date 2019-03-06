`include "defines.v"

module mem_wb(
	input	wire				  clk,
	input wire					  clr,
	input wire[5:0]               stall,	
	input wire[`RegAddrBus]       mem_wd,
	input wire                    mem_wreg,
	input wire[`RegBus]			  mem_wdata,
	input wire[`RegBus]           mem_hi,
	input wire[`RegBus]           mem_lo,
	input wire                    mem_whilo,	
	output reg[`RegAddrBus]      wb_wd,
	output reg                   wb_wreg,
	output reg[`RegBus]			 wb_wdata,
	output reg[`RegBus]          wb_hi,
	output reg[`RegBus]          wb_lo,
	output reg                   wb_whilo		       
);


	always @ (posedge clk) begin
		if(clr == 1) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= 32'h00000000;	
		  wb_hi <= 32'h00000000;
		  wb_lo <= 32'h00000000;
		  wb_whilo <= `WriteDisable;	
		end else if(stall[4] == 1 && stall[5] == 0) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= 32'h00000000;
		  wb_hi <= 32'h00000000;
		  wb_lo <= 32'h00000000;
		  wb_whilo <= `WriteDisable;		  	  
		end else if(stall[4] == 0) begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
			wb_hi <= mem_hi;
			wb_lo <= mem_lo;
			wb_whilo <= mem_whilo;			
		end    
	end      
			

endmodule