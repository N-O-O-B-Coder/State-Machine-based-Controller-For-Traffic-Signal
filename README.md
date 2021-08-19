## **A Finite State Machine Based Traffic Signal Controller**

This repository provides a verilog source code for implementing a traffic signal controller. 

A traffic signal follows a universal colour code. In our code the three colors are denoted by three binaries.
```verilog
red    => 2b'11
green  => 2b'01
yellow => 2b'10
```
There are two traffic signals one pointing towards a lane another to the highway. There is a **sensor** on the lane which detects if there is any vehicle on the lane. 

The lane is less congested compared to the highway. So the controller needs to keep the highway signal green for most of the time. Whenever the sensor detects a vehicle in the lane the traffic signal in the lane changes into green from red going through the intermediate yellow stage. 

The highway signal will change into yellow from green when the sensor is high i.e. vehicle is present in the lane. In the same time the lane signal will remain in red state. The highway signal will turn to red after a time delay of 3 secs and the lane signal changes to green. The lane signal will remain in green until the sensor turns low i.e, there is no vehicle in the lane and then changes to yellow. In the meantime the highway signal is fixed at red. After a time delay of 3 secs the highway signal changes to green and the lane signal changes to red. 

The state machine hence can be designed by 4 states
```Verilog
parameter  high_green_farm_red =2'b00,
        high_yellow_farm_red =2'b01,
        high_red_farm_green =2'b10,
        high_red_farm_yellow =2'b11;
```
The state diagram will be

![state_diaram](https://github.com/N-O-O-B-Coder/State-Machine-based-Controller-For-Traffic-Signal/blob/main/Diagrams/State%20machine.jpeg)

The traffic signal control is modelled using system verilog. Edaplayground was used for simulation and plotting the final waveform.

![waveform](https://github.com/N-O-O-B-Coder/State-Machine-based-Controller-For-Traffic-Signal/blob/main/Diagrams/Waveform.png)
