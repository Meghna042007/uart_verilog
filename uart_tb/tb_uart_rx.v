`timescale 1ns / 1ps
module tb_uart_rx;
  reg clk;
  reg rst;
  reg rx;wire [7:0] rx_data;
  wire rx_done;
  uart_rx dut2 (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_data(rx_data),
    .rx_done(rx_done)
  );

  always #10 clk = ~clk; 
  task send_uart_byte(input [7:0] data);
    integer i;
    begin
      rx = 1'b0;
      repeat (dut2.CPB) @(posedge clk);

      for (i = 0; i < 8; i = i + 1) begin
        rx = data[i];
        repeat (dut2.CPB) @(posedge clk);
      end

      rx = 1'b1;
      repeat (dut2.CPB) @(posedge clk);
    end
  endtask

  initial begin
    clk = 0;
    rst = 1;
    rx  = 1;      
$monitor($time," rst=%b , rx=%b , rx_data=%d , rx_done=%b",rst,rx,rx_data,rx_done);
    repeat (5) @(posedge clk);
    rst = 0;

    repeat (10) @(posedge clk);
    send_uart_byte(8'h55);

    wait (rx_done);

    repeat (100) @(posedge clk);
    $finish;
  end

endmodule
