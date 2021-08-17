module ID_EX
(
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    data1_i,
    data2_i,
    ImmGen_i,
    funct_i,
    rs1_i,
    rs2_i,
    rd_i,
    clk_i,
    rst_i,
    cpu_stall_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    data1_o,
    data2_o,
    ImmGen_o,
    funct_o,
    rs1_o,
    rs2_o,
    rd_o 
);

// Ports
input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input   [1:0]       ALUOp_i;
input               ALUSrc_i;
input   [31:0]      data1_i;
input   [31:0]      data2_i;
input   [31:0]      ImmGen_i;
input   [9:0]       funct_i;
input   [4:0]       rs1_i;
input   [4:0]       rs2_i;
input   [4:0]       rd_i;
input               clk_i;
input               rst_i;
input               cpu_stall_i;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output  [31:0]      data1_o;
output  [31:0]      data2_o;
output  [31:0]      ImmGen_o;
output  [9:0]       funct_o;
output  [4:0]       rs1_o;
output  [4:0]       rs2_o;
output  [4:0]       rd_o;


reg                 RegWrite_o;
reg                 MemtoReg_o;
reg                 MemRead_o;
reg                 MemWrite_o;
reg     [1:0]       ALUOp_o;
reg                 ALUSrc_o;
reg     [31:0]      data1_o;
reg     [31:0]      data2_o;
reg     [31:0]      ImmGen_o;
reg     [9:0]       funct_o;
reg     [4:0]       rs1_o;
reg     [4:0]       rs2_o;
reg     [4:0]       rd_o;

always@(posedge clk_i or posedge rst_i) begin
       if(rst_i) begin
            RegWrite_o <= 0;
            MemtoReg_o <= 0;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            ALUOp_o <= 2'b0;
            ALUSrc_o <= 0;
            data1_o <= 32'b0;
            data2_o <= 32'b0;
            ImmGen_o <= 32'b0;
            funct_o <= 10'b0;
            rs1_o <= 5'b0;
            rs2_o <= 5'b0;
            rd_o <= 5'b0;
        end
        else if (~cpu_stall_i) begin
            RegWrite_o <= RegWrite_i;
            MemtoReg_o <= MemtoReg_i;
            MemRead_o <= MemRead_i;
            MemWrite_o <= MemWrite_i;
            ALUOp_o <= ALUOp_i;
            ALUSrc_o <= ALUSrc_i;
            data1_o <= data1_i;
            data2_o <= data2_i;
            ImmGen_o <= ImmGen_i;
            funct_o <= funct_i;
            rs1_o <= rs1_i;
            rs2_o <= rs2_i;
            rd_o <= rd_i;
        end
end

endmodule
