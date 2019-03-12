`timescale 1ns / 1ps

module MIPS_CPU(clr, Go, clk, Leddata, Count_all, Count_branch, Count_jmp, ShowRam, ShowRam_addr, ShowRam_data);
    input clr, clk, Go;
    input ShowRam;
    input [31:0]  ShowRam_addr;
    output [31:0] Leddata;
    output [31:0] Count_all, Count_branch, Count_jmp;
    output [31:0] ShowRam_data;
    
    //PC related
    wire enable;
    //RAM
    
    //---------IF------------------
    wire [31:0] PC_IF, IR_IF;

    //---------ID------------------
    wire [5:0] OP_ID, Func_ID;
    wire [31:0] PC_ID, IR_ID;
    wire [3:0] ALUOP_ID;


    wire  Memtoreg_ID, Memwrite_ID, Alu_src_ID, Regwrite_ID, Syscall_ID, Signedext_ID, Regdst_ID, Beq_ID, Bne_ID, Jr_ID, Jmp_ID, Jal_ID, Lui_ID, Bgtz_ID;
    wire [1:0] Mode_ID;
    wire Byte_ID;

    wire [4:0] R1_in_ID, R2_in_ID;
    wire [31:0]R1_out_ID, R2_out_ID;

    wire [4:0] WR_ID, Shamt_ID;
    wire [31:0] Imm_ID;

    wire [14:0] Control_Sig_EX_IN;
    wire [1:0] Forward_R1, Forward_R2;
    wire Load_use, Reg_related;

    //-----------------------------------EX---------------------------------------------------
    wire [31:0] PC_EX, IR_EX, R1_EX, R2_EX, Imm_EX;
    wire  [3:0] ALUOP_EX, Forward_EX;
    wire [4:0]  Shamt_EX, WR_EX;
    wire [14:0] Control_Sig_EX;
    
    wire  [2:0] WB_EX;
    wire  [3:0] MEM_EX;
    wire  Alu_src_EX, Syscall_EX;
    wire RegWrite_EX, Memtoreg_EX, Beq_EX, Bne_EX, Jr_EX, Jmp_EX, Jal_EX, Bgtz_EX;

    wire [31:0] R1_reloc, R2_reloc;
    wire [31:0] X, Y;
    wire [31:0] ALUres_EX;
    wire Equal_EX;
    wire Branch_out_EX, BJ_EX;
    wire [31:0] J_addr_EX, PC_Branch_EX; 
    wire [31:0] Leddata;
    wire Halt_EX;
    wire [9:0] Control_Sig_MEM_IN;
    //---------------------------------MEM---------------------------------------------------
    wire [31:0] PC_MEM, IR_MEM, ALUres_MEM, R2_MEM;
    wire [4:0]  WR_MEM;

    wire [9:0] Control_Sig_MEM;
    wire [2:0] WB_MEM;
    wire RegWrite_MEM, Memwrite_MEM, Byte_MEM, Jal_MEM, Halt_MEM, Syscall_MEM;
    wire [1:0] Mode_MEM;

    wire [31:0] MEMres, MEMD_MEM;
    wire [31:0] PC_plus_4_MEM;

    wire [5:0] Control_Sig_WB_IN;
    //---------------------------------WB----------------------------------------------
    wire [31:0] PC_WB, IR_WB, ALUres_WB, MEMD_WB;
    wire [4:0]  WR_WB;

    wire [5:0] Control_Sig_WB;
    wire  Regwrite_WB, Regdst_WB, Memtoreg_WB, Jal_WB, Halt_WB, Syscall_WB;

    wire [31:0] Din_WB, PC_next;



    //---------IF------------------
    //ROM
    ROM ROM_unit(PC_IF[11:0], IR_IF);
    // IF/ID
    IF_ID IF_ID_unit(clk, clr, Load_use ^ enable, BJ_EX, 
            PC_IF, IR_IF,
            PC_ID, IR_ID);

    //---------ID------------------
    assign OP_ID   = IR_ID[31:26];
    assign Func_ID = IR_ID[5:0];

    control control_unit(OP_ID, Func_ID, ALUOP_ID, Memtoreg_ID, Memwrite_ID, Alu_src_ID, Regwrite_ID, Syscall_ID, Signedext_ID, Regdst_ID, Beq_ID, Bne_ID, Jr_ID, Jmp_ID, 
        Jal_ID, Lui_ID, Bgtz_ID, Mode_ID, Byte_ID);

    //Regfiles related
    
    Path_ROM_to_Reg rom2reg_unit(IR_ID, Syscall_ID, R1_in_ID, R2_in_ID);
    RegFile regfile_unit (R1_in_ID, R2_in_ID, WR_WB, Din_WB, Regwrite_WB, clk, R1_out_ID, R2_out_ID);

    Path_Reg_to_EX reg2ex_unit(IR_ID, Regdst_ID, Jal_ID, Lui_ID, Signedext_ID, WR_ID, Imm_ID, Shamt_ID);

    Relocate_Forward forward_unit(OP_ID, Func_ID, WR_EX, WR_MEM, RegWrite_EX, RegWrite_MEM, R1_in_ID, R2_in_ID, Jal_EX, Memtoreg_EX,
                        Forward_R1, Forward_R2, Load_use, Reg_related);

    assign Control_Sig_EX_IN = {Regwrite_ID, Regdst_ID, Memtoreg_ID, Memwrite_ID, Mode_ID, Byte_ID, Beq_ID, Bne_ID, Bgtz_ID, Jr_ID, Jmp_ID, Jal_ID, Alu_src_ID, Syscall_ID};
    //-----------------------------------EX---------------------------------------------------
    ID_EX ID_EX_unit(clk, clr, enable , Load_use || BJ_EX, 
             PC_ID, IR_ID, R1_out_ID, R2_out_ID, ALUOP_ID, Shamt_ID, WR_ID, {Forward_R2, Forward_R1}, Imm_ID, Control_Sig_EX_IN,
             PC_EX, IR_EX, R1_EX, R2_EX,         ALUOP_EX, Shamt_EX, WR_EX, Forward_EX,               Imm_EX, Control_Sig_EX);

    assign  {WB_EX, MEM_EX, Beq_EX, Bne_EX, Bgtz_EX, Jr_EX, Jmp_EX, Jal_EX, Alu_src_EX, Syscall_EX} = Control_Sig_EX;

    Relocate_R1R2 relocate_unit(R1_EX, R2_EX, ALUres_MEM, Din_WB, PC_plus_4_MEM, Forward_EX, R1_reloc, R2_reloc);
    assign RegWrite_EX = WB_EX[2];
    assign Memtoreg_EX = WB_EX[0];

    //ALU related
    assign X = R1_reloc;
    assign Y = Alu_src_EX ? Imm_EX : R2_reloc;
    ALU alu_unit (X, Y, ALUOP_EX, Shamt_EX, ALUres_EX, , Equal_EX);

    //branch related
    Branch branch_unit(Bne_EX, Beq_EX, Bgtz_EX, Equal_EX, R1_reloc , Branch_out_EX);
    PC_Branch BJ_addr_unit(IR_EX, PC_EX, J_addr_EX, PC_Branch_EX);

    //Leddata display
    LedData Led_unit(Syscall_EX, R1_reloc, R2_reloc, clk, clr, Leddata);

    assign Halt_EX = Syscall_EX && ((R1_reloc == 50) || (R1_reloc == 10));
    assign BJ_EX = Branch_out_EX || Jmp_EX;

    assign Control_Sig_MEM_IN = {WB_EX, MEM_EX, Jal_EX, Halt_EX, Syscall_EX};
    EX_MEM EX_MEM_unit(clk, clr, enable, 0, 
         PC_EX,  IR_EX,  ALUres_EX,  R2_reloc,  WR_EX, Control_Sig_MEM_IN, 
         PC_MEM, IR_MEM, ALUres_MEM, R2_MEM,    WR_MEM, Control_Sig_MEM);
    //---------------------------------MEM---------------------------------------------------
    assign {WB_MEM, Memwrite_MEM, Mode_MEM, Byte_MEM, Jal_MEM, Halt_MEM, Syscall_MEM} = Control_Sig_MEM;
    assign RegWrite_MEM = WB_MEM[2];

    //PCrelated
    //RAM
    //for show RAM
    RAM RAM_unit(ALUres_MEM[11:0], R2_MEM, Mode_MEM, Memwrite_MEM, 1, clk, clr, 1, MEMres, ShowRam, ShowRam_addr, ShowRam_data);
    assign MEMD_MEM = Byte_MEM ? {24'h0, MEMres[7:0]}: MEMres;
    assign PC_plus_4_MEM = PC_MEM + 4;

    assign Control_Sig_WB_IN = {WB_MEM,  Jal_MEM, Halt_MEM, Syscall_MEM};
    MEM_WB MEM_WB_unit(clk, clr, enable, 0, 
         PC_MEM, IR_MEM, ALUres_MEM,  MEMD_MEM, WR_MEM, Control_Sig_WB_IN, 
         PC_WB,  IR_WB,  ALUres_WB,   MEMD_WB,  WR_WB,  Control_Sig_WB);
    //---------------------------------WB---------------------------------------------------
    assign {Regwrite_WB, Regdst_WB, Memtoreg_WB, Jal_WB, Halt_WB, Syscall_WB} = Control_Sig_WB;


    Data_to_Din data2din_unit(MEMD_WB, ALUres_WB, PC_WB+4, Jal_WB, Memtoreg_WB, Din_WB);

    PC PC_unit(PC_IF, Branch_out_EX, Jmp_EX, Jr_EX, R1_EX, J_addr_EX, PC_Branch_EX,  PC_next);
    register PC_R_unit (PC_next, Load_use ^ enable, clk, clr, PC_IF);

    PCenable PCenable_unit (Halt_WB, Go, enable);
    
    //计数
    Counter_circle counter_circle1(clk, clr, enable, Branch_out_EX, Jmp_EX, Count_all, Count_branch, Count_jmp);

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
