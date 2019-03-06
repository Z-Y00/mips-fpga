`timescale 1ns / 1ps

module MIPS_CPU(clr, Go, clk, Leddata, Count_all, Count_branch, Count_jmp);
    input clr, clk, Go;
    output [31:0] Leddata;
    output [31:0]Count_all, Count_branch, Count_jmp;
    
    //controler 
    wire Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, 
        Beq, Bne, Jr, Jmp, Jal, Lui, Bgtz;
    wire [1:0]Mode;
    wire [3:0] ALU_OP;

    //controler related
    wire [31:0] INS;
    wire [5:0] OP, Func;
    //Regfile related
    wire [4:0]R1_in, R2_in, W_in;
    wire [31:0]R1_out, R2_out, Din;
    wire [31:0] datamem;
    //ALU related
    wire [31:0] X, Y;
    wire [4:0] shamt;
    wire [31:0] Result1, Result2;
    wire Equal;
    wire [31:0]Imm;

    //branch related
    wire Branch_out;
    //PC related
    wire [31:0]PC, PC_ext18, PC_next_clk, PC_plus_4;
    wire [25:0] target;
    wire enable;

    wire Byte;
    //RAM
    

    //controler related
    assign OP = INS[31:26];
    assign Func = INS[5:0];
    control control_unit(OP, Func, ALU_OP, Memtoreg, Memwrite, Alu_src, Regwrite, Syscall, Signedext, Regdst, Beq, Bne, Jr, Jmp, 
        Jal, Lui, Bgtz, Mode, Byte);
    //Regfiles related
    Path_ROM_to_Reg rom2reg_unit(INS, Jal, Regdst, Syscall, R1_in, R2_in, W_in);
    RegFile regfile_unit (R1_in, R2_in, W_in, Din, Regwrite, clk, R1_out, R2_out);
    Data_to_Din din_unit (Byte, datamem, Result1, PC_plus_4, Jal, Memtoreg, Din);
    //ALU related
    assign X = R1_out;
    assign Y = Alu_src ? Imm : R2_out;
    shamt_input shamt_unit(INS, R1_out, Lui, shamt);
    ALU alu_unit (X, Y, ALU_OP, shamt, Result1, Result2, Equal);
    
    //branch related
    Branch branch_unit(Bne, Beq, Bgtz, Equal, R1_out , Branch_out);
    //PCrelated
    assign target = INS[25:0];

    PC PCUnit(PC, PC_ext18, target, Branch_out, Jmp, Jr, R1_out, PC_next_clk, PC_plus_4);
    PCenable PCenable_unit (R1_out, Syscall, Go, clk, enable);
    register PC_unit (PC_next_clk, enable,clk,clr,PC);
    //extern
    Extern extern_unit (INS, Signedext, Imm, PC_ext18);
    //计数
    Counter_circle counter_circle1(clk, clr, Branch_out, Jmp, Syscall, R1_out, Count_all, Count_branch, Count_jmp);
    //ROM
    ROM ROM1(PC[11:0], INS);
    //RAM
    RAM RAM1(Result1[11:0], R2_out, Mode, Memwrite, 1, clk, clr, 1, datamem);

    //Leddata display
    LedData Led1(Syscall, R1_out, R2_out, clk, clr, Leddata);
    // assign Leddata = INS;
endmodule


module register(Data_in,Enable,clk,clr,Data_out);
    parameter WIDTH = 32;
    // WIDTH:32
    input wire [WIDTH-1:0] Data_in;
    //clr posedge 异步 clear Data_out
    //Enable为0时,ignore clk
    //Enable为1时,clk posedge udpate Data_out
    input wire Enable;
    input wire clk;
    input wire clr;
    output reg [WIDTH-1:0] Data_out;
    
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
