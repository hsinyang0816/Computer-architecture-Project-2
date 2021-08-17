module CPU
(
    clk_i, 
    rst_i,
    start_i,

    mem_data_i,
    mem_ack_i,
    mem_data_o,
    mem_addr_o,
    mem_enable_o,
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input   [255:0]     mem_data_i;
input               mem_ack_i;

output  [255:0]     mem_data_o;
output  [31:0]      mem_addr_o;
output              mem_enable_o;
output              mem_write_o;

// Wire
wire                Flush;
wire    [31:0]      pc_i;
wire    [31:0]      pc_o;
wire    [31:0]      pc_add;
wire    [31:0]      MUX1_0;           
wire    [31:0]      MUX1_1;
wire                PCWrite;
wire    [31:0]      instr_i;
wire    [31:0]      instr_o;
wire                Stall;
wire    [31:0]      data1_i;
wire    [31:0]      data2_i;
wire                Branch;
wire                NoOp;
wire    [1:0]       ALUOp_ID;
wire                ALUSrc_ID;
wire                RegWrite_ID;
wire                MemtoReg_ID;
wire                MemRead_ID;
wire                MemWrite_ID;
wire    [31:0]      ImmGen_ID;
wire    [1:0]       ALUOp_EX;
wire                ALUSrc_EX;
wire                RegWrite_EX;
wire                MemtoReg_EX;
wire                MemRead_EX;
wire                MemWrite_EX;
wire    [31:0]      ImmGen_EX;
wire    [9:0]       funct;
wire    [4:0]       rs1_EX;
wire    [4:0]       rs2_EX;
wire    [4:0]       rd_EX;
wire    [31:0]      data1_o;
wire    [31:0]      data2_o;
wire    [1:0]       ForwardA;
wire    [1:0]       ForwardB;
wire    [31:0]      ALU0;
wire    [31:0]      ALU1;
wire    [31:0]      Writedata_EX;
wire    [31:0]      Writedata_MEM;
wire    [3:0]       ALUCtrl;
wire    [31:0]      ALU_result;
wire                zero;
wire    [4:0]       rd_MEM;
wire                RegWrite_MEM;
wire                MemtoReg_MEM;
wire                MemRead_MEM;
wire                MemWrite_MEM;
wire    [31:0]      Readdata_MEM;
wire    [31:0]      ALU_result_MEM;
wire                RegWrite_WB;
wire                MemtoReg_WB;
wire    [31:0]      Readdata_WB;
wire    [31:0]      ALU_result_WB;
wire    [4:0]       rd_WB;
wire    [31:0]      Writedata_WB;
wire    [31:0]      mem_addr;
wire    [255:0]     mem_data;
wire                mem_enable;
wire                mem_write;
wire                mem_ack;
wire    [255:0]     mem_output_data;
wire                cpu_stall;


           


MUX32 MUX32_1(
    .data1_i    (MUX1_0),
    .data2_i    (MUX1_1),
    .select_i   (Flush),
    .data_o     (pc_i) 
);

MUX32 MUX32_2(
    .data1_i    (Writedata_EX),
    .data2_i    (ImmGen_EX),
    .select_i   (ALUSrc_EX),
    .data_o     (ALU1) 
);

MUX32 MUX32_3(
    .data1_i    (ALU_result_WB),
    .data2_i    (Readdata_WB),
    .select_i   (MemtoReg_WB),
    .data_o     (Writedata_WB) 
);

MUX4 MUX4_A(
    .data1_i    (data1_o),
    .data2_i    (Writedata_WB),
    .data3_i    (ALU_result_MEM),
    .select_i   (ForwardA),
    .data_o     (ALU0) 
);

MUX4 MUX4_B(
    .data1_i    (data2_o),
    .data2_i    (Writedata_WB),
    .data3_i    (ALU_result_MEM),
    .select_i   (ForwardB),
    .data_o     (Writedata_EX) 
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (pc_i),
    .stall_i    (cpu_stall),   
    .pc_o       (pc_o)
);

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'b100),
    .data_o     (MUX1_0)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o),
    .instr_o    (instr_i)
);

IF_ID IF_ID(
    .Instruction_i   (instr_i),
    .Stall_i    (Stall),
    .Flush_i    (Flush),
    .PC_i       (pc_o),
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .cpu_stall_i (cpu_stall),   
    .PC_o       (pc_add),
    .Instruction_o   (instr_o)
);

Adder Add_BEQ(
    .data1_in   (ImmGen_ID << 1),
    .data2_in   (pc_add),
    .data_o     (MUX1_1)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (instr_o[19:15]),
    .RS2addr_i  (instr_o[24:20]),
    .RDaddr_i   (rd_WB),
    .RDdata_i   (Writedata_WB),
    .RegWrite_i (RegWrite_WB),
    .RS1data_o  (data1_i),
    .RS2data_o  (data2_i)
);

And And(
    .data1_i    (Branch),
    .data2_i    (data1_i == data2_i),
    .data_o     (Flush)
);

Control Control(
    .Op_i       (instr_o[6:0]),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp_ID),
    .ALUSrc_o   (ALUSrc_ID),
    .RegWrite_o (RegWrite_ID),
    .MemtoReg_o (MemtoReg_ID),
    .MemRead_o  (MemRead_ID),
    .MemWrite_o (MemWrite_ID),
    .Branch_o   (Branch)
);

ImmGen ImmGen(
    .data_i      (instr_o),
    .data_o      (ImmGen_ID)
);

Hazard_Detection Hazard_Detection(
    .MemRead_i   (MemRead_EX),
    .rd_i        (rd_EX),
    .rs1_i       (instr_o[19:15]),
    .rs2_i       (instr_o[24:20]),
    .NoOp_o      (NoOp),
    .Stall_o     (Stall),
    .PCWrite_o   (PCWrite)
);

ID_EX ID_EX(
    .RegWrite_i  (RegWrite_ID),
    .MemtoReg_i  (MemtoReg_ID),
    .MemRead_i   (MemRead_ID),
    .MemWrite_i  (MemWrite_ID),
    .ALUOp_i     (ALUOp_ID),
    .ALUSrc_i    (ALUSrc_ID),
    .data1_i     (data1_i),
    .data2_i     (data2_i),
    .ImmGen_i    (ImmGen_ID),
    .funct_i     ({instr_o[31:25], instr_o[14:12]}),
    .rs1_i       (instr_o[19:15]),
    .rs2_i       (instr_o[24:20]),
    .rd_i        (instr_o[11:7]),
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .cpu_stall_i (cpu_stall),   
    .RegWrite_o  (RegWrite_EX),
    .MemtoReg_o  (MemtoReg_EX),
    .MemRead_o   (MemRead_EX),
    .MemWrite_o  (MemWrite_EX),
    .ALUOp_o     (ALUOp_EX),
    .ALUSrc_o    (ALUSrc_EX),
    .data1_o     (data1_o),
    .data2_o     (data2_o),
    .ImmGen_o    (ImmGen_EX),
    .funct_o     (funct),
    .rs1_o       (rs1_EX),
    .rs2_o       (rs2_EX),
    .rd_o        (rd_EX)
);

ALU ALU(
    .data1_i     (ALU0),
    .data2_i     (ALU1),
    .ALUCtrl_i   (ALUCtrl),
    .data_o      (ALU_result),
    .Zero_o      (zero)
);

ALU_Control ALU_Control(
    .funct_i     (funct),
    .ALUOp_i     (ALUOp_EX),
    .ALUCtrl_o   (ALUCtrl)
);

Forwarding_unit Forward(
    .RegWrite_MEM_i   (RegWrite_MEM),
    .rd_MEM_i    (rd_MEM),
    .RegWrite_WB_i    (RegWrite_WB),
    .rd_WB_i     (rd_WB),
    .rs1_EX_i    (rs1_EX),
    .rs2_EX_i    (rs2_EX),
    .ForwardA_o  (ForwardA),
    .ForwardB_o  (ForwardB)
);

EX_MEM EX_MEM(
    .RegWrite_i  (RegWrite_EX),
    .MemtoReg_i  (MemtoReg_EX),
    .MemRead_i   (MemRead_EX),
    .MemWrite_i  (MemWrite_EX),
    .data_i      (ALU_result),
    .Writedata_i (Writedata_EX),
    .rd_i        (rd_EX),
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .cpu_stall_i (cpu_stall),   
    .RegWrite_o  (RegWrite_MEM),
    .MemtoReg_o  (MemtoReg_MEM),
    .MemRead_o   (MemRead_MEM),
    .MemWrite_o  (MemWrite_MEM),
    .data_o      (ALU_result_MEM),
    .Writedata_o (Writedata_MEM),
    .rd_o        (rd_MEM)
);

dcache_controller dcache(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .mem_data_i  (mem_data_i),
    .mem_ack_i   (mem_ack_i),
    .mem_data_o  (mem_data_o),
    .mem_addr_o  (mem_addr_o),
    .mem_enable_o(mem_enable_o),
    .mem_write_o (mem_write_o),
    .cpu_data_i  (Writedata_MEM),
    .cpu_addr_i  (ALU_result_MEM),
    .cpu_MemRead_i  (MemRead_MEM),
    .cpu_MemWrite_i (MemWrite_MEM),
    .cpu_data_o  (Readdata_MEM),
    .cpu_stall_o (cpu_stall)   
);

/*
Data_Memory Data_Memory(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .addr_i      (mem_addr),
    .data_i      (mem_data),
    .enable_i    (mem_enable),
    .write_i     (mem_write),
    .ack_o       (mem_ack),
    .data_o      (mem_output_data)
);
*/

MEM_WB MEM_WB(
    .RegWrite_i  (RegWrite_MEM),
    .MemtoReg_i  (MemtoReg_MEM),
    .data_i      (ALU_result_MEM),
    .Readdata_i  (Readdata_MEM),
    .rd_i        (rd_MEM),
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .cpu_stall_i (cpu_stall),   
    .RegWrite_o  (RegWrite_WB),
    .MemtoReg_o  (MemtoReg_WB),
    .data_o      (ALU_result_WB),
    .Readdata_o  (Readdata_WB),
    .rd_o        (rd_WB)
);

// ---------------------------------------------------------------------------------------------

endmodule

