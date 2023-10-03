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
module led_fsm(
        input logic sw,
        input logic reset,
        input logic [4:0] delay1, delay2,
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
   
    logic m_tick1, m_tick2;
    

   delay_timer_parameter 
    #(.BITS(32)) dtp1 (
    .clk(clk),
    .reset_n(~reset),
    .enable(1'b1),
    .FINAL_VALUE(32'b0 + (1500000 + 1600000*delay1)),
//    output [BITS - 1:0] Q,
    .done(m_tick1)
    );
    
     delay_timer_parameter 
    #(.BITS(32)) dtp2 (
    .clk(clk),
    .reset_n(~reset),
    .enable(1'b1),
    .FINAL_VALUE(32'b0 + (1500000 + 1600000*delay2)),
//    output [BITS - 1:0] Q,
    .done(m_tick2)
    );
    
    // signal declarations
    logic [4:0] state_reg1, state_next1;
    logic [4:0] state_reg2, state_next2;
    //direction 0 for toward, 1 for away
    logic dir1, dir_next1;
    logic dir2, dir_next2;
    // state register
    always_ff @(posedge clk, posedge reset)
        if(reset)
        begin
            state_reg1 <=1;
            state_reg2 <=16;
            dir1 <= 0;
            dir2 <= 1;
            end
        else
        begin
            state_reg1 = state_next1;
            state_reg2 = state_next2;
            dir1 <= dir_next1;
            dir2 <= dir_next2;
        end
            
    
    // next-state logic
    always_comb
    begin
           /* case(state_reg)
                1: LED = 16'b1000000000000001;
                2: LED = 16'b0100000000000010;
                3: LED = 16'b0010000000000100;
                4: LED = 16'b0001000000001000;
                5: LED = 16'b0000100000010000;
                6: LED = 16'b0000010000100000;
                7: LED = 16'b0000001001000000;
                8: LED = 16'b0000000110000000;
            endcase*/
            
            for(int i=0; i<16; i++)begin
            if((i==(state_reg1-1)) || (i==(state_reg2-1)) ) LED[i] = 1;
            else LED[i] = 0;
            if((state_reg2-1)>15)LED[15] = 1;
           end
           
           if(m_tick1)
           begin
                if(sw)state_next1 = dir1? state_reg1-1: state_reg1+1;
                else state_next1 = state_reg1;
            end 
            else begin
            state_next1 = state_reg1;
            end
           
           if(m_tick2)
           begin
                if(sw)state_next2 = dir2? state_reg2-1: state_reg2+1;
                else state_next2 = state_reg2;
            end 
            else begin
            state_next2 = state_reg2;
            end
            
            if(((state_reg1+1)==state_reg2)&& (dir1==0))
            begin
                dir_next1 = 1;
            end
            else if(state_reg1<=1 && dir1==1)
            dir_next1 = 0;
            else
            dir_next1 = dir1;
            
            if((state_reg1==(state_reg2-1))&& (dir2==1))
            begin
                dir_next2 = 0;
            end
            else if(state_reg2>=16 && dir1==0)
            dir_next2 = 1;
            else
            dir_next2 = dir2;
            
    end
    
endmodule
