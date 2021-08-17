module Hazard_Detection
(
    MemRead_i,
    rd_i,
    rs1_i,
    rs2_i,
    NoOp_o,
    Stall_o,
    PCWrite_o
);

// Ports
input               MemRead_i;
input   [4:0]       rd_i;
input   [4:0]       rs1_i;
input   [4:0]       rs2_i;
output              NoOp_o;
output              Stall_o;
output              PCWrite_o;

reg                 NoOp_o;
reg                 Stall_o;
reg                 PCWrite_o;

always@(MemRead_i or rd_i or rs1_i or rs2_i)
begin
    if(MemRead_i && ((rd_i == rs1_i) || (rd_i == rs2_i)))begin
        Stall_o <= 1;
        PCWrite_o <= 0;
        NoOp_o <= 1; 
    end
    else begin
        Stall_o <= 0;
        PCWrite_o <= 1;
        NoOp_o <= 0; 
    end
end

endmodule
