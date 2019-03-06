`timescale 1ns / 1ps
module Branch(Bne,Beq,Bgtz,equal,rs,branch);
    input Bne,Beq,Bgtz,equal;
    input [31:0]rs;    
    output branch;  
    
    assign branch = (Beq&equal) 
                        | (Bne&(~equal)) 
                        | (Bgtz&(~rs[31])&(rs!=0)) ;
endmodule
