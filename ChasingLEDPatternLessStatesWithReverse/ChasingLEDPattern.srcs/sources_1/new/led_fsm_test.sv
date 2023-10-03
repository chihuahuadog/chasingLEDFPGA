`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2023 03:45:12 PM
// Design Name: 
// Module Name: led_fsm_test
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2023 10:53:06 AM
// Design Name: 
// Module Name: led_fsm
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
module led_fsm_test(
        input logic sw,
        input logic reset,
        input logic [7:0] delay,
        input logic clk, // genrally the 100MHz
        output logic [15:0] LED
    );

    //delay counter
    // 10 ms m_tick generator
    // assuming clk is 100 MHz (clock period is 10 ns)
    // 10 ms / 10 ns is 10e-3 / 10e-9 which is 1_000_000
    //1ms/10ns = 1e-3/10e-9 = 100000
    //range from 15ms to 525ms
    //15ms is 1500000
    //2ms is 200000
    //525ms is 52500000
   
    logic m_tick;

   delay_timer_parameter 
    #(32) dtp (
    .clk(clk),
    .reset_n(~reset),
    .enable(1'b1),
    .FINAL_VALUE({24'b0, delay}),
//    output [BITS - 1:0] Q,
    .done(m_tick)
    );
    
    // signal declarations
    logic [3:0] state_reg, state_next;
    logic [15:0] led_wire;
    //direction 0 for toward, 1 for away
    logic dir, dir_next;
    // state register
    always_ff @(posedge clk, posedge reset)
        if(reset)
        begin
            state_reg <= 1;
            dir <= 0;
            end
        else
        begin
            state_reg <= state_next;
            dir <= dir_next;
        end
            
    
    // next-state logic
    always_comb
    begin
            case(state_reg)
                1: LED = 16'b1000000000000001;
                2: LED = 16'b0100000000000010;
                3: LED = 16'b0010000000000100;
                4: LED = 16'b0001000000001000;
                5: LED = 16'b0000100000010000;
                6: LED = 16'b0000010000100000;
                7: LED = 16'b0000001001000000;
                8: LED = 16'b0000000110000000;
            endcase
                
            if(m_tick)begin
                if(sw)begin
                    state_next = dir_next? state_reg-1: state_reg+1;
                end
                else begin
                state_next = state_reg;
                end
            end 
            else begin
            state_next = state_reg;
            end
            
            if(state_reg>=8 && dir == 0)begin dir_next = 1; ;end
            else if(state_next<=1 && dir ==1)begin dir_next = 0;end
            else dir_next = dir;
    end
    
endmodule
