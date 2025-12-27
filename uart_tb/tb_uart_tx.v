`timescale 1ns / 1ps
module tb_uart_tx();
reg clk,rst,tx_start;
reg [7:0] tx_data;
wire tx,tx_busy;
uart_tx dut(
.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.tx_busy(tx_busy));
always #10 clk=~clk;
initial
begin
clk=0;rst=1;tx_start=0;tx_data=8'h00;
$monitor($time, " rst=%b , start=%b , tx_data=%d , tx=%b,tx_busy=%b",rst,tx_start,tx_data,tx,tx_busy);
#10;
rst=1'b0;
repeat(10) @(posedge clk);
tx_data=8'hA3;
tx_start=1'b1;
@(posedge clk);
tx_start=1'b0;
repeat(100)
#50000000;
$finish;
end
endmodule