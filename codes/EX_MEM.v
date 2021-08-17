module EX_MEM
(
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    data_i,
    Writedata_i,
    rd_i,
    clk_i,
    rst_i,
    cpu_stall_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    data_o,
    Writedata_o,
    rd_o,
);

// Ports
input               RegWrite_i;
input               MemtoReg_i;
input               MemRead_i;
input               MemWrite_i;
input   [31:0]      data_i;
input   [31:0]      Writedata_i;
input   [4:0]       rd_i;
input               clk_i;
input               rst_i;
input               cpu_stall_i;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output  [31:0]      data_o;
output  [31:0]      Writedata_o;
output  [4:0]       rd_o;

reg                 RegWrite_o;
reg                 MemtoReg_o;
reg                 MemRead_o;
reg                 MemWrite_o;
reg     [31:0]      data_o;
reg     [31:0]      Writedata_o;
reg     [4:0]       rd_o;

always@(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            RegWrite_o <= 0;
            MemtoReg_o <= 0;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            data_o <= 32'b0;
            Writedata_o <= 32'b0;
            rd_o <= 5'b0;
        end
        else if(~cpu_stall_i) begin
            RegWrite_o <= RegWrite_i;
            MemtoReg_o <= MemtoReg_i;
            MemRead_o <= MemRead_i;
            MemWrite_o <= MemWrite_i;
            data_o <= data_i;
            Writedata_o <= Writedata_i;
            rd_o <= rd_i;
        end
end

endmodule
