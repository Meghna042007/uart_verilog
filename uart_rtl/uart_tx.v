`timescale 1ns / 1ps  
module uart_tx #(
parameter CPB =50000000/115200)//baud_rate=115200
(input clk,rst,tx_start,
input [7:0] tx_data,
output reg tx,tx_busy);
localparam IDLE=2'b00,
           START=2'b01,
           DATA=2'b10,
           STOP=2'b11;
reg [1:0] state;

reg [15:0]baud_count;reg [3:0]bit_count;reg [7:0]data_reg;reg baud_en;

always @ (posedge clk or posedge rst)
begin
if(rst)
   begin
   state<=IDLE;
   tx<=1'b1;
   tx_busy<=1'b0;
   baud_count<=16'd0;
   bit_count<=3'd0;
   baud_en<=1'b1;
   data_reg<=8'd0;
   end 
else
   begin
   case(state)
        IDLE:begin
             if(tx_start)
                begin
                data_reg<=tx_data;
                tx<=1'b0;
                tx_busy<=1'b0;
                state<=START;
                end
             else
               state<=IDLE;
             end
       START:begin
             tx_busy<=1'b0;
             if(baud_count==CPB-1)
               begin
               baud_count<=0;
               state<=DATA;
               end 
              else
                 begin
                 baud_count<=baud_count+1'b1;
                 state<=START;
                 end
             end
        DATA:begin
             tx_busy<=1'b1;
             if(baud_count==CPB-1)
                begin
                if(bit_count==4'd8)
                   begin
                   baud_count<=0;
                   bit_count<=0;
                   state<=STOP;
                   end
                else
                   begin
                   tx<=data_reg[bit_count];
                   baud_count<=0;
                   bit_count<=bit_count+1'b1;
                   state<=DATA;
                   end  
                 end
              else
                 begin
                 baud_count<=baud_count+1'b1;
                 state<=DATA;
                 end
              end
         STOP:begin
              tx<=1'b1;
              if(baud_count==CPB-1)
                 begin
                 tx_busy<=1'b0;
                 baud_count<=0;
                 state<=IDLE;
                 end
               else
                  begin
                  baud_count<=baud_count+1'b1;
                  state<=STOP;
                  end
              end
      
 endcase
end
end              
endmodule

