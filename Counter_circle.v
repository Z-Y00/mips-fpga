`timescale 1ns / 1ps

module Counter_circle(clk, clr, enable, branch, jmp, Count_cycle, CountB, CountJ);
    input clk, clr, enable, branch, jmp;
    output wire[31:0]Count_cycle, CountB, CountJ;

    Counter branch_c(branch, clk, clr, CountB);
    Counter jmp_c(jmp, clk, clr, CountJ);
    Counter all(enable, clk, clr, Count_cycle);

endmodule
