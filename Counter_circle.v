`timescale 1ns / 1ps

module Counter_circle(clk, clr, branch, jmp, Syscall, R1, Count_cycle, CountB, CountJ);
    input clk, clr, branch, jmp, Syscall;
    input [31:0]R1;
    output wire[31:0]Count_cycle, CountB, CountJ;
    wire running;
    assign running = (Syscall & (R1 == 34))|(~Syscall);

    Counter branch_c(branch, clk, clr, CountB);
    Counter jmp_c(jmp, clk, clr, CountJ);

    Counter all(running, clk, clr, Count_cycle);

endmodule

module Counter(running, clk, clr, count);
    input running,clk,clr;
    output reg [31:0] count;
    
    initial begin
        count = 0;
    end
    
    always @(posedge clk) begin
     if(clr) count=0;
      else  if(running) count=count+1;
    end
    
endmodule
