`timescale 1ns / 1ps

module PC(PC_old, ext_18, jmp_dest, branch, jmp, Jr, RS, PC_next, sequencial_addr);
    input [31:0] PC_old;
    input [31:0] ext_18;
    input [25:0] jmp_dest;
    input branch, jmp, Jr;
    input [31:0] RS;
    output reg[31:0] PC_next;
    
    output [31:0] sequencial_addr;
    wire   [31:0] jmp_addr;
    wire   [31:0] branch_addr;

    assign jmp_addr = {PC_old[31:28], jmp_dest, 2'b00};
    assign sequencial_addr = PC_old + 4;
    assign branch_addr = sequencial_addr + ext_18;
    
    always @(*)
    begin
    PC_next =  (jmp == 1)?jmp_addr:
                        (branch == 1)?branch_addr:
                             (Jr == 1)?RS:
                        sequencial_addr; 
    end

endmodule
