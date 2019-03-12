`timescale 1ns / 1ps

module PC(PC_old, Branch_out, Jmp, Jr, R1, J_addr, PC_Branch,  PC_next);
    input [31:0] PC_old;
    input [31:0] R1, PC_Branch, J_addr;
    input Branch_out, Jmp, Jr;
    output reg[31:0] PC_next;

    always @(*)
    begin
        PC_next =  (Jmp == 1)? ((Jr == 1)? R1 : J_addr) : ((Branch_out == 1)? PC_Branch : PC_old + 4) ;	
    end

endmodule
