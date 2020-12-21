module test();
    reg clk = 0;
    always #2 clk = !clk;
    initial #75 $finish;
    
    reg [7:0] x;
    reg [1:0] on;
    reg start;
    reg rst;
    wire [7:0] y;
    wire [2:0] s;
    wire b, active;
    wire [1:0] regime;
    wire [3:0] real_state;

    main _testee(.clk(clk), .rst(rst), .x(x), .on(on), .start(start), .y(y), .s(s), .b(b), .active(active), .regime(regime), .real_state(real_state));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, test);
        $display("time \t clock \t rst \t x \t on \t start \t y \t s \t b \t active \t regime \t real_state");
        $monitor(" %2d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t %1d \t\t %1d \t\t %1d", $stime, clk, rst, x, on, start, y, s, b, active, regime, real_state);

        rst = 1;
        on = 2;
        start = 0;
        x = 5;
        #4 rst = 0; on = 0;
        #4 on = 3;
        // #4 on = 1; start = 1;


    end
endmodule
