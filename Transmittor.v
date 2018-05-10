module Transmittor(
    input [7:0] byte, wire rst, en, send, clk,
    output reg busy, out
    );
    parameter baudRate = 9600;
    parameter freq_Sys = 125000000;
    localparam width = 8;
    //localparam period = freq_Sys/baudRate;
    //localparam turn = period/2;
    localparam idle = 2'b00, start=2'b01, sending=2'b10, stop=2'b11;
    
    //wire clk;
    reg [1:0] state;
    reg [2:0] index;
    reg [7:0] stored;
    always @(posedge clk or posedge rst ) begin
        if(rst) begin
            busy<=0;
            index<=0;
            state<=idle;
            stored<=8'd0;   
            out<=1;                     
        end
        else if(en) begin
            case(state)
                idle:begin
                    out <= 1;
                    if(send & ~busy) state <= start;
                end
                start:begin
                    out<=0;
                    state<=sending;
                    stored<=byte;
                    busy<=1;
                    index<=3'b0;
                end
                sending:begin 
                    if(index==width-1) state<=stop;
                    out<=stored[index];
                    index<=index+1;
                end
                stop:begin
                    out<=1;
                    busy<=0;
                    state<=idle;           
                end
            endcase
        end
    end
endmodule