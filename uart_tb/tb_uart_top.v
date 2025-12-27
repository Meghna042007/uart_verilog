`timescale 1ns / 1ps
module tb_uart_top();
reg clk=0;
always #10 clk =~clk;

reg rst,tx_start;
reg [7:0]tx_data;
wire [7:0]rx_data;
wire rx_done;

uart_top dut3(.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.rx_data(rx_data),.rx_done(rx_done));

initial
begin
rst=1;
tx_start=0;
tx_data=8'h00;
repeat(10) @(posedge clk);
rst=0;
@(posedge clk);
tx_data=8'h55;
tx_start=1'b1;
@(posedge clk);
tx_start=1'b0;
wait(rx_done);
$display("RX DATA = %h",rx_data);
#100;
$finish;
end
endmodule
