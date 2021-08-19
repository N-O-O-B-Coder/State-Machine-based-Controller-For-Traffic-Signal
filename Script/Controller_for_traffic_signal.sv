module traffic_signal(
    highway_signal, 
    farm_signal, 
    sensor, 
    clk, 
    rst
    );

    input sensor;
    input clk;
    input rst;

    output reg[1:0] highway_signal;
    output reg[1:0] farm_signal;

    reg[32:0] count=0,count_delay=0;

    reg delay_10s,delay3s1,delay3s2,count_red,count_yellow,count_yellow_2;

    wire enable_clk;

    parameter  high_green_farm_red =2'b00,
        high_yellow_farm_red =2'b01,
        high_red_farm_green =2'b10,
        high_red_farm_yellow =2'b11;
    reg[1:0] current_state;

    always @(posedge clk) 
    begin
        case(current_state)
            high_green_farm_red:
            begin
                count_red=0;
                count_yellow=0;
                count_yellow_2=0;
                highway_signal=2'b01;
                farm_signal=3'b11;
                if(sensor)
                    current_state=high_yellow_farm_red;
                else 
                    current_state =high_green_farm_red;
            end

            high_yellow_farm_red:
            begin
                highway_signal=2'b10;
                farm_signal=2'b11;
                count_red=0;
                count_yellow=1;
                count_yellow_2=0;
                if(delay3s1)
                    current_state =high_red_farm_green;
                else 
                    current_state=high_yellow_farm_red;
            end

            high_red_farm_green:
            begin
                highway_signal=2'b11;
                farm_signal=2'b01;
                count_red=1;
                count_yellow=0;
                count_yellow_2=0;
                if(delay_10s)
                    current_state=high_red_farm_yellow;
                else
                    current_state =high_red_farm_green;
            end

            high_red_farm_yellow:
            begin
                highway_signal=2'b11;
                farm_signal=2'b10;
                count_red=0;
                count_yellow=0;
                count_yellow_2=1;
                if(delay3s2)
                    current_state=high_green_farm_red;
                else 
                    current_state =high_red_farm_yellow;
            end
            default: current_state=high_green_farm_red;
            
        endcase
      	if(rst)
                current_state <= high_green_farm_red;
    end

    always @(posedge clk) 
    begin
            if(enable_clk)
            begin
                if(count_red||count_yellow||count_yellow_2)
                    count_delay<=count_delay+1;
                    if((count_delay==9)&& count_red)
                    begin
                        delay_10s=1;
                        delay3s1=0;
                        delay3s2=0;
                        count_delay<=0;
                    end
                    else if ((count_delay==2)&& count_yellow) 
                    begin
                        delay_10s=0;
                        delay3s1=1;
                        delay3s2=0;
                        count_delay<=0;
                    end
                    else if ((count_delay==2)&& count_yellow_2)
                    begin
                        delay_10s=0;
                        delay3s1=0;
                        delay3s2=1;
                        count_delay<=0;
                    end
                    else 
                    begin
                        delay_10s=0;
                        delay3s1=0;
                        delay3s2=0;
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