module getByte(
    input rst, clk, busy, send, [31:0] long,
    output reg over, reg [7:0] out, reg [15:0] address
    );
    parameter elements=17'd36;
    localparam elementCheck=elements+17'd4;
    parameter baseAddress=16'd0;
    reg [1:0] counter,state;
    reg [16:0] elementCounter;
    reg [31:0] data;
    
    always @(negedge clk)begin
        if(rst)begin
            counter<=2'b00;
            state<=2'b00;
            out<=8'd0;
            over<=0;
            elementCounter<=17'd0;
            address<=baseAddress;
            data<=32'd0;
        end
        else begin
            case(state)
                2'b00:if(~busy) state<=2'b01;
                2'b01:if(busy) state<=2'b10;
                2'b10:begin
                    if(elementCounter==elementCheck) over<=1;
                    else elementCounter<=elementCounter+17'd1;
                    counter<=counter+1;
                    state<=2'b00;
                    case(counter)
                        2'b00:out<=long[7:0];
                        2'b01:out<=long[15:8];
                        2'b10:out<=long[23:16];
                        2'b11:begin
                            out<=long[31:24];
                            address<=address+16'd1;
                        end
                        default: state<=2'b00; 
                    endcase
                end
                default: state<=2'b00;
            endcase
        end
    end
endmodule

