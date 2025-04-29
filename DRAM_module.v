module Micron (
input clk,
input[1:0] opcode,  
input[9:0] row,
input[9:0] column,
input[31:0] data_in,
output reg[31:0] data_out,
output reg[1:0] error,
input[7:0] temp,
output reg[2:0] current_state_reg
);
reg[31:0] mem [1023:0][1023:0]; //[row][column]
reg[2:0] current_state;
reg[2:0] next_state;
integer i;
integer j;
reg [7:0] temp_reg;
    
parameter Initial =3'b000;
parameter Idle =3'b001;
parameter Read =3'b010;
parameter Write =3'b011;
parameter Refresh =3'b100;
parameter Error =3'b101;


always @ (posedge clk)
    begin
        current_state<=next_state;
            temp_reg <= temp;  // capture temp value
         current_state_reg<=next_state;
    end
  
 
always @(*)
    begin
        $display("opcode=%b, current_state=%b" ,opcode,current_state);
        case(current_state) 
             Initial:
               begin
                  $display("POWER-ON SELF-TEST SUCCESFULL");
                  $display("CONFIGURATION LOADED");
                  $display("CALLIBRATION ADJUSTED ");
                  next_state<=Idle;
               end
             Idle:
               begin
                 if (opcode==2'b01)
                     begin
                     next_state<=Read;
                     end
                     else if(opcode==2'b10)
                     begin
                     next_state<=Write;
                     end
                     else if(opcode==2'b11)
                     begin
                     next_state<=Refresh;
                     end 
                     else 
                     begin
                     next_state<=Idle;
                     end             
               end
             Read:
                begin
                  if(mem[row][column][31]==^mem[row][column][30:0]) 
                    begin
                        data_out<=mem[row][column];
                        $display("Read successfully");
                        next_state<=Idle;
                    end
                  else 
                    begin
                        next_state<=Error;
                        error<=2'b01;
                    end               
                end 
            Write:
                begin
                  if(data_in[31]==^data_in[30:0]) 
                    begin
                        mem[row][column] <= data_in;
                        $display("Written successfully");
                        next_state<=Idle;
                    end
                  else 
                    begin
                        next_state<=Error;
                        error<=2'b10;
                    end               
                end
                                     
            Refresh:
                begin
                if(temp_reg>8'b00101000)      begin
                    $display("Runnning Adaptive refresh");
                   for(i=0;i<=1023;i=i+1)
                   begin
                     for(j=0;j<=1023;j=j+1)
                     begin
                           mem[i][j]<=mem[i][j];
                     end
                     
                   end 
               end
                   if(temp_reg<=8'b00101000)    begin

                  $display("Runnning Scheduled refresh");
                   for(i=0;i<=1023;i=i+1)
                   begin
                     for(j=0;j<=1023;j=j+1)
                     begin
                           mem[i][j]<=mem[i][j];
                     end
                   end 
                   end
                  
                   next_state<=Idle;
            end 
                
            Error:
                 begin
                  if (error==2'b10)begin
                      $display("Error while writing");
                      next_state<=Idle;
                 end
                
                 else if (error==2'b01)begin 
                       $display("Error while reading");
                       next_state<=Idle;
                   end
                  end  
                  
            default: 
                  next_state<=Idle;  
        endcase
     end
endmodule
