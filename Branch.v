`timescale 1ns / 1ps
module Branch(Bne,Beq,Blez,Bgtz,Bz,equal,CODE_16,rs,branch);
    input Bne,Beq,Blez,Bgtz,Bz,equal,CODE_16;   //RGY CODE_16 用来判断 BLTZ / BGEZ ，两指令OP相同, 这里最好还是在上面改一下接口比较好
    input [31:0]rs;    
    output branch;  
    
    assign branch = (Beq&equal) 
                        | (Bne&(~equal)) 
                        | Bz&(CODE_16&(~rs[31]))
                        | Bz&(~CODE_16&rs[31])
                        | (Blez&(rs[31]|(rs==0)))
                        | (Bgtz&(~rs[31])&(rs!=0)) ;
endmodule
