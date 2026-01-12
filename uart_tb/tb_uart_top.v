`timescale 1ns / 1ps
module tb_uart_top();
reg clk=0;
always #0.01 clk =~clk;

reg rst,tx_start;
reg [7:0]tx_data;
wire [7:0]rx_data;
wire rx_done;

uart_top dut3(.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.rx_data(rx_data),.rx_done(rx_done));

task send_byte(input [7:0] b);
begin
rst=1;
@(posedge clk);
rst=0;
@(posedge clk);
tx_data= b;
tx_start=1'b1;
@(posedge clk);
tx_start=1'b0;
wait(rx_done == 1'b1);
$display("TX DATA=%d ,RX DATA = %d",tx_data,rx_data);
repeat(20)@(posedge clk);
end 
endtask 

initial 
begin
rst=1;
tx_start=0;
tx_data=8'h00;
repeat(20) @(posedge clk);
rst=0;
@(posedge clk);
send_byte(8'h00);
send_byte(8'h5E);
send_byte(8'hA3);
send_byte(8'hff);
send_byte(8'hC7);
repeat(50)@(posedge clk);
$finish;
end
endmodule
