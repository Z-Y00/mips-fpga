`timescale 1ns / 1ps

module Counter_circle(clk, clr, branch, jmp, Syscall, R1, Count_cycle, CountB, CountJ);
    input clk, clr, branch, jmp, Syscall;
    input [31:0]R1;
    output wire[31:0]Count_cycle, CountB, CountJ;
    wire running;
    assign running = (Syscall & (R1 == 34))|(~Syscall);

    Counter branch(branch, clk, clr, CountB);
    Counter jmp(jmp, clk, clr, CountJ);
    Counter all(running, clk, clr, Count_cycle);

endmodule
