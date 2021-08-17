module Adder
(
    data1_in,
    data2_in,
    data_o
);

// Ports
input   [31:0]     data1_in;
input   [31:0]     data2_in;
output  [31:0]     data_o;

reg     [31:0]     data_o;

always@(data1_in or data2_in)
begin
    assign data_o = data1_in + data2_in;
end

endmodule
