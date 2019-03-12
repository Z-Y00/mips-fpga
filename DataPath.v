`timescale 1ns / 1ps

module PCenable(halt, Go, enable);
    input halt, Go;
    output enable;
    assign enable = ~halt | Go ;
endmodule

module Path_ROM_to_Reg(INS, Syscall, R1, R2);
    input [31:0]INS;
    input Syscall;
    output [4:0]R1, R2;

    assign R1 = (Syscall == 1)?5'b00010 : INS[25:21];
    assign R2 = (Syscall == 1)?5'b00100 : INS[20:16];
endmodule

module Path_Reg_to_EX(INS, RegDst, JAL, LUI, SignedExt, WR, Imm, Shamt);
    input [31:0]INS;
    input RegDst, JAL, LUI, SignedExt;  
    output [4:0] WR;
    output [31:0] Imm;
    output [4:0] Shamt;

    wire [4:0] rt, rd;
    wire [15:0]temp;

    assign rt = INS[20:16];
    assign rd = INS[15:11];
    assign WR = JAL ? 31 : (RegDst ? rd : rt);
    assign temp = INS[15]?16'hFFFF:16'h0;
    assign Imm = SignedExt ?{temp, INS[15:0]}:{16'h0, INS[15:0]};
    assign Shamt = LUI ? 16 : INS[10:6];
endmodule

module Relocate_R1R2(R1, R2, ALUres_MEM, Din_WB, PC_plus_4_MEM, Forward, R1_reloc, R2_reloc);
    input [31:0] R1, R2, ALUres_MEM, Din_WB, PC_plus_4_MEM;
    input [3:0] Forward;
    output reg [31:0] R1_reloc, R2_reloc;

    always @(*) begin
        case (Forward[1:0])
            0: R1_reloc = R1;
            1: R1_reloc = ALUres_MEM;
            2: R1_reloc = Din_WB;
            3: R1_reloc = PC_plus_4_MEM;
        endcase 
    end

    always @(*) begin
        case (Forward[3:2])
            0: R2_reloc = R2;
            1: R2_reloc = ALUres_MEM;
            2: R2_reloc = Din_WB;
            3: R2_reloc = PC_plus_4_MEM;
        endcase 
    end
endmodule

module Data_to_Din(MEMD, ALUres, PC_plus_4, Jal, Memtoreg, Din);
    input [31:0] MEMD, ALUres, PC_plus_4;
    input Jal, Memtoreg;
    output [31:0] Din;

    assign Din = (Memtoreg == 1)?MEMD:
                (Jal == 1)?PC_plus_4:
                ALUres;

endmodule
