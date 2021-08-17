module Forwarding_unit
(
    RegWrite_MEM_i,
    rd_MEM_i,
    RegWrite_WB_i,
    rd_WB_i,
    rs1_EX_i,
    rs2_EX_i,
    ForwardA_o,
    ForwardB_o
);

// Ports
input               RegWrite_MEM_i;
input   [4:0]       rd_MEM_i;
input               RegWrite_WB_i;
input   [4:0]       rd_WB_i;
input   [4:0]       rs1_EX_i;
input   [4:0]       rs2_EX_i;
output  [1:0]       ForwardA_o;
output  [1:0]       ForwardB_o;

reg     [1:0]       ForwardA_o;
reg     [1:0]       ForwardB_o;

always@(RegWrite_MEM_i or rd_MEM_i or RegWrite_WB_i or rd_WB_i or rs1_EX_i or rs2_EX_i)
begin
    if (RegWrite_MEM_i && (rd_MEM_i != 4'b0000) && (rd_MEM_i == rs1_EX_i))
        ForwardA_o = 2'b10;
    else if (RegWrite_WB_i && (rd_WB_i != 4'b0000) && (rd_WB_i == rs1_EX_i))
        ForwardA_o = 2'b01;
    else
        ForwardA_o = 2'b00;

    if (RegWrite_MEM_i && (rd_MEM_i != 4'b0000) && (rd_MEM_i == rs2_EX_i))
        ForwardB_o = 2'b10;
    else if (RegWrite_WB_i && (rd_WB_i != 4'b0000) && (rd_WB_i == rs2_EX_i))
        ForwardB_o = 2'b01;
    else
        ForwardB_o = 2'b00;
end

endmodule
