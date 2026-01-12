`timescale 1ns / 1ps    
module uart_rx #(
parameter CPB=50000000/115200)//baud_rate=115200
(input clk,rst,rx,
output reg [7:0]rx_data,
output reg rx_done);
localparam IDLE=2'b00,
           START=2'b01,
           DATA=2'b10,
           STOP=2'b11;
reg [1:0] state;
reg [15:0]baud_count;reg [3:0]bit_count;reg baud_en;

always @ (posedge clk or posedge rst)
begin
if(rst)
   begin
   state<=IDLE;
   baud_en<=1'b1;
   baud_count<=16'b0;
   bit_count<=3'd0;
   rx_data<=8'd0;
   rx_done<=1'b0;
   end
else
   begin
   case(state)
        IDLE:begin
             if(rx==1'b0)
                state<=START;
             else
                state<=IDLE;
             end
       START:begin
             if(baud_count==((CPB)/2 -1))
                begin
                if(rx==1'b0)
                   begin
                   baud_count<=1'b0;
                   state<=DATA;
                   end
                 else
                    state<=IDLE;
                 end
               else
                  begin
                  baud_count<=baud_count+1'b1;
                  state<=START;
                  end
              end
         DATA:begin
              if(baud_count==(CPB-1))
                 begin
                 if(bit_count==4'd8)
                    begin
                    baud_count<=0;
                    bit_count<=0;
                    state<=STOP;
                    end 
                  else
                     begin
                     rx_data[bit_count]<=rx;
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
               if(baud_count==(CPB-1))
                  begin
                  baud_count<=0;
                  if(rx==1'b1)
                     begin
                     rx_done<=1'b1;
                     state<=IDLE;
                     end
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
