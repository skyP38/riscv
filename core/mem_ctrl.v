module mem_ctrl(
    input clk, 
    input [31:0]addr,
    input [31:0]data,
    input we,

    output reg [31:0] q,
    output reg [15:0]display = 16'b0
);

wire [15:0] mmio_data;
wire mmio_we;
wire [31:0] ram_data;
wire [9:0] ram_addr;
wire ram_we;
wire [31:0] ram_q;

ram ram(
    .address(ram_addr),
    .clock(clk),
    .data(ram_data),
    .wren(ram_we),
    .q(ram_q)
);

always @(posedge clk) begin
    if (we) begin
        $display("[%h] <- %h", addr, data);
        if (addr == 32'h0)
            display <= data[15:0]
    end
end

always @(*) begin
    q = 32'b0;
    mmio_data = 16'b0;
    mmio_we = 1'b0;
    ram_data = 32'b0;
    ram_addr = 10'b0;
    ram_we = 1'b0;

    casez (addr)
        32'h20: begin // MMIO
            mmio_data = data[15:0];
            mmio_we = we;
        end
        32'b1_????_????_????: begin  // RAM
            ram_addr = addr[11:2];
            ram_data = data;
            ram_we = we;
            q = ram_q;
        end
        default: 
            q = 32'b0;
    endcase
end

endmodule