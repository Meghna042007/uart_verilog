 `timescale 1ns / 1ps 
module uart_top(
input clk,rst,tx_start,
input [7:0]tx_data,
output [7:0]rx_data,
output rx_done);

wire tx;
wire uart_line;
wire tx_busy;

uart_tx tx_inst(
.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.tx_busy(tx_busy));

assign uart_line = tx_busy?tx:1'b1;

uart_rx rx_inst(
.clk(clk),.rst(rst),.rx(uart_line),.rx_data(rx_data),.rx_done(rx_done));

endmodule
