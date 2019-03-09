`timescale 1ns / 1ps

module PC(
    input clk,
    input clr,
    input enable,
     input interrupt1,
    output reg interrupt1_running,//上升延是这个backup结束的时候置的
    input interrupt1_done,//op发现这个结束的指令的时候，置1
    input interrupt2,
    output reg interrupt2_running,
    input interrupt2_done,
    input interrupt3,
    output reg interrupt3_running,
    input interrupt3_done,
    //input [31:0] PC_in,//当来时进入
    //output reg [31:0] PC_out,//当OP对应结束标准的时候就返回
    output enable_userBackUp,enable_BackUp1,enable_BackUp2,
	input restore_userBackUp,restore_BackUp1,restore_BackUp2,
    input [31:0] PC_old,
    input [31:0] ext_18,
    input [25:0] jmp_dest,
    input branch, jmp, Jr,
    input [31:0] RS,
    output reg[31:0] PC_next,
    
    output [31:0] sequencial_addr);
   // PC_old, ext_18, jmp_dest, branch, jmp, Jr, RS, PC_next, sequencial_addr);
    wire   [31:0] jmp_addr;
    wire   [31:0] branch_addr;

    assign jmp_addr = {PC_old[31:28], jmp_dest, 2'b00};
    assign sequencial_addr = PC_old + 4;
    assign branch_addr = sequencial_addr + ext_18;
    
     wire[31:0] PC_store0,PC_store1,PC_store2;
     reg porcess_inter1,porcess_inter2,porcess_inter3;
     initial 
     begin
        interrupt1_running=0;
        interrupt2_running=0;
        interrupt3_running=0;
        PC_next = 0; 
     end

    assign enable_userBackUp=(~(interrupt1_running||interrupt2_running||interrupt3_running))&&(interrupt1||interrupt2||interrupt3);
    assign enable_BackUp1=((interrupt1_running))&&(interrupt2||interrupt3)&&(!interrupt2_running);
    assign enable_BackUp2=((interrupt2_running))&&(interrupt3);

    assign restore_userBackUp=interrupt1_done||
                            (interrupt2_done&&(!interrupt1_running))||
                            (interrupt3_done&&(!interrupt1_running)&&(!interrupt2_running));
    assign restore_BackUp1 = (interrupt2_done||interrupt3_done) && interrupt1_running;
    assign restore_BackUp2 = interrupt3_done && interrupt2_running;

             
    always @(posedge clk)
begin
    #3
     porcess_inter1 = (~(interrupt1_running||interrupt2_running||interrupt3_running))&&(interrupt1);
     porcess_inter2 =((~interrupt2_running))&&(interrupt2)&&(~interrupt3_running);
     porcess_inter3 = (interrupt3)&&(~interrupt3_running);
     //#3
end
    always @( posedge clk )
        begin
            if(clr == 1) begin
                 PC_next = 0;
                end
           
            if (porcess_inter1) begin
                PC_next = 32'h00000038;//中断位置
                #4
                interrupt1_running=1;

            end
            else if (porcess_inter2) begin
                PC_next = 32'h00000070;//中断位置
                #4
                interrupt2_running=1;

            end
            else if (porcess_inter3) begin
                PC_next = 32'h00000a8;//中断位置
                #4
                interrupt3_running=1;
            end
            else if (interrupt1_done) begin
                PC_next=PC_store0;
                #4                 
                interrupt1_running=0;

            end
            else if (interrupt2_done) begin
                PC_next= interrupt1_running ? PC_store1:PC_store0;
                #4                 
                interrupt2_running=0;

            end 
            else if(interrupt3_done)begin
                PC_next= interrupt2_running ? PC_store2:
                       (interrupt1_running ? PC_store1:
                                             PC_store0);
                #4                 
                interrupt3_running=0;

            end
            else begin
                PC_next =  (jmp == 1)? ((Jr == 1)?RS:jmp_addr) : ((branch == 1)? branch_addr:sequencial_addr) ;
            end

        end
//当inter1 返回的时候，就直接切回backup0

//当inter2 返回的时候，视当前的1结束了没有，切回backup0/1
//当inter3 返回的时候，视当前的2/1结束了没有，切回backup0/1/2
    //wire tmp1,tmp2,backup1_using,backup2_using;
    //0 backup of the user space
    backup backup0(clk,enable_userBackUp,PC_old,PC_store0);

    //1
    backup backup1(clk,enable_BackUp1,PC_old,PC_store1);

    //2
    backup backup2(clk,enable_BackUp2,PC_old,PC_store2);

    //3
    //backup backup3();

    //finish restore call
endmodule

module backup(// this will back up the whole CPU state
    input clk,
    input enable,
    //output reg running,// if turned 0, this will be resotred
    input [31:0] PC_old,//input of PC
    output [31:0] PC_store
    //input done
);
initial
begin
    //running=0;
    PC=0;
end
    reg[31:0] PC;
    assign PC_store = PC;
    always @(posedge enable)

    begin
        if (enable) begin
            PC=PC_old;
        end
//        if ( done) begin
//            running=0;
//        end
//        else begin
//            running=1;
//        end
    end
    
endmodule