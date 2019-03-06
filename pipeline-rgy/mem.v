`include "defines.v"

module mem(
	input wire					  clr,
	input wire[`RegAddrBus]       wd_in,
	input wire                    wreg_in,
	input wire[`RegBus]			  wdata_in,
	input wire[`RegBus]           hi_in,
	input wire[`RegBus]           lo_in,
	input wire                    whilo_in,	
    input wire[`AluOpBus]        aluop_in,
	input wire[`RegBus]          mem_addr_in,
	input wire[`RegBus]          reg2_in,
	input wire[`RegBus]          mem_data_in,
	output reg[`RegAddrBus]      wd_o,
	output reg                   wreg_o,
	output reg[`RegBus]			 wdata_o,
	output reg[`RegBus]          hi_o,
	output reg[`RegBus]          lo_o,
	output reg                   whilo_o,
	output reg[`RegBus]          mem_addr_o,
	output wire					 mem_we_o,
	output reg[3:0]              mem_sel_o,
	output reg[`RegBus]          mem_data_o,
	output reg                   mem_ce_o	
);

	wire[`RegBus] zero32;
	reg                   mem_we;

	assign mem_we_o = mem_we ;
	assign zero32 = 32'h00000000;
	
	always @ (*) begin
		if(clr == 1) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  wdata_o <= 32'h00000000;
		  hi_o <= 32'h00000000;
		  lo_o <= 32'h00000000;
		  whilo_o <= `WriteDisable;		
		  mem_addr_o <= 32'h00000000;
		  mem_we <= `WriteDisable;
		  mem_sel_o <= 4'b0000;
		  mem_data_o <= 32'h00000000;
		  mem_ce_o <= `ChipDisable;		    
		end else begin
		  wd_o <= wd_in;
			wreg_o <= wreg_in;
			wdata_o <= wdata_in;
			hi_o <= hi_in;
			lo_o <= lo_in;
			whilo_o <= whilo_in;		
			mem_we <= `WriteDisable;
			mem_addr_o <= 32'h00000000;
			mem_sel_o <= 4'b1111;
			mem_ce_o <= `ChipDisable;
			case (aluop_in)
			
				`EXE_LW_OP:		begin
					mem_addr_o <= mem_addr_in;
					mem_we <= `WriteDisable;
					wdata_o <= mem_data_in;
					mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;		
				end
				
				`EXE_SH_OP:		begin
					mem_addr_o <= mem_addr_in;
					mem_we <= `WriteEnable;
					mem_data_o <= {reg2_in[15:0],reg2_in[15:0]};
					mem_ce_o <= `ChipEnable;
					case (mem_addr_in[1:0])
						2'b00:	begin
							mem_sel_o <= 4'b1100;
						end
						2'b10:	begin
							mem_sel_o <= 4'b0011;
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase						
				end
				`EXE_SW_OP:		begin
					mem_addr_o <= mem_addr_in;
					mem_we <= `WriteEnable;
					mem_data_o <= reg2_in;
					mem_sel_o <= 4'b1111;	
					mem_ce_o <= `ChipEnable;		
				end
				`EXE_SWL_OP:		begin
					mem_addr_o <= {mem_addr_in[31:2], 2'b00};
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_in[1:0])
						2'b00:	begin						  
							mem_sel_o <= 4'b1111;
							mem_data_o <= reg2_in;
						end
						2'b01:	begin
							mem_sel_o <= 4'b0111;
							mem_data_o <= {zero32[7:0],reg2_in[31:8]};
						end
						2'b10:	begin
							mem_sel_o <= 4'b0011;
							mem_data_o <= {zero32[15:0],reg2_in[31:16]};
						end
						2'b11:	begin
							mem_sel_o <= 4'b0001;	
							mem_data_o <= {zero32[23:0],reg2_in[31:24]};
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase							
				end
				`EXE_SWR_OP:		begin
					mem_addr_o <= {mem_addr_in[31:2], 2'b00};
					mem_we <= `WriteEnable;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_in[1:0])
						2'b00:	begin						  
							mem_sel_o <= 4'b1000;
							mem_data_o <= {reg2_in[7:0],zero32[23:0]};
						end
						2'b01:	begin
							mem_sel_o <= 4'b1100;
							mem_data_o <= {reg2_in[15:0],zero32[15:0]};
						end
						2'b10:	begin
							mem_sel_o <= 4'b1110;
							mem_data_o <= {reg2_in[23:0],zero32[7:0]};
						end
						2'b11:	begin
							mem_sel_o <= 4'b1111;	
							mem_data_o <= reg2_in[31:0];
						end
						default:	begin
							mem_sel_o <= 4'b0000;
						end
					endcase											
				end 
				default:		begin
          
				end
			endcase							
		end    
	end      
			

endmodule