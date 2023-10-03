`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2023 03:44:33 PM
// Design Name: 
// Module Name: led_fsm_test_tb
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

module led_fsm_test_tb();
    localparam T = 10;
     logic sw;
     logic reset;
     logic [31:0] delay;
     logic clk;
     logic [15:0] LED;
   
  led_fsm_test uut(
        .sw(sw),
        .reset(reset),
        .delay(delay),
        .clk(clk), // genrally the 100MHz
        .LED(LED)
    );
    
    always
    begin
        clk = 1'b1;
        #(T / 2);
        clk = 1'b0;
        #(T / 2);
    end
    
    // reset for the first half cycle
    initial
    begin
        reset = 1'b1;
        #(T / 2);
        reset = 1'b0;
    end
      // stimuli (just the tick
    initial
    begin        
        sw = 1;
        delay = 32'b10;
        
        #20
        sw = 1;
        
        #20
        sw = 1;
        
        #400
        sw = 1;
        
        $finish;
    end
endmodule
