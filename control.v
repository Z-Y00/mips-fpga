`timescale 1ns / 1ps
module control(
    input [5:0] OP,
    input [5:0]FUNC,
    output wire  [3:0]ALU_OP,
    output wire  Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, Jal, Shift,  Bgtz, 
    output wire[1:0]Mode
    );
    reg SLL, SRA, SRL, ADD, ADDU, SUB, AND, OR, NOR, SLT, SLTU, JR, SYSCALL, SLLV;
    reg R_type;
	wire J,JAL,BEQ,BNE,BLEZ,BGTZ,ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,LW,SW,SH;
    initial begin
		SLL = 0; 
		SRA = 0; 
		SRL = 0; 
		ADD = 0;
		ADDU = 0; 
		SUB = 0; 
		AND = 0; 
		OR = 0; 
		NOR = 0; 
		SLT = 0; 
		SLTU = 0; 
		JR = 0; 
		SYSCALL = 0;  
		SLLV = 0; 
	end

	assign  Mode = (SH)? 2'b01 : 2'b10;
	assign  Memtoreg = LW ;
    assign  Memwrite = SW || SH;
    assign  Alu_src = ADDI || ANDI || ADDIU || SLTI || ORI || LW || SW || SLTIU || SH;
    assign  Regwrite = R_type || JAL || ADDI || ANDI || ADDIU || SLTI || ORI || LW || SLTIU ;
    assign  Syscall = SYSCALL;
    assign  Signedext = ADDI || ADDIU || SLTI || LW || SW || SH;
    assign  Regdst = R_type;
    assign  Beq = BEQ;
    assign  Bne = BNE;
    assign  Jr = JR;
    assign  Jmp = JAL || Jr || J;
    assign  Jal = JAL;
    assign  Shift = SLLV ;
    assign  Bgtz = BGTZ;
	assign  ALU_OP = (ADD || ADDU || ADDI || ADDIU || LW || SW ||SH) ? 5 :
                (SLL || SLLV ) ? 0 :
                (SRA ) ? 1 :
                (SRL ) ? 2 :
                (SUB ) ? 6 :
                (AND || ANDI) ? 7 :
                (OR || ORI) ? 8 :
                (SLT || SLTI) ? 11 :
                (SLTU || SLTIU) ? 12 : 
                NOR ? 10 : 13;

    assign  J = (OP == 2);
    assign  JAL = (OP == 3);
    assign  BEQ = (OP == 4);
    assign  BNE = (OP == 5);
    assign  BGTZ = (OP == 7);
    assign  ADDI = (OP == 8);
    assign  ADDIU = (OP == 9);
    assign  SLTI = (OP == 10);
    assign  SLTIU = (OP == 11);
    assign  ANDI = (OP == 12);
    assign  ORI = (OP == 13);
    assign  LW = (OP == 35);
    assign  SH = (OP == 41);
    assign  SW = (OP == 43);

	always @(OP or FUNC) begin	
		# 3
        if (OP == 0 && SYSCALL == 0)begin
            R_type = 1;
        end
        else R_type = 0;
	end
	
	always @(OP or FUNC) begin
		if(OP!=0)begin
			SLL = 0;
			SRA = 0;
			SRL = 0;
			ADD = 0;
			ADDU = 0;
			SUB = 0;
			AND = 0;
			OR = 0;
			NOR = 0;
			SLT = 0;
			SLTU = 0;
			JR = 0;
			SYSCALL = 0;
			SLLV = 0;
		end		
		else begin
		SLL = (FUNC == 0);
		SRL = (FUNC == 2);
		SRA = (FUNC == 3);
		SLLV = (FUNC == 4);
		JR = (FUNC == 8);
		SYSCALL = (FUNC == 12);
		ADD = (FUNC == 32);
		SUB = (FUNC == 34);
		ADDU = (FUNC == 33);
		AND = (FUNC == 36);
		OR = (FUNC == 37);
		NOR = (FUNC == 39);
		SLT = (FUNC == 42);
		SLTU = (FUNC == 43);
		end

	end
endmodule
