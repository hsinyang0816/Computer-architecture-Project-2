module des();
    reg [7:0] mem [15:0][1:0];
    initial begin
        mem[3][0] = 8'b101;
        $display(mem[3][0])
    end
endmodule
