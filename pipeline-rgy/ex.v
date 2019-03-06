`include "defines.v"

module ex(

	input wire										clr,
	
	input wire[`AluOpBus]         aluop_in,
	input wire[`AluSelBus]        alusel_in,
	input wire[`RegBus]           reg1_in,
	input wire[`RegBus]           reg2_in,
	input wire[`RegAddrBus]       wd_in,
	input wire                    wreg_in,
	input wire[`RegBus]           inst_in,
	
	input wire[`RegBus]           hi_in,
	input wire[`RegBus]           lo_in,

	input wire[`RegBus]           wb_hi_in,
	input wire[`RegBus]           wb_lo_in,
	input wire                    wb_whilo_in,
	
	input wire[`RegBus]           mem_hi_in,
	input wire[`RegBus]           mem_lo_in,
	input wire                    mem_whilo_in,

	input wire[`DoubleRegBus]     hilo_temp_in,
	input wire[1:0]               cnt_in,


	
	input wire[`RegBus]           link_address_in,
	input wire                    is_inn_delayslot_in,	
	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]						wdata_o,

	output reg[`RegBus]           hi_o,
	output reg[`RegBus]           lo_o,
	output reg                    whilo_o,
	
	output reg[`DoubleRegBus]     hilo_temp_o,
	output reg[1:0]               cnt_o,


	
	output wire[`AluOpBus]        aluop_o,
	output wire[`RegBus]          mem_addr_o,
	output wire[`RegBus]          reg2_o,

	output reg					  stallreq       			
	
);

	reg[`RegBus] logicout;
	reg[`RegBus] shiftres;
	reg[`RegBus] moveres;
	reg[`RegBus] arithmeticres;
	reg[`DoubleRegBus] mulres;	
	reg[`RegBus] HI;
	reg[`RegBus] LO;
	wire[`RegBus] reg2_in_mux;
	wire[`RegBus] reg1_in_not;	
	wire[`RegBus] result_sum;
	wire ov_sum;
	wire reg1_eq_reg2;
	wire reg1_lt_reg2;
	wire[`RegBus] opdata1_mult;
	wire[`RegBus] opdata2_mult;
	wire[`DoubleRegBus] hilo_temp;
	reg[`DoubleRegBus] hilo_temp1;
	reg stallreq_for_madd_msub;			

    
  assign aluop_o = aluop_in;
  
  
  assign mem_addr_o = reg1_in + {{16{inst_in[15]}},inst_in[15:0]};

 
  assign reg2_o = reg2_in;
			
	always @ (*) begin
		if(clr == 1) begin
			logicout <= 32'h00000000;
		end else begin
			case (aluop_in)
				`EXE_OR_OP:			begin
					logicout <= reg1_in | reg2_in;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_in & reg2_in;
				end
				`EXE_NOR_OP:		begin
					logicout <= ~(reg1_in |reg2_in);
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_in ^ reg2_in;
				end
				default:				begin
					logicout <= 32'h00000000;
				end
			endcase
		end    
	end      

	always @ (*) begin
		if(clr == 1) begin
			shiftres <= 32'h00000000;
		end else begin
			case (aluop_in)
				`EXE_SLL_OP:			begin
					shiftres <= reg2_in << reg1_in[4:0] ;
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg2_in >> reg1_in[4:0];
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg2_in[31]}} << (6'd32-{1'b0, reg1_in[4:0]})) 
												| reg2_in >> reg1_in[4:0];
				end
				default:				begin
					shiftres <= 32'h00000000;
				end
			endcase
		end    
	end      

	assign reg2_in_mux = ((aluop_in == `EXE_SUB_OP) || (aluop_in == `EXE_SUBU_OP) ||
											 (aluop_in == `EXE_SLT_OP) ) 
											 ? (~reg2_in)+1 : reg2_in;

	assign result_sum = reg1_in + reg2_in_mux;										 

	assign ov_sum = ((!reg1_in[31] && !reg2_in_mux[31]) && result_sum[31]) ||
									((reg1_in[31] && reg2_in_mux[31]) && (!result_sum[31]));  
									
	assign reg1_lt_reg2 = ((aluop_in == `EXE_SLT_OP)) ?
												 ((reg1_in[31] && !reg2_in[31]) || 
												 (!reg1_in[31] && !reg2_in[31] && result_sum[31])||
			                   (reg1_in[31] && reg2_in[31] && result_sum[31]))
			                   :	(reg1_in < reg2_in);
  
  assign reg1_in_not = ~reg1_in;
							
	always @ (*) begin
		if(clr == 1) begin
			arithmeticres <= 32'h00000000;
		end else begin
			case (aluop_in)
				`EXE_SLT_OP, `EXE_SLTU_OP:		begin
					arithmeticres <= reg1_lt_reg2 ;
				end
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP:		begin
					arithmeticres <= result_sum; 
				end
				`EXE_SUB_OP, `EXE_SUBU_OP:		begin
					arithmeticres <= result_sum; 
				end		
				`EXE_CLZ_OP:		begin
					arithmeticres <= reg1_in[31] ? 0 : reg1_in[30] ? 1 : reg1_in[29] ? 2 :
													 reg1_in[28] ? 3 : reg1_in[27] ? 4 : reg1_in[26] ? 5 :
													 reg1_in[25] ? 6 : reg1_in[24] ? 7 : reg1_in[23] ? 8 : 
													 reg1_in[22] ? 9 : reg1_in[21] ? 10 : reg1_in[20] ? 11 :
													 reg1_in[19] ? 12 : reg1_in[18] ? 13 : reg1_in[17] ? 14 : 
													 reg1_in[16] ? 15 : reg1_in[15] ? 16 : reg1_in[14] ? 17 : 
													 reg1_in[13] ? 18 : reg1_in[12] ? 19 : reg1_in[11] ? 20 :
													 reg1_in[10] ? 21 : reg1_in[9] ? 22 : reg1_in[8] ? 23 : 
													 reg1_in[7] ? 24 : reg1_in[6] ? 25 : reg1_in[5] ? 26 : 
													 reg1_in[4] ? 27 : reg1_in[3] ? 28 : reg1_in[2] ? 29 : 
													 reg1_in[1] ? 30 : reg1_in[0] ? 31 : 32 ;
				end
				`EXE_CLO_OP:		begin
					arithmeticres <= (reg1_in_not[31] ? 0 : reg1_in_not[30] ? 1 : reg1_in_not[29] ? 2 :
													 reg1_in_not[28] ? 3 : reg1_in_not[27] ? 4 : reg1_in_not[26] ? 5 :
													 reg1_in_not[25] ? 6 : reg1_in_not[24] ? 7 : reg1_in_not[23] ? 8 : 
													 reg1_in_not[22] ? 9 : reg1_in_not[21] ? 10 : reg1_in_not[20] ? 11 :
													 reg1_in_not[19] ? 12 : reg1_in_not[18] ? 13 : reg1_in_not[17] ? 14 : 
													 reg1_in_not[16] ? 15 : reg1_in_not[15] ? 16 : reg1_in_not[14] ? 17 : 
													 reg1_in_not[13] ? 18 : reg1_in_not[12] ? 19 : reg1_in_not[11] ? 20 :
													 reg1_in_not[10] ? 21 : reg1_in_not[9] ? 22 : reg1_in_not[8] ? 23 : 
													 reg1_in_not[7] ? 24 : reg1_in_not[6] ? 25 : reg1_in_not[5] ? 26 : 
													 reg1_in_not[4] ? 27 : reg1_in_not[3] ? 28 : reg1_in_not[2] ? 29 : 
													 reg1_in_not[1] ? 30 : reg1_in_not[0] ? 31 : 32) ;
				end
				default:				begin
					arithmeticres <= 32'h00000000;
				end
			endcase
		end
	end

  
	assign opdata1_mult = (((aluop_in == `EXE_MUL_OP) || (aluop_in == `EXE_MULT_OP) ||
													(aluop_in == `EXE_MADD_OP) || (aluop_in == `EXE_MSUB_OP))
													&& (reg1_in[31] == 1'b1)) ? (~reg1_in + 1) : reg1_in;

  assign opdata2_mult = (((aluop_in == `EXE_MUL_OP) || (aluop_in == `EXE_MULT_OP) ||
													(aluop_in == `EXE_MADD_OP) || (aluop_in == `EXE_MSUB_OP))
													&& (reg2_in[31] == 1'b1)) ? (~reg2_in + 1) : reg2_in;	

  assign hilo_temp = opdata1_mult * opdata2_mult;																				

	always @ (*) begin
		if(clr == 1) begin
			mulres <= {32'h00000000,32'h00000000};
		end else if ((aluop_in == `EXE_MULT_OP) || (aluop_in == `EXE_MUL_OP) ||
									(aluop_in == `EXE_MADD_OP) || (aluop_in == `EXE_MSUB_OP))begin
			if(reg1_in[31] ^ reg2_in[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end else begin
			  mulres <= hilo_temp;
			end
		end else begin
				mulres <= hilo_temp;
		end
	end

  
	always @ (*) begin
		if(clr == 1) begin
			{HI,LO} <= {32'h00000000,32'h00000000};
		end else if(mem_whilo_in == `WriteEnable) begin
			{HI,LO} <= {mem_hi_in,mem_lo_in};
		end else if(wb_whilo_in == `WriteEnable) begin
			{HI,LO} <= {wb_hi_in,wb_lo_in};
		end else begin
			{HI,LO} <= {hi_in,lo_in};			
		end
	end	

  always @ (*) begin
    stallreq = stallreq_for_madd_msub;
  end

  
	always @ (*) begin
		if(clr == 1) begin
			hilo_temp_o <= {32'h00000000,32'h00000000};
			cnt_o <= 2'b00;
			stallreq_for_madd_msub <= 0;
		end else begin
			
			case (aluop_in) 
				`EXE_MADD_OP, `EXE_MADDU_OP:		begin
					if(cnt_in == 2'b00) begin
						hilo_temp_o <= mulres;
						cnt_o <= 2'b01;
						stallreq_for_madd_msub <= 1;
						hilo_temp1 <= {32'h00000000,32'h00000000};
					end else if(cnt_in == 2'b01) begin
						hilo_temp_o <= {32'h00000000,32'h00000000};						
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_in + {HI,LO};
						stallreq_for_madd_msub <= 0;
					end
				end
				`EXE_MSUB_OP, `EXE_MSUBU_OP:		begin
					if(cnt_in == 2'b00) begin
						hilo_temp_o <=  ~mulres + 1 ;
						cnt_o <= 2'b01;
						stallreq_for_madd_msub <= 1;
					end else if(cnt_in == 2'b01)begin
						hilo_temp_o <= {32'h00000000,32'h00000000};						
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_in + {HI,LO};
						stallreq_for_madd_msub <= 0;
					end				
				end
				default:	begin
					hilo_temp_o <= {32'h00000000,32'h00000000};
					cnt_o <= 2'b00;
					stallreq_for_madd_msub <= 0;				
				end
			endcase
		end
	end	


	
	always @ (*) begin
		if(clr == 1) begin
	  	moveres <= 32'h00000000;
	  end else begin
	   moveres <= 32'h00000000;
	   case (aluop_in)
	   	`EXE_MFHI_OP:		begin
	   		moveres <= HI;
	   	end
	   	`EXE_MFLO_OP:		begin
	   		moveres <= LO;
	   	end
	   	`EXE_MOVZ_OP:		begin
	   		moveres <= reg1_in;
	   	end
	   	`EXE_MOVN_OP:		begin
	   		moveres <= reg1_in;
	   	end
	   	default : begin
	   	end
	   endcase
	  end
	end	 

 always @ (*) begin
	 wd_o <= wd_in;
	 	 	 	
	 if(((aluop_in == `EXE_ADD_OP) || (aluop_in == `EXE_ADDI_OP) || 
	      (aluop_in == `EXE_SUB_OP)) && (ov_sum == 1'b1)) begin
	 	wreg_o <= `WriteDisable;
	 end else begin
	  wreg_o <= wreg_in;
	 end
	 
	 case ( alusel_in ) 
	 	`EXE_RES_LOGIC:		begin
	 		wdata_o <= logicout;
	 	end
	 	`EXE_RES_SHIFT:		begin
	 		wdata_o <= shiftres;
	 	end	 	
	 	`EXE_RES_MOVE:		begin
	 		wdata_o <= moveres;
	 	end	 	
	 	`EXE_RES_ARITHMETIC:	begin
	 		wdata_o <= arithmeticres;
	 	end
	 	`EXE_RES_MUL:		begin
	 		wdata_o <= mulres[31:0];
	 	end	 	
	 	`EXE_RES_JUMP_BRANCH:	begin
	 		wdata_o <= link_address_in;
	 	end	 	
	 	default:					begin
	 		wdata_o <= 32'h00000000;
	 	end
	 endcase
 end	

	always @ (*) begin
		if(clr == 1) begin
			whilo_o <= `WriteDisable;
			hi_o <= 32'h00000000;
			lo_o <= 32'h00000000;		
		end else if((aluop_in == `EXE_MULT_OP) || (aluop_in == `EXE_MULTU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= mulres[63:32];
			lo_o <= mulres[31:0];			
		end else if((aluop_in == `EXE_MADD_OP) || (aluop_in == `EXE_MADDU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= hilo_temp1[63:32];
			lo_o <= hilo_temp1[31:0];
		end else if((aluop_in == `EXE_MSUB_OP) || (aluop_in == `EXE_MSUBU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= hilo_temp1[63:32];
			lo_o <= hilo_temp1[31:0];		
		end else if(aluop_in == `EXE_MTHI_OP) begin
			whilo_o <= `WriteEnable;
			hi_o <= reg1_in;
			lo_o <= LO;
		end else if(aluop_in == `EXE_MTLO_OP) begin
			whilo_o <= `WriteEnable;
			hi_o <= HI;
			lo_o <= reg1_in;
		end else begin
			whilo_o <= `WriteDisable;
			hi_o <= 32'h00000000;
			lo_o <= 32'h00000000;
		end				
	end			

endmodule