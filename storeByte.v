module storeByte (
    input clk, busy, rst, [7:0] byte,
    output reg EN,over, reg [31:0] out, reg [15:0] address
    );
    parameter elements=17'd36;
    localparam elementCheck=elements-17'd1;
    parameter baseAdress=16'd0;
    reg flag;
    reg [1:0] counter,state;
    reg [16:0] elementCounter;
    reg [31:0] temp;
    always @(posedge clk)begin
        if (rst) begin
            counter<=2'b00;
            state<=2'b00;
            out<=32'd0;
            over<=0;
            temp<=32'd0;
            address<=baseAdress;
            elementCounter<=17'd0;
            flag<=0;
        end
        else begin
            case(state)
                2'b00:if(busy) state<=2'b01;
                2'b01:if(~busy) state<=2'b10;
                2'b10:begin
                    counter<=counter+2'b01;
                    if(elementCounter==elementCheck) flag<=1;
                    else elementCounter<=elementCounter+17'd1;
                    if(counter==2'b11) state<=2'b11;
                    else state<=2'b00;
                    case(counter)
                        2'b00: temp<={temp[31:8],byte};
                        2'b01: temp<={temp[31:16],byte,temp[7:0]};
                        2'b10: temp<={temp[31:24],byte,temp[15:0]};
                        2'b11: begin
                            out<={byte,temp[23:0]};
                            address<=address+16'd1;
                        end
                        default: state<=2'b00;
                    endcase
                end
                2'b11:begin 
                    state<=2'b00;
                    if(flag) over<=1;
                end
            endcase
        end
    end
    always @(negedge clk)begin
        if(~rst & ~over & state==2'b11) EN<=1;
        else EN<=0;
    end
endmodule
