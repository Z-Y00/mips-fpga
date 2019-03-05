`timescale 1ns / 1ps

module MIPS_CPU(clr, Go, clk, Leddata, Count_cycle, Count_branch, Count_jmp);
    input clr, clk, Go;
    output [31:0] Leddata;
    output [31:0]Count_cycle, Count_branch, Count_jmp;
    
    //control接出的控制信号
    wire Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, 
        Beq, Bne, Jr, Jmp, Jal, Shift,  Bgtz;
    wire [1:0]Mode;
    wire [3:0] ALU_OP;
    //控制器
    wire [31:0] instr;
    wire [5:0] OP, Func;
    //Regfile
    wire [4:0]R1_in, R2_in, W_in;
    wire [31:0]R1_out, R2_out, Din;
    wire [31:0] mem;
    //ALU 
    wire [31:0]X, Y;
    wire [4:0] shamt;
    wire [31:0] Result1, Result2;

    wire Equal;
    wire [31:0]imm;
    //branch 
    wire Branch_out;
    //PC
    wire [31:0]PC, ext18, PC_next_clk, PC_plus_4;
    wire [25:0] target;
    wire enable;

    wire Byte, Half, Signext2;
    
    //控制器
    assign OP = instr[31:26];
    assign Func = instr[5:0];
    control control1(OP, Func, ALU_OP, Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, 
        Jal, Shift,   Bgtz,  Mode, Byte, Signext2);

    //Regfile
    Path_ROM_to_Reg rom_to_reg1(instr, Jal, Regdst, Syscall, R1_in, R2_in, W_in);
    RegFile regfile1 (R1_in, R2_in, W_in, Din, Regwrite, clk, R1_out, R2_out);
    Data_to_Din din1 (Byte, Signext2, mem, Result1, PC_plus_4, Jal, Memtoreg, Din);

    //ALU 
    assign X = R1_out;
    assign Y = Alu_src ? imm : R2_out;
    shamt_input shamt1(instr, R1_out, Shift,  shamt);
    ALU alu1 (X, Y, ALU_OP, shamt, Result1, Result2, Equal);

    //branch 
    Branch branch1(Bne, Beq,  Bgtz,  Equal, R1_out , Branch_out);
    //PC
    assign target = instr[25:0];

    PC PCUnit(PC, ext18, target, Branch_out, Jmp, Jr, R1_out, PC_next_clk, PC_plus_4);
    PCenable PCenable1 (R1_out, Syscall, Go, clk, enable);
    register PC1 (PC_next_clk, enable,clk,clr,PC);
    //extern
    Extern extern1 (instr, Signedext, imm, ext18);

    Counter_circle counter_circle1(clk, clr, Branch_out, Jmp, Syscall, R1_out, Count_cycle, Count_branch, Count_jmp);

    ROM ROM1(PC[11:0], instr);

    RAM RAM1(Result1[11:0], R2_out, Mode, Memwrite, clk, clr,  mem);


    //Leddata display
    LedData Led1(Syscall, R1_out, R2_out, clk, clr, Leddata);
    // assign Leddata = instr;
endmodule


module register(Data_in,Enable,clk,clr,Data_out);
    parameter WIDTH = 32;
    //WIDTH:参数，在实例化时，可以使用此参数扩展Data的位宽
    input wire [31:0] Data_in;
    //clr 上升沿 异步清零Data_out
    //使能端为0时,忽略时钟
    //使能端为1时,时钟上升沿更新Data_out
    input wire Enable;
    input wire clk;
    input wire clr;
    output reg [31:0] Data_out;
    
    initial begin
        Data_out = 0;
    end
    
    always @(posedge clr or posedge clk) begin
        if(clr == 1) begin
            Data_out = 0;
        end
        else if(Enable == 1) begin
            Data_out = Data_in;
        end
    end
endmodule

module PCenable(R1_out, Syscall, Go, clk, enable);
    input [31:0]R1_out;
    input Syscall, Go, clk;
    output enable;
    assign enable = (R1_out == 32'h00000022) | ~Syscall | Go ;

endmodule

module Path_ROM_to_Reg(instr, Jal, Regdst, Syscall, R1, R2, W);
    input [31:0]instr;
    input Jal, Regdst;
    input Syscall;
    output [4:0]R1, R2, W;

    assign R1 = (Syscall == 1)?5'b00010 : instr[25:21];
    assign R2 = (Syscall == 1)?5'b00100 : instr[20:16];
    assign W = (Regdst == 0)?((Jal == 0)?(instr[20:16]):(5'b11111)):((Jal == 0)?(instr[15:11]):(5'b00000));
    // 5'b00000 stands for error
endmodule

module shamt_input(instr, R1_out, shift, shamt);
    input [31:0] instr;
    input [31:0] R1_out;
    input shift;
    output [4:0]shamt;
    assign shamt = (shift == 1) ? R1_out :
                    instr [10:6];
endmodule

module Extern(instr, Signedext, imm, ext18);
    input [31:0]instr;
    input Signedext;
    output [31:0]imm, ext18;
    wire [15:0]temp;
    assign temp = instr[15]?16'hFFFF:16'h0;
    assign imm = (Signedext == 1)?{temp, instr[15:0]}:{16'h0, instr[15:0]};
    assign ext18 = {temp, instr[15:0]}<<2;
endmodule

module Data_to_Din(Byte, Signext2, mem, Result1, PC_plus_4, Jal, Memtoreg, Din);
    input Byte,Signext2;
    input [31:0] mem, Result1, PC_plus_4;
    input Jal, Memtoreg;
    output [31:0] Din;
    wire [15:0]temp1;
    wire [23:0]temp2;
    assign temp1 = mem[15]?16'hFFFF:16'h0;
    assign temp2 = mem[7]?24'hFFFFFF:24'h0;
    assign Din = (Memtoreg == 1)?mem:
                (Jal == 1)?PC_plus_4:
                (Signext2 == 1)?((Byte == 1)? {temp2, mem[7:0]}:{temp1, mem[15:0]}):
                Result1;

endmodule
