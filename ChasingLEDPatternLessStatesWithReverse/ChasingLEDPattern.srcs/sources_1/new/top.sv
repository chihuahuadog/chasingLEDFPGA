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
        input logic [7:0] delay,
        input logic clk, // genrally the 100MHz
        output logic [15:0] LED,
        output logic [6:0] sseg,
        output logic dp,
        output logic [7:0] an
    );
    
    led_fsm Lf(
        .sw(sw),
        .reset(reset),
        .delay(delay),
        .clk(clk), // genrally the 100MHz
        .LED(LED)
    );

    
    logic [11:0] delay_bcd;
    
     bin2bcd b2bcd(
    .bin(delay),
    .bcd(delay_bcd)
     );
     
     time_mux_disp disp (
        .in0(6'b1),
        .in1(6'b1),
        .in2(6'b1),
        .in3(6'b1),
        .in4(6'b1),
        .in5({1'b1 ,delay_bcd[3:0], 1'b1}),
        .in6({1'b1 ,delay_bcd[7:4], 1'b1}),
        .in7({1'b1 ,delay_bcd[11:8], 1'b1}),
        .dp(dp),
        .clk(clk),
        .sseg(sseg),
        .an(an)
    );
endmodule
