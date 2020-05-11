`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/26 17:28:36
// Design Name: 
// Module Name: tb_descramble
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


module tb_descramble();
reg clk, reset;
reg [11:0]in_addr;
reg [15:0]key;
wire [11:0] out_addr;
reg [7:0] RegisterA[65535:0];
reg [7:0] RegisterB[65535:0];
reg [7:0] Face[4095:0];
integer i,j,k,l,f;

descramble my_descramble(in_addr, key, clk, reset, out_addr);

initial begin
    $readmemh("C:\\gray\\GIRLSCRAMBLE.hex",RegisterA);
    clk=1;
    key=16'b1011_0101_0011_0000;
    f=0;
    for (k=97;k<161;k=k+1)begin
        for(l=86;l<150;l=l+1)begin
            Face[f]=RegisterA[256*k+l];
            f=f+1;
        end
    end
    
    #10
    in_addr=0;
    for(i=0;i<256;i=i+1)begin //세로 
        for(j=0;j<256;j=j+1)begin //가로
            if((i>96 && i<161) && (j>85 && j<150)) begin
            reset=0;
            #1 reset=1;
            #24 RegisterB[256*i+j]=Face[out_addr];
            in_addr=in_addr+1;
            end
            else
            RegisterB[256*i+j]=RegisterA[256*i+j];
        end
    end

    #10 $writememh("C:\\gray\\GIRLDESCRAMBLE.hex",RegisterB);
end

always #1 clk = ~clk;

endmodule
