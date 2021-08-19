module traffic_signal(
    highway_signal, 
    lane_signal, 
    sensor, 
    clk, 
    rst
    );

    input sensor;
    input clk;
    input rst;

    output reg[1:0] highway_signal;
    output reg[1:0] lane_signal;

    reg[32:0] count=0,count_delay=0;

    reg delay_3s,delay_3s_2,count_yellow,count_yellow_2;

    wire enable_clk;

    parameter  high_green_lane_red =2'b00,
        high_yellow_lane_red =2'b01,
        high_red_lane_green =2'b10,
        high_red_lane_yellow =2'b11;
    reg[1:0] current_state;

    always @(posedge clk) 
    begin
        case(current_state)
            high_green_lane_red:
            begin
                count_yellow=0;
                count_yellow_2=0;
                highway_signal=2'b01;
                lane_signal=3'b11;
                if(sensor)
                    current_state=high_yellow_lane_red;
                else 
                    current_state =high_green_lane_red;
            end

            high_yellow_lane_red:
            begin
                highway_signal=2'b10;
                lane_signal=2'b11;
                count_yellow=1;
                count_yellow_2=0;
                if(delay_3s)
                    current_state =high_red_lane_green;
                else 
                    current_state=high_yellow_lane_red;
            end

            high_red_lane_green:
            begin
                highway_signal=2'b11;
                lane_signal=2'b01;
                count_yellow=0;
                count_yellow_2=0;
                if(!sensor)
                    current_state=high_red_lane_yellow;
                else
                    current_state =high_red_lane_green;
            end

            high_red_lane_yellow:
            begin
                highway_signal=2'b11;
                lane_signal=2'b10;
                count_yellow=0;
                count_yellow_2=1;
                if(delay_3s_2)
                    current_state=high_green_lane_red;
                else 
                    current_state =high_red_lane_yellow;
            end
            default: current_state=high_green_lane_red;
            
        endcase
      	if(rst)
                current_state <= high_green_lane_red;
    end

    always @(posedge clk) 
    begin
            if(enable_clk)
            begin
                if(count_yellow||count_yellow_2)
                    count_delay<=count_delay+1;
                    if ((count_delay==2)&& count_yellow) 
                    begin
                        delay_3s=1;
                        delay_3s_2=0;
                        count_delay<=0;
                    end
                    else if ((count_delay==2)&& count_yellow_2)
                    begin
                        delay_3s=0;
                        delay_3s_2=1;
                        count_delay<=0;
                    end
                    else 
                    begin
                        delay_3s=0;
                        delay_3s_2=0;
                    end
            end
    end
    always @(posedge clk) 
    begin
            count<=count+1;
            if(count==3)
            begin
                count<=0;
            end
    end
    assign enable_clk =count ==3 ?1:0;
endmodule