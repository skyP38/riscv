// конфигурация Галуа
// 2 -> 1 -> xor -> 0
// ^          ^     | 
// | - - - - -|- < --  
// p(x) = x^3 + x + 1    
module lfsr(
    input clk, 
    output reg [2:0]w
);

initial w = 3'b001;
wire feedback = w[0];

always @(posedge clk) begin
    w[2] <= feedback;
    w[1] <= w[2];
    w[0] <= w[1] ^ feedback;
end

endmodule