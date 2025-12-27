`timescale 1ns / 1ps
module uart_rx #(
parameter clk_hz=50_000_000,
parameter baud_rate=9600)
(input clk,rst,rx,
output reg [7:0]rx_data,rx_done);
localparam CPB=clk_hz/baud_rate;
localparam IDLE=2'b00,
           START=2'b01,
           DATA=2'b10,
           STOP=2'b11;
reg [1:0] state;
reg [15:0]baud_count;reg [2:0]bit_count;reg baud_en;

always @ (posedge clk or posedge rst)
begin
if(rst)
   begin
   state<=IDLE;
   baud_en<=1'b0;
   bit_count<=3'd0;
   rx_data<=8'd0;
   rx_done<=1'b0;
   end
else
   begin
   baud_count<=16'd0;
   bit_count<=3'd0;
   rx_done<=1'b0;
   case(state)
        IDLE:begin
             if(rx==1'b0)
                state<=START;
             else
                state<=IDLE;
             end
       START:begin
             rx_done<=1'b0;
             baud_count<=baud_count;
             baud_en<=1'b1;
             if(baud_en)
                begin
                baud_count<=baud_count+1'b1;
                if(baud_count==CPB/2)
                   begin
                   if(rx==1'b0)
                      begin
                      baud_count<=16'd0;
                      state<=DATA;
                      end
                   else
                      state<=IDLE;
                   end
                 else
                    state<=START;
                 end
              end
         DATA:begin
              rx_done<=1'b0;
              baud_count<=baud_count;
              baud_en<=1'b1;
              bit_count<=bit_count;
              if(baud_en)
                 begin
                 baud_count<=baud_count+1'b1;
                 $display("baud_count = %d",baud_count);
                 if(baud_count==CPB-1)
                    begin
                    rx_data[bit_count]<=rx;
                    baud_count<=16'd0;
                    if(bit_count==3'd7)
                       begin
                       baud_count<=16'd0;
                       bit_count<=3'd0;
                       state<=STOP;
                       end
                     else
                        begin
                        bit_count<=bit_count+1'b1;
                       $display("bit_count = %d",bit_count);
                        end
                     end
                 end
               end
          STOP:begin
               baud_count<=baud_count;
               baud_en<=1'b1;
               if(baud_en)
                  begin
                  baud_count<=baud_count+1'b1;
                  if(baud_count==CPB-1)
                     begin
                     baud_count<=16'd0;
                     if(rx==1'b1)
                        begin
                        rx_done<=1'b1;
                        state<=IDLE;
                        end
                      end
                   else
                      state<=STOP;
                   end
                end
endcase
end
end                  
endmodule
