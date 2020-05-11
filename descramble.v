`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/26 17:27:55
// Design Name: 
// Module Name: descramble
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



module descramble(in_addr, key, clk, reset, out_addr);
input [11:0]in_addr;
input [15:0]key;
input clk, reset;
output [11:0]out_addr;

reg [11:0] random, random_next, random_done, random_r;
reg [4:0] count, count_next;
reg [3:0] k1, k2, k3, k4;
wire feedback = (random_r[k4] ^ random_r[k3] ^ random_r[k2] ^ random_r[k1]); 

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
    random_next = random; //default
    count_next = count;//default
    random_r = random;
    
    random_r={random[0],random[11:1]};
    random_next = {feedback,random_r[10:0]};
    count_next = count+1;
    if(count == 12)  begin
        count = 0;
        random_done = random;
    end
end

assign out_addr=random_done;

endmodule

