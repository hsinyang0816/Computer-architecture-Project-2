module dcache_sram (
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


reg      [24:0]    tag_o;
reg      [255:0]   data_o;
reg                hit_o;
// Memory
//reg      [24:0]    tag [0:15][0:1];    
//reg      [255:0]   data[0:15][0:1];
reg signed      [24:0]    tag [0:15];    
reg signed      [24:0]    tag1 [0:15];    
reg signed      [255:0]   data [0:15];
reg signed      [255:0]   data1 [0:15];
reg                       LRU [0:15];

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            LRU[i] <= 1'b0;
            tag[i] <= 25'b0;
            tag1[i] <= 25'b0;
            data[i] <= 256'b0;
            data1[i] <= 256'b0;
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (LRU[addr_i] == 1'b0) begin
            data[addr_i] <= data_i;
            if (tag[addr_i][24] == 1)
                tag[addr_i] <= {1'b1, 1'b1, tag_i[22:0]};
            else
                tag[addr_i] <= {1'b1, 1'b0, tag_i[22:0]};
        end
        else begin
            data1[addr_i] <= data_i;
            if (tag1[addr_i][24] == 1)
                tag1[addr_i] <= {1'b1, 1'b1, tag_i[22:0]};
            else
                tag1[addr_i] <= {1'b1, 1'b0, tag_i[22:0]};
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?

always@(tag_i or addr_i or tag[addr_i] or tag1[addr_i] or data[addr_i] or data1[addr_i]) begin
    if ((tag[addr_i][24] == 1) && (tag_i[22:0] == tag[addr_i][22:0])) begin
        tag_o <= tag[addr_i];
        data_o <= data[addr_i];
        hit_o <= 1'b1;
    end
    else if ((tag1[addr_i][24] == 1) && (tag_i[22:0] == tag1[addr_i][22:0])) begin
        tag_o <= tag1[addr_i];
        data_o <= data1[addr_i];
        hit_o <= 1'b1;
    end
    else begin
        LRU[addr_i] = ~LRU[addr_i];
        tag_o <= {2'b0, tag_i[22:0]};
        if (LRU[addr_i] && tag[addr_i][24])
            data_o <= data[addr_i]; 
        else if (~LRU[addr_i] && tag1[addr_i][24])
            data_o <= data1[addr_i]; 
        else
            data_o <= data_i;
        hit_o <= 1'b0;
    end
end



endmodule
