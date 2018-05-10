module Reciever(
    input rx, en, rst, clkSys,
    output reg busy, reg [7:0] byte
    //,output reg test
    );
    parameter baudRate = 9600;
    parameter freq_Sys = 125000000;
    localparam width = 8;
    localparam period = freq_Sys/baudRate;
    localparam turn = period/2;
    localparam idle = 2'b00, start=2'b01, loading=2'b10, stop=2'b11;
    wire clk;
    reg [1:0] state;
    reg [3:0] index;
    reg [7:0] temp;
    reg [13:0] counter;
    always @(posedge clkSys) begin
        if(rst) begin
            busy<=0;
            counter<=0;
            index<=0;
            byte<=8'd0;
            state<=idle;                        
        end
        else if(en) begin
            case(state)
                idle:begin
                    if(~rx) counter=counter+1;
                    else if(counter) counter=0;
                    if(counter==turn) state=start;
                end
                start:begin
                    counter<=0;
                    index<=0;
                    temp<=8'd0;
                    state<=loading;
                    busy<=1;
                end
                loading:begin 
                    if(counter == period-1) begin
                        counter<=0;
                        index<=index+1;
                        temp<=temp>>1;
                        temp<={rx,temp[7:1]};
                        if(index==(width-1)) state=stop;                                                
                    end
                    else counter=counter+1;
                end
                stop:begin
                    if(counter == period-1) begin
                        byte<=temp;
                        state<=idle;
                        busy<=0;
                    end
                    else counter=counter+1;;                     
                end
            endcase
        end
    end
endmodule
