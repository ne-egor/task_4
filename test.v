module test();
    reg clk = 0;
    always #2 clk = !clk;
    initial #75 $finish;
    
    reg rst; reg signed [7:0] in; reg [2:0] op; reg apply; 
    wire signed [7:0] tail; wire empty; wire valid;

    calc testee(.clk(clk), .rst(rst), .in(in), .op(op), .apply(apply), .tail(tail), .empty(empty), .valid(valid));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, test);
        $display("time \t clock \t rst \t in \t op \t apply \t tail \t empty \t valid");
        $monitor(" %2d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d", $stime, clk, rst, in, op, apply, tail, empty, valid);

        rst = 1;
        in = 29;
        apply = 1;
        op = 5;
        #4 rst = 0; in = 62;
        #4 op = 5; in = 12;
        #4 op = 0;
        #4 op = 5; in = 74;
        #4 in = 10;
        #4 op = 1;
        #4 op = 4;
        #4 rst = 1;
        #4 rst = 0; op = 5; in = 5;
        #4 in = 2;
        #4 in = 15;
        #4 op = 6;
        #4 op = 2;
        #4 op = 6;

    end
endmodule
