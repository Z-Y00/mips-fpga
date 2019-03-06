
`include "defines.v"

module ex_mem(

	input	wire										clk,
	input wire										clr,

	input wire[5:0]							 stall,	
	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]					 ex_wdata, 	

    input wire[`AluOpBus]        ex_aluop,
	input wire[`RegBus]          ex_mem_addr,
	input wire[`RegBus]          ex_reg2,

	input wire[1:0]               cnt_in,	
	
	output reg[`RegAddrBus]      mem_wd,
	output reg                   mem_wreg,
	output reg[`RegBus]					 mem_wdata,

    output reg[`AluOpBus]        mem_aluop,
	output reg[`RegBus]          mem_mem_addr,
	output reg[`RegBus]          mem_reg2,
		
	output reg[1:0]              cnt_o	
	
	
);


	always @ (posedge clk) begin
		if(clr == 1) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
    		mem_wdata <= 32'h00000000;	
    		mem_hi <= 32'h00000000;
    		mem_lo <= 32'h00000000;
    		mem_whilo <= `WriteDisable;		
 	        hilo_o <= {32'h00000000, 32'h00000000};
 			cnt_o <= 2'b00;	
   		    mem_aluop <= `EXE_NOP_OP;
 			mem_mem_addr <= 32'h00000000;
 			mem_reg2 <= 32'h00000000;			
		end else if(stall[3] == 1 && stall[4] == 0) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		  	mem_wdata <= 32'h00000000;
		  	mem_hi <= 32'h00000000;
		  	mem_lo <= 32'h00000000;
		 	mem_whilo <= `WriteDisable;
	    	hilo_o <= hilo_in;
			cnt_o <= cnt_in;	
  			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= 32'h00000000;
			mem_reg2 <= 32'h00000000;						  				    
		end else if(stall[3] == 0) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;	
			mem_hi <= ex_hi;
			mem_lo <= ex_lo;
			mem_whilo <= ex_whilo;	
	    	hilo_o <= {32'h00000000, 32'h00000000};
			cnt_o <= 2'b00;	
  			mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;			
		end else begin
			cnt_o <= cnt_in;											
		end    //if
	end      //always
			

endmodule