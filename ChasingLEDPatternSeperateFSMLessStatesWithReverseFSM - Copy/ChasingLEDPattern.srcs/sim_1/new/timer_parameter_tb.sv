`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2023 04:13:40 PM
// Design Name: 
// Module Name: timer_parameter_tb
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

module tb_delay_timer_parameter;

    // Parameters
    parameter BITS = 32;
    parameter DELAY_CYCLES = 10; // Number of clock cycles to delay

    // Signals
    logic clk;
    logic reset_n;
    logic enable;
    logic [BITS - 1:0] FINAL_VALUE;
    logic done;

    // Instantiate the module under test
    delay_timer_parameter #(BITS) uut (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .FINAL_VALUE(FINAL_VALUE),
        .done(done)
    );

localparam T = 10;
   always
    begin
        clk = 1'b1;
        #(T / 2);
        clk = 1'b0;
        #(T / 2);
    end
    

    // Reset generation
    initial begin
        reset_n = 0;
        enable = 0;
        FINAL_VALUE = 32'd5; // Example final value
        // Release reset after a few clock cycles
        #20 reset_n = 1;
        #20 enable = 1;
        #100
        $finish; // End simulation
    end

    // Monitor the 'done' signal
    always @(posedge clk) begin
        if (done) begin
            $display("Delay Timer Completed at time %t", $time);
        end
    end

endmodule
