`include "defines.v"

module pc_reg(
	input	wire										clk,
	input wire										clr,

	
	input wire[5:0]               stall,

	
	input wire                    branch_flag_in,
	input wire[`RegBus]           branch_target_address_in,
	
	output reg[`InstAddrBus]			pc,
	output reg                    ce
	
);

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;
		end else if(stall[0] == 0) begin
		  	if(branch_flag_in == `Branch) begin
					pc <= branch_target_address_in;
				end else begin
		  		pc <= pc + 4'h4;
		  	end
		end
	end

	always @ (posedge clk) begin
		if (clr == 1) begin
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

endmodule