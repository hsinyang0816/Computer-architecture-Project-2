module IF_ID
(
    Instruction_i,
    Stall_i,
    Flush_i,
    PC_i,
    clk_i,
    rst_i,
    cpu_stall_i,
    PC_o,
    Instruction_o
);

// Ports
input   [31:0]      Instruction_i;
input               Stall_i;
input               Flush_i;
input   [31:0]      PC_i;
input               clk_i;
input               rst_i;
input               cpu_stall_i;
output  [31:0]      Instruction_o;
output  [31:0]      PC_o;

reg                 Flush;

reg     [31:0]      Instruction_o;
reg     [31:0]      PC_o;

//Stall = Stall_i;
//Flush = Flush_i;

always@(posedge clk_i or posedge rst_i) begin
        if(rst_i) begin
            Instruction_o <= 32'b0;
            PC_o <= 32'b0;
        end
        else if (~cpu_stall_i) begin
            if(Stall_i) begin
                Instruction_o <= Instruction_o;
                PC_o <= PC_o;
            end
            else if(Flush_i) begin
                Instruction_o <= 32'b0;
                PC_o <= PC_i;
            end
            else begin
                Instruction_o <= Instruction_i;
                PC_o <= PC_i;
            end
        end
end

endmodule
