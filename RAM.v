module RAM #(parameter width = 32, length = 500, bits = 16)(
    input clk, we, [width-1:0] data_in, [bits-1:0] address,
    output [width-1:0] data_out
    );
    reg [width-1:0] MEMORY [length-1:0];
    always @(posedge clk) begin
        if(we) MEMORY[address]<=data_in;
    end
    assign data_out = MEMORY[address];
endmodule
