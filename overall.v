module overall(
    input in, send, rst, enTX, enRX, clk,
    output out, busyRX, busyTX, overRX, overTX
    );
    parameter baudRate = 921600;
    parameter freq_Sys = 125000000;
    parameter elements= 17'd65536;
    
    wire [7:0] stored,split;
    wire send_approved,glitch,clkOut,step_send;
    wire [31:0] store,return;
    wire [15:0] addressA,addressB,address;
    
    assign send_approved = overRX & (~overTX) & (~busyTX) & step_send;
    assign address = (overRX)?addressB:addressA;
    
    //RAM m1(.address(address), .clk(clk), .data_in(store), .data_out(return), .we(EN));
    design_RAM_wrapper r1(.BRAM_PORTA_addr(address[15:0]), .BRAM_PORTA_clk(clk), .BRAM_PORTA_din(store), .BRAM_PORTA_dout(return), .BRAM_PORTA_we(EN));
    
    Reciever #(.freq_Sys(freq_Sys), .baudRate(baudRate)) rx(.clkSys(clk), .rx(in), .en(enRX), .rst(rst), .busy(busyRX), .byte(stored));
    Transmittor #(.freq_Sys(freq_Sys), .baudRate(baudRate)) tx(.byte(split), .clk(clkOut), .rst(rst), .en(enTX), .send(send_approved), .busy(busyTX), .out(out) );
    Divider #(.freq_Sys(freq_Sys), .baudRate(baudRate)) d(.clkOut(clkOut), .clkSys(clk), .rst(rst));
    storeByte #(.elements(elements)) s(.clk(clk), .busy(busyRX), .rst(rst), .byte(stored), .EN(EN), .out(store), .address(addressA), .over(overRX));
    getByte #(.elements(elements)) gb(.rst(rst), .clk(clk), .send(send), .busy(busyTX), .long(return), .out(split), .address(addressB), .over(overTX));
    unit_step u(.clk(clk), .signal(send), .rst(rst), .step(step_send));
    
endmodule
