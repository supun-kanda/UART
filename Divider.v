module Divider(
    input clkSys,rst,
    output reg clkOut
    );
    parameter baudRate = 9600;
    parameter freq_Sys = 125000000;
    localparam period = freq_Sys / baudRate; 
    localparam turn = period/2;
    
    reg [12:0] counter;
    
    always @(posedge clkSys)begin
        if (rst)begin
            counter<=0;
            clkOut<=0;
        end
        else if(counter==turn-1) begin
            counter<=0;
            clkOut<=~clkOut;
        end
        else counter<=counter+1;
    end
endmodule
