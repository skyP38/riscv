module top(
    input CLK, 
    input H_SYNC, V_SYNC,
    output [4:0]V_R, 
    output [5:0]V_G,
    output [4:0]V_B,
);

reg [2:0]pix = 3'b111;
assign V_R = {5{pix[1]}};
assign V_G = {6{pix[2]}};
assign V_B = {5{pix[0]}};

wire vga_clk;
pll pll_inst(.inclk0(CLK), .c0(vga_clk));

wire [9:0]x;
wire [9:0]y;


//SHOW_IMAGE
// vga_sync vga_sync(vga_clk, H_SYNC, V_SYNC, x, y);

// always @(posedge vga_clk) begin
//     if ((x < 640) && (y < 480)) begin
//         if (x % 80 == 0)
//             pix <= pix - 3'b1;
//     end
//         else pix <= 0;
// end

//SHOW_TEXT

reg [12:0]vrom_addr;
wire [2:0]vrom_q;
wire [9:0]x_fwd = x + 1;

rom #(13, 3, "rom.txt") vrom(vrom_addr, vga_clk, vrom_q);
vga_sync vga_sync(vga_clk, H_SYNC, V_SYNC, x, y);

always @(*) begin
    vrom_addr = x_fwd[9:3] + y[9:3] * 80;
    rgb = ((x < 640) && (y < 480)) ? vrom_q : 3'b0;
end

endmodule