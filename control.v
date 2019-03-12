`timescale 1ns / 1ps
module control(
    input [5:0] OP,
    input [5:0]FUNC,
    output wire  [3:0]ALU_OP,
    output wire  Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, Jal, Shift,  Bgtz, 
    output wire[1:0]Mode
    );
    reg SLL, SRA, SRL, ADD, ADDU, SUB, AND, OR, NOR, SLT, SLTU, JR, SYSCALL, SRLV, SUBU;
    reg R_type;
	wire J,JAL,BEQ,BNE,BGTZ,ADDI,ADDIU,SLTI,ANDI,ORI,LW,SW,SB;
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
		SRLV = 0; 
	end

	assign  Mode = (SB)? 2'b00 : 2'b10;
	assign  Memtoreg = LW ;
    assign  Memwrite = SW || SB;
    assign  Alu_src = ADDI || ANDI || ADDIU || SLTI || ORI || LW || SW || SB;
    assign  Regwrite = R_type || JAL || ADDI || ANDI || ADDIU || SLTI || ORI || LW;
    assign  Syscall = SYSCALL;
    assign  Signedext = ADDI || ADDIU || SLTI || LW || SW || SB || BNE || Beq || SUBU || BGTZ;
    assign  Regdst = R_type;
    assign  Beq = BEQ;
    assign  Bne = BNE;
    assign  Jr = JR;
    assign  Jmp = J;
    assign  Jal = JAL;
    assign  Shift = SRLV ;
    assign  Bgtz = BGTZ;
	assign  ALU_OP = (ADD || ADDU || ADDI || ADDIU || LW || SW ||SB) ? 5 :
                (SLL) ? 0 :
                (SRA ) ? 1 :
                (SRL || SRLV) ? 2 :
                (SUB || SUBU) ? 6 :
                (AND || ANDI) ? 7 :
                (OR || ORI) ? 8 :
                (SLT || SLTI) ? 11 :
                (SLTU) ? 12 : 
                NOR ? 10 : 13;

    assign  J = (OP == 2);
    assign  JAL = (OP == 3);
    assign  BEQ = (OP == 4);
    assign  BNE = (OP == 5);
    assign  BGTZ = (OP == 7);
    assign  ADDI = (OP == 8);
    assign  ADDIU = (OP == 9);
    assign  SLTI = (OP == 10);
    assign  ANDI = (OP == 12);
    assign  ORI = (OP == 13);
    assign  LW = (OP == 35);
    assign  SB = (OP == 40);
    assign  SW = (OP == 43);

	always @(*) begin	
		// # 3
        if (OP == 0 && SYSCALL == 0)begin
            R_type = 1;
        end
        else R_type = 0;
	end
	
	always @(*) begin
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
			SRLV = 0;
			SUBU = 0;
		end		
		else begin
		SLL = (FUNC == 0);
		SRL = (FUNC == 2);
		SRA = (FUNC == 3);
		SRLV = (FUNC == 6);
		JR = (FUNC == 8);
		SYSCALL = (FUNC == 12);
		ADD = (FUNC == 32);
		SUB = (FUNC == 34);
		ADDU = (FUNC == 33);
		SUBU = (FUNC == 35);
		AND = (FUNC == 36);
		OR = (FUNC == 37);
		NOR = (FUNC == 39);
		SLT = (FUNC == 42);
		SLTU = (FUNC == 43);
		end

	end
endmodule
