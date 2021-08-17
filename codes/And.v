module And
(
    data1_i,
    data2_i,
    data_o
);

// Ports
input              data1_i;
input              data2_i;
output             data_o;

reg          data_o;

always@(data1_i or data2_i)
begin
    assign data_o = data1_i & data2_i;
end

endmodule
