module control(
    input [31:0]instr,

    output reg [11:0]imm12,
    output reg rf_we, 
    output reg alu_op,
    output reg mem_we,
    
    output reg branch
);

wire [6:0]opcode = instr[6:0];
wire [2:0]funct3 = instr[14:12];

always @(*) begin
    rf_we = 1'b0;
    alu_op = 1'b0;
    imm12  = 12'b0;
    mem_we = 1'b0;
    branch = 1'b0;

    casez ({funct5, funct2, funct3, opcode})
        17'b?????_??_000_0010011: begin //ADDI
            rf_we = 1'b1;
            alu_op = 1'b1;
            imm12 = instr[31:20];
        end
        17'b?????_??_???_0000011: begin //LW
            imm12 = instr[31:20];
            rf_we = (funct == 3'b010);
            has_imm = 1'b1;
            is_load = 1'b1;
        end
        17'b?????_??_???_0100011: begin //SW
            // alu_op = 1'b1;
            imm12 = {instr[31:25], instr[11:7]};
            has_imm = 1'b1;
            mem_we = (funct3 == 3'b010);
        end
        17'b?????_??_001_1100011: begin // BNE
            imm12 = {instr[31], instr[31], instr[7], instr[30:25], instr{11:9}};
            alu_op = 3'b100;
            branch = 1'b1;
        end
    default: ;
    endcase
end

endmodule