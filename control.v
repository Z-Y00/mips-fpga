`timescale 1ns / 1ps
//注意！ 每个人把不是自己的指令都删了！
module control(
    input [5:0] OP,
    input [5:0]FUNC,
    output wire  [3:0]ALU_OP,
    output wire  Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, Jal, Shift, Lui, Blez, Bgtz, Bz,
    output wire[1:0]Mode,
	output wire Byte, Signext2//LB , LBU, LH 专门用的，其他人可以删了
    );
    reg SLL, SRA, SRL, ADD, ADDU, SUB, AND, OR, NOR, SLT, SLTU, JR, SYSCALL, SLLV, SRLV, SRAV, SUBU, XOR, BLTZ, BGEZ;
    reg R_type;
	wire J,JAL,BEQ,BNE,BLEZ,BGTZ,ADDI,ADDIU,SLTI,SLTIU,ANDI,ORI,XORI,LUI,LB,LH,LW,LBU,LHU,SB,SW,SH;
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
		SRLV = 0; 
		SRAV = 0; 
		SUBU = 0; 
		XOR = 0; 
		BLTZ = 0; 
		BGEZ = 0;
	end

	assign	Byte = (LB || LBU) ;
	assign	Signext2 = (LB || LH) ;
	assign  Mode = (LB || LBU || SB)? 2'b00 :
                (LH || LHU || SH)? 2'b01 : 2'b10;
	assign  Memtoreg = LW || /*LB || LH ||*/ LBU || LHU;
    assign  Memwrite = SW || SB || SH;
    assign  Alu_src = ADDI || ANDI || ADDIU || SLTI || ORI || LW || SW || XORI || LUI || SLTIU || LB || LH || LBU || LHU || SB || SH;
    assign  Regwrite = R_type || JAL || ADDI || ANDI || ADDIU || SLTI || ORI || LW || XORI || LUI || SLTIU || LB || LH || LBU || LHU;
    assign  Syscall = SYSCALL;
    assign  Signedext = ADDI || ADDIU || SLTI || LW || SW || LB || LH || LBU || LHU || SB || SH;
    assign  Regdst = R_type;
    assign  Beq = BEQ;
    assign  Bne = BNE;
    assign  Jr = JR;
    assign  Jmp = JAL || Jr || J;
    assign  Jal = JAL;
    assign  Shift = SLLV || SRLV || SRAV;
    assign  Lui = LUI;
    assign  Blez = BLEZ;
    assign  Bgtz = BGTZ;
    assign  Bz = (OP == 1)? 1 : 0;
	assign  ALU_OP = (ADD || ADDU || ADDI || ADDIU || LW || SW || LB || LH || LBU || LHU || SB || SH) ? 5 :
                (SLL || SLLV || LUI) ? 0 :
                (SRA || SRAV) ? 1 :
                (SRL || SRLV) ? 2 :
                (SUB || SUBU) ? 6 :
                (AND || ANDI) ? 7 :
                (OR || ORI) ? 8 :
                (XOR || XORI) ? 9 :
                (SLT || SLTI) ? 11 :
                (SLTU || SLTIU) ? 12 : 
                NOR ? 10 : 13;

    assign  J = (OP == 2);
    assign  JAL = (OP == 3);
    assign  BEQ = (OP == 4);
    assign  BNE = (OP == 5);
    assign  BLEZ = (OP == 6);
    assign  BGTZ = (OP == 7);
    assign  ADDI = (OP == 8);
    assign  ADDIU = (OP == 9);
    assign  SLTI = (OP == 10);
    assign  SLTIU = (OP == 11);
    assign  ANDI = (OP == 12);
    assign  ORI = (OP == 13);
    assign  XORI = (OP == 14);
    assign  LUI = (OP == 15);
    assign  LB = (OP == 32);
    assign  LH = (OP == 33);
    assign  LW = (OP == 35);
    assign  LBU = (OP == 36);
    assign  LHU = (OP == 37);
    assign  SB = (OP == 40);
    assign  SH = (OP == 41);
    assign  SW = (OP == 43);

	always @(OP or FUNC) begin	
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
			SRLV = 0;
			SRAV = 0;
			SUBU = 0;
			XOR = 0;		
		end		
		else begin
		SLL = (FUNC == 0);
		SRL = (FUNC == 2);
		SRA = (FUNC == 3);
		SLLV = (FUNC == 4);
		SRLV = (FUNC == 6);
		SRAV = (FUNC == 7);
		JR = (FUNC == 8);
		SYSCALL = (FUNC == 12);
		ADD = (FUNC == 32);
		SUB = (FUNC == 34);
		SUBU = (FUNC == 35);
		ADDU = (FUNC == 33);
		AND = (FUNC == 36);
		OR = (FUNC == 37);
		XOR = (FUNC == 38);
		NOR = (FUNC == 39);
		SLT = (FUNC == 42);
		SLTU = (FUNC == 43);
		end

	end
endmodule
