`timescale 1ns / 1ps
module Branch(Bne,Beq,Bgtz,equal,rs,branch);
    input Bne,Beq,Bgtz,equal;
    input [31:0]rs;    
    output branch;
    
    assign branch = (Beq&equal) 
                        | (Bne&(~equal)) 
                        | (Bgtz&(~rs[31])&(rs!=0)) ;
                        
endmodule

module PC_Branch(INS, PC, J_addr, PC_branch);
	input [31:0] INS, PC;
	output [31:0] J_addr, PC_branch;

	wire [13:0]temp;
	wire [31:0] Imm;
    assign temp = INS[15] ? 14'hFFFF:14'h0;
    assign Imm = {temp, INS[15:0], 2'b0};

	assign J_addr = {PC[31:28], INS[25:0], 2'b0};
	assign PC_branch = Imm + PC + 4;
endmodule

