`timescale 1ns / 1ps

module Counter(running, clk, clr, count);
    input running,clk,clr;
    output reg [31:0] count;
    
    initial begin
        count = 0;
    end
    
    always @(posedge clk) begin
        if(running) count=count+1;
    else if(clr) count=0;
    end
    
endmodule
