`timescale 1ns / 1ps
module uart_tx #(
parameter clk_hz=50_000_000,
parameter baud_rate=9600)
(input clk,rst,tx_start,
input [7:0] tx_data,
output reg tx,tx_busy);
localparam CPB=clk_hz/baud_rate;
localparam IDLE=2'b00,
           START=2'b01,
           DATA=2'b10,
           STOP=2'b11;
reg [1:0] state;

reg [15:0]baud_count;reg [2:0]bit_count;reg [7:0]data_reg;reg baud_en;

always @ (posedge clk or posedge rst)
begin
if(rst)
   begin
   state<=IDLE;
   tx<=1'b1;
   tx_busy<=1'b0;
   bit_count<=3'd0;
   baud_en<=1'b0;
   data_reg<=8'd0;
   end 
else
   begin
   baud_count<=16'd0;
   bit_count<=3'd0;
   case(state)
        IDLE:begin
             if(tx_start)
                begin
                data_reg<=tx_data;
                tx<=1'b0;
                tx_busy<=1'b1;
                bit_count<=1'b0;
                state<=START;
                end
             else
               state<=IDLE;
             end
       START:begin
             baud_count<=baud_count;
             baud_en<=1'b1;
             tx_busy<=1'b1;
             if(baud_en)
                   begin
                   baud_count<=baud_count+16'd1;
                   if(baud_count== CPB-1)begin
                      baud_count<=16'd0;
                      state<=DATA;end
                   else
                      state<=START;
                   end
             end
        DATA:begin
             baud_count<=baud_count;
             baud_en<=1'b1;
             bit_count<=bit_count;
             if(baud_en)
                begin
                baud_count<=baud_count+16'd1;
                if(baud_count== CPB-1)
                   begin
                   tx<=data_reg[bit_count];
                   baud_count<=16'd0;
                   if(  bit_count==3'd7)
                   begin
                   baud_count<=16'd0;
                   state<=STOP;
                   bit_count<=3'd0;
                   end
                   else
                      begin
                      bit_count<=bit_count+3'b1;
                      state<=DATA;
                      end
                   end
                 else
                   state<=DATA; 
                 end
              end
         STOP:begin
              baud_count<=baud_count;
              baud_en<=1'b1;
              tx<=1'b1;
              if(baud_en)
                begin
                baud_count<=baud_count+16'd1;
                if(baud_count==CPB-1)
                   begin
                   tx_busy<=1'b0;
                   state<=IDLE;
                   end
                else
                   state<=STOP;
                end
              end
      
 endcase
end
end              
endmodule
