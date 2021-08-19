module traffic_tb;
parameter endtime = 40000;

reg clk;
reg rst;
reg sensor;
wire [1:0] lane_signal;
wire [1:0] highway_signal;

traffic_signal traffic_signal_inst(
    .highway_signal(highway_signal), 
    .lane_signal(lane_signal), 
    .sensor(sensor), 
    .clk(clk), 
    .rst(rst)
);

initial begin
    clk=1'b0;
    rst=1'b1;
    sensor=1'b0;
end
initial begin
    main;
end
task main;
fork
    clock_gen;
    reset_gen;
    operation_flow;
    debug_output;
    endsim;
join
endtask
task clock_gen;
    begin
        forever # 1 clk= ~clk;
    end
endtask    

task reset_gen;
begin
    rst=1;
    #20
    rst=0;
end
endtask

task operation_flow;
begin
    sensor=0;
    #50
    sensor=1;
    #100
    sensor=0;
    #1200
    sensor=1;
end
endtask

task debug_output;
begin
  $monitor("Time=%d\t reset=%b\t sensor=%b\t signal in highway=%h\t signal in lane=%h",$time,rst,sensor,highway_signal,lane_signal);
end
endtask

task endsim;
begin
    #endtime
    $finish;
end
endtask

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end
endmodule