// RAM(32bit)
// input [9:0] Addr, [31:0] data_in, [1:0] Mode, str (write enable),
// sel (select signal, set to 1 bydefault), clk, clr, ld (write enable, set to 1 by default)
// output data_out[31:0]


`timescale 1ns / 1ps
//RGY 这个的ld看起来似乎没有用到？ 要不干掉

module RAM (Addr, data_in, Mode, memWrite, sel, clk, clr, ld, data_out);
    parameter 
        byte_mode       = 2'b00,
        dbyte_mode      = 2'b01,
        word_mode       = 2'b10;

    input [31:0] data_in;
    input [11:0] Addr;
    input [1:0] Mode;
    input memWrite, sel, clk, clr, ld;
    output wire [31:0] data_out;
    
    reg [12:0] i;
    reg [31:0] mem [2**8-1:0];

    wire [31:0] select;

    wire [11:0]index;

    assign index = Addr[11:2];
    assign select = (sel == 1)?mem[index]:32'h0000_0000;

    // this would init the RAM
    initial begin
        for(i = 0; i <= 2**8-1; i = i+1) begin
            mem[i] = 32'h0000;
        end 
    end
    
    // always @(posedge clr)
    // begin
    //        for(i = 0; i <= 2**10-1; i = i+1) begin
    //             mem[i] = 32'h0000;
    //         end 
    // end

    always @(posedge clk or posedge clr)
    begin
        if(clr)begin
            for(i = 0; i <= 2**8-1; i = i+1) begin
                mem[i] = 32'h0000;
            end 
        end
        else begin
            if(sel) begin
                if(memWrite) begin
                    case(Mode)
                        dbyte_mode: begin
                            if(Addr[1:1]==0) begin
                                    mem[index] [15:0] = data_in[15:0];
                                end //注意，这里的可能不是所以人都需要，如果不需要半字访问/存储的就自己删了
                                else begin
                                    mem[index] [31:16] = data_in[15:0];
                            end
                        end
                        word_mode: begin
                            mem[index] = data_in;
                        end
                        byte_mode: begin
                            case(Addr[1:0])
                                     0: begin mem[index] [7:0] = data_in[7:0];     end
                                     1: begin mem[index] [15:8] = data_in[7:0];    end
                                     2: begin mem[index] [23:16] = data_in[7:0];   end
                                     3: begin mem[index] [31:24] = data_in[7:0];   end
                                    default: begin mem[index] [7:0] = data_in[7:0];   end // TODO
                            endcase
                        end
                        default: begin
                            // do nothing
                        end
                    endcase
                end
                else begin
                    // do nothing
                end
            end
            else begin
                // do nothing
            end
        end
    end
    wire [15:0] out_31_16;
    wire [7:0] out_7_0, out_15_8; 
//DEBUG 完成后删除这部分
    // assign out_7_0 = (Mode == dbyte_mode)?((Addr[1] == 1)?select[23:16]:select[7:0]):
    //                     (Mode == byte_mode)?
    //                     (
    //                         (Addr[1:0] == 2'b00)?select[7:0]:
    //                         (
    //                             (Addr[1:0] == 2'b01)?select[15:8]:
    //                             (
    //                                 (Addr[1:0] == 2'b10)?select[23:16]:
    //                                 (
    //                                     select[31:24]
    //                                 )
    //                             )
    //                         )
    //                     ):select[7:0];

    assign out_7_0 = (Mode == byte_mode)?(
                 (Addr[1:0] == 2'b00)?select[7:0]:
                            ((Addr[1:0] == 2'b01)?select[15:8]:
                                ((Addr[1:0] == 2'b10)?select[23:16]:select[31:24]))):
                            ((Mode == dbyte_mode)?
                            ((Addr[1] == 0)?select[7:0]:select[23:16]):select[7:0]);

    assign out_15_8 = (Mode == byte_mode)?(8'b0):
                            ((Mode == dbyte_mode)?
                            ((Addr[1] == 1)?select[31:24]:select[15:8]):select[15:8]);

    assign out_31_16 = (Mode == word_mode)?select[31:16]:16'b0;
    assign data_out = {out_31_16, out_15_8, out_7_0};
endmodule