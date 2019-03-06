`timescale 1ns / 1ps

module MIPS_CPU(clr, Go, clk, Leddata, Count_cycle, Count_branch, Count_jmp, mem_probe,probe);
    input clr, clk, Go;
    output [31:0] Leddata;
    output [31:0]Count_cycle, Count_branch, Count_jmp;
    input [31:0] probe;
    //control接出
    wire Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, 
        Beq, Bne, Jr, Jmp, Jal, Shift,  Bgtz;
    wire [1:0]Mode;
    wire [3:0] ALU_OP;

    wire [31:0] instr;
    wire [5:0] OP, Func;

    //Regfile
    wire [4:0]R1_in, R2_in, W_in;
    wire [31:0]R1_out, R2_out, Din;
    wire [31:0] mem;
    output wire [31:0] mem_probe ;


    //ALU 
    wire [31:0]X, Y;
    wire [4:0] shamt;
    wire [31:0] AluResult;
    wire Equal;
    wire [31:0]imm;

    //branch 
    wire Branch_out;
    
    //PC
    reg  [31:0]PC;
    wire [31:0] ext18, PC_next, PC_plus_4;
    wire [25:0] target;
    wire enable;

    //控制器
    assign OP = instr[31:26];
    assign Func = instr[5:0];
    control control1(OP, Func, ALU_OP, Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, 
        Jal, Shift,   Bgtz,  Mode);

    //Regfile
    assign R1_in = (Syscall == 1)?5'b00010 : instr[25:21];
    assign R2_in = (Syscall == 1)?5'b00100 : instr[20:16];
    assign W_in = (Regdst == 0)?((Jal == 0)?(instr[20:16]):(5'b11111)):((Jal == 0)?(instr[15:11]):(5'b00000)); // 5'b00000 stands for error
    RegFile regfile1 (R1_in, R2_in, W_in, Din, Regwrite, clk, R1_out, R2_out);
    Data_to_Din din1 ( mem, AluResult, PC_plus_4, Jal, Memtoreg, Din);

    //ALU 
    assign X = R1_out;
    assign Y = Alu_src ? imm : R2_out;
    ALU alu1 (X, Y, ALU_OP, shamt, AluResult, Equal);

    //shamt
    assign shamt = (Shift == 1) ? R1_out : instr [10:6];

    //branch 
    Branch branch1(Bne, Beq,  Bgtz,  Equal, R1_out , Branch_out);
    //PC
    assign target = instr[25:0];

    PC PCUnit(PC, ext18, target, Branch_out, Jmp, Jr, R1_out, PC_next, PC_plus_4);

    //PC enable
    assign enable = (R1_out == 32'h00000022) | ~Syscall | Go ;

        always @(posedge clr or posedge clk) begin
        if(clr == 1) begin
            PC = 0;
        end
        else if(enable == 1) begin
            PC = PC_next;
        end
    end

    //extern
    Extern extern1 (instr, Signedext, imm, ext18);

    Counter_circle counter_circle1(clk, clr, Branch_out, Jmp, Syscall, R1_out, Count_cycle, Count_branch, Count_jmp);

    ROM ROM1(PC[11:0], instr);

    RAM RAM1(AluResult[11:0], R2_out, Mode, Memwrite, clk, clr,  mem, mem_probe,probe);

    //display
    LedData led(Syscall, R1_out, R2_out, clk, clr, Leddata);

endmodule

module Extern(instr, Signedext, imm, ext18);
    input [31:0]instr;
    input Signedext;
    output [31:0]imm, ext18;
    wire [15:0]high;
    assign high = instr[15]?16'hFFFF:16'h0;
    assign imm = (Signedext == 1)?{high, instr[15:0]}:{16'h0, instr[15:0]};
    assign ext18 = {high, instr[15:0]}<<2;
endmodule

module Data_to_Din(mem, AluResult, PC_plus_4, Jal, Memtoreg, Din);
    input [31:0] mem, AluResult, PC_plus_4;
    input Jal, Memtoreg;
    output [31:0] Din;
    assign Din = (Memtoreg == 1)?mem:
                (Jal == 1)?PC_plus_4:
                AluResult;

endmodule
