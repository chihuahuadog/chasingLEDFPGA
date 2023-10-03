`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2023 06:55:29 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
        input logic sw,
        input logic reset,
        input logic [4:0] delay1, delay2,
        input logic clk, // genrally the 100MHz
        output logic [15:0] LED,
        output logic [6:0] sseg,
        output logic dp,
        output logic [7:0] an
    );
    
    led_fsm Lf(
        .sw(sw),
        .reset(reset),
        .delay1(delay1),
        .delay2(delay2),
        .clk(clk), // genrally the 100MHz
        .LED(LED)
    );

    
    logic [11:0] delay_bcd1, delay_bcd2;
    
     bin2bcd b2bcd1(
    .bin(8'b0 + delay1),
    .bcd(delay_bcd1)
     );
     
     bin2bcd b2bcd2(
    .bin(8'b0 + delay2),
    .bcd(delay_bcd2)
     );
     
     time_mux_disp disp (
        .in0({1'b1 ,delay_bcd2[3:0], 1'b1}),
        .in1({1'b1 ,delay_bcd2[7:4], 1'b1}),
        .in2({1'b1 ,delay_bcd2[11:8], 1'b1}),
        .in3(6'b1),
        .in4(6'b1),
        .in5({1'b1 ,delay_bcd1[3:0], 1'b1}),
        .in6({1'b1 ,delay_bcd1[7:4], 1'b1}),
        .in7({1'b1 ,delay_bcd1[11:8], 1'b1}),
        .dp(dp),
        .clk(clk),
        .sseg(sseg),
        .an(an)
    );
endmodule
