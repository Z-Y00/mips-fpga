`include "defines.v"

module if_id(
	input	wire				  clk,
	input wire					  clr,
	input wire[5:0]               stall,	
	input wire[`InstAddrBus]	  if_pc,
	input wire[`InstBus]          if_inst,
	output reg[`InstAddrBus]      id_pc,
	output reg[`InstBus]          id_inst  
	
);

	always @ (posedge clk) begin
		if (clr == 1) begin
			id_pc <= 32'h00000000;
			id_inst <= 32'h00000000;
		end else if(stall[1] == 1 && stall[2] == 0) begin
			id_pc <= 32'h00000000;
			id_inst <= 32'h00000000;	
	  end else if(stall[1] == 0) begin
		  id_pc <= if_pc;
		  id_inst <= if_inst;
		end
	end

endmodule