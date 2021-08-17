module MEM_WB
(
    RegWrite_i,
    MemtoReg_i,
    data_i,
    Readdata_i,
    rd_i,
    clk_i,
    rst_i,
    cpu_stall_i,
    RegWrite_o,
    MemtoReg_o,
    data_o,
    Readdata_o,
    rd_o,
);

// Ports
input               RegWrite_i;
input               MemtoReg_i;
input   [31:0]      data_i;
input   [31:0]      Readdata_i;
input   [4:0]       rd_i;
input               clk_i;
input               rst_i;
input               cpu_stall_i;
output              RegWrite_o;
output              MemtoReg_o;
output  [31:0]      data_o;
output  [31:0]      Readdata_o;
output  [4:0]       rd_o;

reg                 RegWrite_o;
reg                 MemtoReg_o;
reg     [31:0]      data_o;
reg     [31:0]      Readdata_o;
reg     [4:0]       rd_o;

always@(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            RegWrite_o <= 0;
            MemtoReg_o <= 0;
            data_o <= 32'b0;
            Readdata_o <= 32'b0;
            rd_o <= 5'b0;
        end
        //if (RegWrite_i or MemtoReg_i or data_i or Readdata_i or rd_i) begin
        else if(~cpu_stall_i) begin
            RegWrite_o <= RegWrite_i;
            MemtoReg_o <= MemtoReg_i;
            data_o <= data_i;
            Readdata_o <= Readdata_i;
            rd_o <= rd_i;
        end
end

endmodule
