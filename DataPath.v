`timescale 1ns / 1ps

module PCenable(R1_out, Syscall, Go, clk, enable);
    input [31:0]R1_out;
    input Syscall, Go, clk;
    output enable;
    assign enable = (R1_out == 32'h00000022) | ~Syscall | Go ;

endmodule

module Path_ROM_to_Reg(INS, Jal, Regdst, Syscall, R1, R2, W);
    input [31:0]INS;
    input Jal, Regdst;
    input Syscall;
    output [4:0]R1, R2, W;

    assign R1 = (Syscall == 1)?5'b00010 : INS[25:21];
    assign R2 = (Syscall == 1)?5'b00100 : INS[20:16];
    assign W = (Regdst == 0)?((Jal == 0)?(INS[20:16]):(5'b11111)):((Jal == 0)?(INS[15:11]):(5'b00000));
endmodule

module shamt_input(INS, R1_out, Lui, shamt);
    input [31:0] INS;
    input [31:0] R1_out;
    input  Lui;
    output [4:0]shamt;
    assign shamt = (Lui == 1) ? 16 : INS [10:6];
endmodule

module Extern(INS, Signedext, imm, PC_ext18);
    input [31:0]INS;
    input Signedext;
    output [31:0]imm, PC_ext18;
    wire [15:0]temp;
    assign temp = INS[15]?16'hFFFF:16'h0;
    assign imm = (Signedext == 1)?{temp, INS[15:0]}:{16'h0, INS[15:0]};
    assign PC_ext18 = {temp, INS[15:0]}<<2;
endmodule

module Data_to_Din(Byte, mem, Result1, PC_plus_4, Jal, Memtoreg, Din);
    input Byte;
    input [31:0] mem, Result1, PC_plus_4;
    input Jal, Memtoreg;
    output [31:0] Din;
    wire [1:0] ByteSelect ;

    assign ByteSelect = Result1[1:0];

    assign Din = (Memtoreg == 1)?mem:
                (Jal == 1)?PC_plus_4:
                (Byte == 1)? {24'h0, mem[7:0]}:Result1;

endmodule
