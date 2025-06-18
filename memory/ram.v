module ram(
    input [9:0]address, 
    input clock,
    input [31:0]data,
    input wren,
    output [31:0]q
);

reg [31:0] mem [0:1023];

always @(posedge clock) begin
    if (wren) begin
        mem[address] <= data;
    end
    q <= mem[address];
end

endmodule