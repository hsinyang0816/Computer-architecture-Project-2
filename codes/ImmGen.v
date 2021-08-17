module ImmGen
(
    data_i,
    data_o
);

// Ports
input   [31:0]       data_i;
output  [31:0]       data_o;

reg     [31:0]       data_o;

always@(data_i) 
begin
    if((data_i[6:0] == 7'b0010011) && (data_i[14:12] == 3'b000)) begin // case ADDI
        assign data_o[11:0] = data_i[31:20];
        assign data_o[31:12] = {20{data_i[31]}};
    end
    else if((data_i[6:0] == 7'b0010011) && (data_i[14:12] == 3'b101)) begin // case SRAI
        assign data_o[4:0] = data_i[24:20];
        assign data_o[31:5] = {27{data_i[24]}};
    end
    else if(data_i[6:0] == 7'b0000011) begin // case LW
        assign data_o[11:0] = data_i[31:20];
        assign data_o[31:12] = {20{data_i[31]}};
    end
    else if(data_i[6:0] == 7'b0100011) begin // case SW
        assign data_o[4:0] = data_i[11:7];
        assign data_o[11:5] = data_i[31:25];
        assign data_o[31:12] = {20{data_i[31]}};
    end 
    else if(data_i[6:0] == 7'b1100011) begin // case BEQ
        assign data_o[3:0] = data_i[11:8];
        assign data_o[9:4] = data_i[30:25];
        assign data_o[10] = data_i[7];
        assign data_o[11] = data_i[31];
        assign data_o[31:12] = {20{data_i[31]}};
    end
    else
        assign data_o = 32'b0;
end

endmodule
