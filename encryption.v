`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 22:41:48
// Design Name: 
// Module Name: scramble
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


module scramble(in_addr, key, clk, reset, out_addr);
input [11:0]in_addr;
input [15:0]key;
input clk, reset;
output [11:0]out_addr;

reg [11:0] random, random_next, random_done;
reg [4:0] count, count_next;
reg [3:0] k1, k2, k3, k4;
wire feedback = (random[k4] ^ random[k3] ^ random[k2] ^ random[k1]); 

always@(posedge clk or negedge reset) begin
    if(!reset) begin
        {k4,k3,k2,k1}=key;
        random <= in_addr;
        count <= 0;
    end
    else begin
         random <= random_next;
         count <= count_next;
    end
end

always@(*) begin
    random_next = random;
    count_next = count;
    
    random_next = {random[10:0],feedback};
    count_next = count+1;
    if(count == 12)  begin
        count = 0;
        random_done = random;
    end
end

assign out_addr=random_done;

endmodule
