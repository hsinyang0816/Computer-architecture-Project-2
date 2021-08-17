module Control
(
    Op_i,
    NoOp_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

// Ports
input   [6:0]       Op_i;
input               NoOp_i;
output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;
output              MemtoReg_o;
output              MemRead_o;
output              MemWrite_o;
output              Branch_o;


reg     [1:0]       ALUOp_o;
reg                 ALUSrc_o;
reg                 RegWrite_o;
reg                 MemtoReg_o;
reg                 MemRead_o;
reg                 MemWrite_o;
reg                 Branch_o;


always@(Op_i or NoOp_i)
begin
    //assign RegWrite_o = 1'b1;
    //assign ALUSrc_o = Op_i[5] ? 1'b0 : 1'b1;
    //assign ALUOp_o = Op_i[5] ? 2'b10 : 2'b00;
    if(NoOp_i) begin
        ALUOp_o <= 2'b11; 
        ALUSrc_o <= 0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        Branch_o <= 0;       
    end
    else begin
        if (Op_i == 7'b0000011) begin // case lw
            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1;
            RegWrite_o <= 1;
            MemtoReg_o <= 1;
            MemRead_o <= 1;
            MemWrite_o <= 0;
            Branch_o <= 0;
        end
        else if (Op_i == 7'b0100011) begin // case sw
            ALUOp_o <= 2'b00; 
            ALUSrc_o <= 1;
            RegWrite_o <= 0;
            MemtoReg_o <= 0; //Don't care
            MemRead_o <= 0;
            MemWrite_o <= 1;
            Branch_o <= 0;
        end
        else if (Op_i == 7'b0010011) begin // case addi/srai
            ALUOp_o <= 2'b00; 
            ALUSrc_o <= 1;
            RegWrite_o <= 1;
            MemtoReg_o <= 0; //Don't care
            MemRead_o <= 0;
            MemWrite_o <= 0;
            Branch_o <= 0;
        end
        else if (Op_i == 7'b1100011) begin // case beq
            ALUOp_o <= 2'b01; 
            ALUSrc_o <= 0;
            RegWrite_o <= 0;
            MemtoReg_o <= 0; //Don't care
            MemRead_o <= 0;
            MemWrite_o <= 0;
            Branch_o <= 1;
        end
        else begin // case R-type
            ALUOp_o <= 2'b10; 
            ALUSrc_o <= 0;
            RegWrite_o <= 1;
            MemtoReg_o <= 0; //Don't care
            MemRead_o <= 0;
            MemWrite_o <= 0;
            Branch_o <= 0;
        end
    end
end 

endmodule
