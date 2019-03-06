`timescale 1ns / 1ps
module control(
    input [5:0] OP,
    input [5:0]FUNC,
    output wire  [3:0]ALU_OP,
    output wire  Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, Jal, Lui, Bgtz,
    output wire[1:0]Mode,
	output wire Byte // LBU 专门用的
    );
    reg SLL, SRA, SRL, ADD, ADDU, SUB, AND, OR, NOR, SLT, SLTU, JR, SYSCALL;
    reg R_type;
	wire J,JAL,BEQ,BNE,BGTZ,ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,LUI,LW,LBU,SW;
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
	end

	assign	Byte =  LBU ;
	assign  Mode = LBU ? 2'b00 : 2'b10; 	//LBU
	assign  Memtoreg = LW || LBU;
    assign  Memwrite = SW;
    assign  Alu_src = ADDI || ANDI || ADDIU || SLTI || ORI || LW || SW || LUI || SLTIU || LBU;
    assign  Regwrite = R_type || JAL || ADDI || ANDI || ADDIU || SLTI || ORI || LW || LUI || SLTIU || LBU;
    assign  Syscall = SYSCALL;
    assign  Signedext = ADDI || ADDIU || SLTI || LW || SW || LBU;
    assign  Regdst = R_type;
    assign  Beq = BEQ;
    assign  Bne = BNE;
    assign  Jr = JR;
    assign  Jmp = JAL || Jr || J;
    assign  Jal = JAL;
    assign  Lui = LUI;
    assign  Bgtz = BGTZ;
	assign  ALU_OP = (ADD || ADDU || ADDI || ADDIU || LW || SW || LBU ) ? 5 :
                (SLL || LUI) ? 0 :
                (SRA) ? 1 :
                (SRL) ? 2 :
                (SUB) ? 6 :
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
    assign  LUI = (OP == 15);
    assign  LW = (OP == 35);
    assign  LBU = (OP == 36);
    assign  SW = (OP == 43);

	always @(OP or FUNC or SYSCALL) begin	
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
		end		
		else begin
		SLL = (FUNC == 0);
		SRL = (FUNC == 2);
		SRA = (FUNC == 3);
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
