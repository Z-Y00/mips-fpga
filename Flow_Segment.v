`timescale 1ns / 1ps

module IF_ID (clk, clr, Enable, Bubble, PC_IN, IR_IN, PC_OUT, IR_OUT);
	input clk, clr, Bubble, Enable;
	input [31:0] PC_IN, IR_IN;
	output wire [31:0] PC_OUT, IR_OUT;

	reg [31:0] PC_R, IR_R;

	initial begin
		PC_R = 0;
		IR_R = 0;
	end

	assign PC_OUT = PC_R;
	assign IR_OUT = IR_R;

	always @(posedge clk)begin
		if(clr) begin
			PC_R = 0;
			IR_R = 0;
		end
		else if(Enable) begin
			PC_R = Bubble? 0:PC_IN;
			IR_R = Bubble? 0:IR_IN;
		end else begin
			PC_R = PC_R;
			IR_R = IR_R;
		end
	end
endmodule

module ID_EX (clk, clr, Enable, Bubble, 
			 PC_IN,  IR_IN,  R1_IN,  R2_IN,  ALUOP_IN,  Shamt_IN,  WR_IN,  Forward_IN,  Imm_IN,  Control_Sig_IN,
			 PC_OUT, IR_OUT, R1_OUT, R2_OUT, ALUOP_OUT, Shamt_OUT, WR_OUT, Forward_OUT, Imm_OUT, Control_Sig_OUT);
	input clk, clr, Bubble, Enable;
	input 		[31:0] PC_IN,  IR_IN,  R1_IN,  R2_IN, Imm_IN;
	input 		[3:0]  ALUOP_IN, Forward_IN;
	input 		[4:0]  Shamt_IN, WR_IN;
	input 		[14:0] Control_Sig_IN;

	output wire [31:0] PC_OUT,  IR_OUT,  R1_OUT,  R2_OUT, Imm_OUT;
	output wire [3:0]  ALUOP_OUT, Forward_OUT;
	output wire [4:0]  Shamt_OUT, WR_OUT;
	output wire [14:0] Control_Sig_OUT;

	reg [31:0] PC_R,  IR_R,  R1_R,  R2_R, Imm_R;
	reg [3:0]  ALUOP_R, Forward_R;
	reg [4:0]  Shamt_R, WR_R;
	reg [14:0] Control_Sig_R;

	initial begin
		PC_R = 0;
	  	IR_R = 0;
	  	R1_R = 0;
	  	R2_R = 0;
	  	ALUOP_R = 0;
	  	Shamt_R = 0;
	  	WR_R = 0;
	  	Forward_R = 0;
	  	Imm_R = 0;
	  	Control_Sig_R = 0;
	end

	assign PC_OUT = PC_R ;
	assign IR_OUT = IR_R ;
	assign R1_OUT = R1_R ;
	assign R2_OUT = R2_R ;
	assign ALUOP_OUT = ALUOP_R ;
	assign Shamt_OUT = Shamt_R ;
	assign WR_OUT = WR_R ;
	assign Forward_OUT = Forward_R ;
	assign Imm_OUT = Imm_R ;
	assign Control_Sig_OUT = Control_Sig_R ;

	always @(posedge clk)begin
		if(clr) begin
			PC_R = 0;
			IR_R = 0;
			R1_R = 0;
			R2_R = 0;
			ALUOP_R = 0;
			Shamt_R = 0;
			WR_R = 0;
			Forward_R = 0;
			Imm_R = 0;
			Control_Sig_R = 0;
		end
		else if(Enable) begin
			PC_R = Bubble? 0 : PC_IN;
			IR_R = Bubble? 0 : IR_IN;
			R1_R = Bubble? 0 : R1_IN;
			R2_R = Bubble? 0 : R2_IN;
			ALUOP_R = Bubble? 0 : ALUOP_IN;
			Shamt_R = Bubble? 0 : Shamt_IN;
			WR_R = Bubble? 0 : WR_IN;
			Forward_R = Bubble? 0 : Forward_IN;
			Imm_R = Bubble? 0 : Imm_IN;
			Control_Sig_R = Bubble? 0 : Control_Sig_IN;
		end else begin
			PC_R = PC_R;
			IR_R = IR_R;
			R1_R = R1_R;
			R2_R = R2_R;
			ALUOP_R = ALUOP_R;
			Shamt_R = Shamt_R;
			WR_R = WR_R;
			Forward_R = Forward_R;
			Imm_R = Imm_R;
			Control_Sig_R = Control_Sig_R;
		end
	end
endmodule

module EX_MEM (clk, clr, Enable, Bubble, 
			 PC_IN,  IR_IN,  ALURS_IN,  R2_IN,    WR_IN,  Control_Sig_IN,
			 PC_OUT, IR_OUT, ALURS_OUT, R2_OUT,   WR_OUT, Control_Sig_OUT);

	input clk, clr, Bubble, Enable;
	input 		[31:0] PC_IN,  IR_IN,  ALURS_IN,  R2_IN;
	input 		[4:0]  WR_IN;
	input 		[9:0] Control_Sig_IN;

	output wire [31:0] PC_OUT,  IR_OUT,  ALURS_OUT, R2_OUT;
	output wire [4:0]   WR_OUT;
	output wire [9:0] Control_Sig_OUT;

	reg [31:0] PC_R,  IR_R,  ALURS_R,  R2_R;
	reg [4:0]  WR_R;
	reg [9:0] Control_Sig_R;

	initial begin
		PC_R = 0;
		IR_R = 0;
		ALURS_R = 0;
		R2_R = 0;
		WR_R = 0;
		Control_Sig_R = 0;
	end

	assign PC_OUT = PC_R;
	assign IR_OUT = IR_R;
	assign ALURS_OUT = ALURS_R;
	assign R2_OUT = R2_R;
	assign WR_OUT = WR_R;
	assign Control_Sig_OUT = Control_Sig_R;

	always @(posedge clk)begin
		if(clr) begin
			PC_R = 0;
			IR_R = 0;
			ALURS_R = 0;
			R2_R = 0;
			WR_R = 0;
			Control_Sig_R = 0;
		end
		else if(Enable) begin
			PC_R = Bubble? 0 : PC_IN;
			IR_R = Bubble? 0 : IR_IN;
			ALURS_R = Bubble? 0 : ALURS_IN;
			R2_R = Bubble? 0 : R2_IN;
			WR_R = Bubble? 0 : WR_IN;
			Control_Sig_R = Bubble? 0 : Control_Sig_IN;
		end else begin
			PC_R = PC_R;
			IR_R = IR_R;
			ALURS_R = ALURS_R;
			R2_R = R2_R;
			WR_R = WR_R;
			Control_Sig_R = Control_Sig_R;
		end
	end
endmodule

module MEM_WB (clk, clr, Enable, Bubble, 
			 PC_IN,  IR_IN,  ALURS_IN,  MEMD_IN,    WR_IN,  Control_Sig_IN,
			 PC_OUT, IR_OUT, ALURS_OUT, MEMD_OUT,   WR_OUT, Control_Sig_OUT);

	input clk, clr, Bubble, Enable;
	input 		[31:0] PC_IN,  IR_IN,  ALURS_IN,  MEMD_IN;
	input 		[4:0]  WR_IN;
	input 		[5:0] Control_Sig_IN;

	output wire [31:0] PC_OUT,  IR_OUT,  ALURS_OUT, MEMD_OUT;
	output wire [4:0]   WR_OUT;
	output wire [5:0] Control_Sig_OUT;

	reg [31:0] PC_R,  IR_R,  ALURS_R,  MEMD_R;
	reg [4:0]  WR_R;
	reg [5:0] Control_Sig_R;

	initial begin
		PC_R = 0;
		IR_R = 0;
		ALURS_R = 0;
		MEMD_R = 0;
		WR_R = 0;
		Control_Sig_R = 0;
	end
	
	assign PC_OUT = PC_R;
	assign IR_OUT = IR_R;
	assign ALURS_OUT = ALURS_R;
	assign MEMD_OUT = MEMD_R;
	assign WR_OUT = WR_R;
	assign Control_Sig_OUT = Control_Sig_R;

	always @(posedge clk)begin
		if(clr) begin
			PC_R = 0;
			IR_R = 0;
			ALURS_R = 0;
			MEMD_R = 0;
			WR_R = 0;
			Control_Sig_R = 0;
		end
		else if(Enable) begin
			PC_R = Bubble? 0 : PC_IN;
			IR_R = Bubble? 0 : IR_IN;
			ALURS_R = Bubble? 0 : ALURS_IN;
			MEMD_R = Bubble? 0: MEMD_IN;
			WR_R = Bubble? 0 : WR_IN;
			Control_Sig_R = Bubble? 0 : Control_Sig_IN;
		end else begin
			PC_R = PC_R;
			IR_R = IR_R;
			ALURS_R = ALURS_R;
			WR_R = WR_R;
			Control_Sig_R = Control_Sig_R;
		end
	end
endmodule