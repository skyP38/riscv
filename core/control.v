module control(
    input [31:0]instr,

    output reg [11:0]imm12,
    output reg rf_we, 
    output reg [2:0]alu_op,
    output reg has_imm,
    output reg mem_we,
    output reg branch,
    output reg is_load
);

wire [6:0]opcode = instr[6:0];
wire [2:0]funct3 = instr[14:12];
wire [1:0]funct2 = instr[26:25];
wire [4:0]funct5 = instr[31:27];

always @(*) begin
    rf_we = 1'b0;
    alu_op = 1'b0;
    imm12  = 12'b0;
    has_imm = 1'b0;
    mem_we = 1'b0;
    branch = 1'b0;
    is_load = 1'b0;

    casez ({funct5, funct2, funct3, opcode})
        17'b?????_??_000_0010011: begin //ADDI
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "ADDI", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b001;
            imm12 = instr[31:20];
            has_imm = 1'b1;
        end
        17'b?????_??_100_0010011: begin //XORI
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "XORI", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b100;
            imm12 = instr[31:20];
            has_imm = 1'b1;
        end
        17'b?????_??_110_0010011: begin //ORI
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "ORI", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b110;
            imm12 = instr[31:20];
            has_imm = 1'b1;
        end
        17'b?????_??_111_0010011: begin //ANDI
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "ANDI", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b111;
            imm12 = instr[31:20];
            has_imm = 1'b1;
        end
        17'b00000_00_000_0010011: begin //ADD
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "ADD", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b001;
            has_imm = 1'b0;
        end
        17'b00000_00_100_0010011: begin //XOR
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "XOR", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b100;
            has_imm = 1'b0;
        end
        17'b00000_00_110_0010011: begin //OR
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "OR", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b110;
            has_imm = 1'b0;
        end
        17'b00000_00_111_0010011: begin //AND
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "AND", funct5, funct2, funct3, opcode);
            rf_we = 1'b1;
            alu_op = 3'b111;
            has_imm = 1'b0;
        end
        17'b?????_??_???_0000011: begin //LW
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "LW", funct5, funct2, funct3, opcode);
            imm12 = instr[31:20];
            rf_we = 1'b1;
            has_imm = 1'b1;
            is_load = 1'b1;
        end
        17'b?????_??_010_0100011: begin //SW
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "SW", funct5, funct2, funct3, opcode);
            rf_we = 1'b0;
            alu_op = 3'b001;
            imm12 = {instr[31:25], instr[11:7]};
            has_imm = 1'b1;
            mem_we = 1'b1;
        end
        17'b?????_??_001_1100011: begin // BNE
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "BNE", funct5, funct2, funct3, opcode);
            imm12 = {instr[31], instr[31], instr[7], instr[30:25], instr[11:9]};
            alu_op = 3'b100;
            branch = 1'b1;
        end
        default: begin
            $strobe("(%s) funct5 = %h, funct2 = %h, funct3 = %h, opcode = %h",
                "UNKNOWN INSTRUCTION", funct5, funct2, funct3, opcode);
        end
    endcase
end

endmodule