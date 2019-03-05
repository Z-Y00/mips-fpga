`timescale 1ns / 1ps
module LedData(Syscall, R1, R2, clk, clr, data);
    input Syscall, clk, clr;
    input [31:0] R1, R2;
    output reg [31:0]data;
    wire show;
    assign show = Syscall & (R1 == 34);
    
    initial begin
        data = 0;
    end
    
    always @(posedge clr or posedge clk) begin
		if(clr == 1) begin
			data = 0;
		end
		else if(show == 1) begin
			data = R2;
		end
	end

endmodule
