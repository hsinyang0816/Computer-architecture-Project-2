module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

// Ports
input   [9:0]      funct_i;
input   [1:0]      ALUOp_i;
output  [3:0]      ALUCtrl_o;

reg     [3:0]      ALUCtrl_o;

always@(funct_i or ALUOp_i)
begin
    if (funct_i[9:0] == 10'b0000000111)
        ALUCtrl_o = 4'b0000; // case AND
    else if (funct_i == 10'b0000000100) 
        ALUCtrl_o = 4'b0001; // case XOR
    else if (funct_i == 10'b0000000001) 
        ALUCtrl_o = 4'b0010; // case SLL
    else if (funct_i == 10'b0000000000 && ALUOp_i == 2'b10) 
        ALUCtrl_o = 4'b0011; // case ADD
    else if (funct_i == 10'b0100000000 && ALUOp_i == 2'b10) 
        ALUCtrl_o = 4'b0100; // case SUB
    else if (funct_i == 10'b0000001000 && ALUOp_i == 2'b10) 
        ALUCtrl_o = 4'b0101; // case MUX
    else if (funct_i[2:0] == 3'b000 && ALUOp_i == 2'b00) 
        ALUCtrl_o = 4'b0110; // case ADDI
    else if (funct_i[2:0] == 3'b101)
        ALUCtrl_o = 4'b0111; // case SRAI
    else if (funct_i[2:0] == 3'b010 && ALUOp_i == 2'b00)
        ALUCtrl_o = 4'b1000; // case LW and SW
    else if (funct_i == 10'b0000000110) 
        ALUCtrl_o = 4'b1010; // case OR
    else if (ALUOp_i == 2'b11) 
        ALUCtrl_o = 4'b1011; // case NoOp
    else  
        ALUCtrl_o = 4'b1001; // case BEQ
end

endmodule
