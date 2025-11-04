`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 08:51:22 AM
// Design Name: 
// Module Name: image_transform_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module image_transform_fsm #(
  parameter M = 256,  
  parameter N = 256    
)(
  input clk,
  input rst,
  input [7:0] pixel_in,       
  output reg [7:0] pixel_out, 
  output reg [15:0] addr_in,  
  output reg [15:0] addr_out, 
  input [1:0] mode,           
  output reg done             
);
localparam S_INIT  = 3'b000,
           S_READ  = 3'b001,
           S_MAP   = 3'b010,
           S_WRITE = 3'b011,
           S_NEXT  = 3'b100,
           S_DONE  = 3'b101;

reg [2:0] state, next_state;
reg [15:0] x, y;    
reg [15:0] x_new, y_new; 

always @(posedge clk or posedge rst) begin
  if (rst) state <= S_INIT;
    else state <= next_state;
end

always @(*) begin
  next_state = state;
    case(state)
      S_INIT:   next_state = S_READ;
      S_READ:   next_state = S_MAP;
      S_MAP:    next_state = S_WRITE;
      S_WRITE:  next_state = S_NEXT;
      S_NEXT:   next_state = (x == M) ? S_DONE : S_READ;
      S_DONE:   next_state = S_DONE;
      endcase
end

always @(posedge clk or posedge rst) begin
  if (rst) begin
    x <= 0;
    y <= 0;
    done <= 0;
    addr_in <= 0;
    addr_out <= 0;
    end
  else begin
    case(state)
      S_INIT: begin
        x <= 0;
        y <= 0;
        done <= 0;
end

S_READ: begin 
  addr_in <= x * N + y;   
end

S_MAP: begin
  case(mode)
    2'b00: begin 
      x_new <= y;
      y_new <= M - 1 - x;
end
   
2'b01: begin 
  x_new <= N - 1 - y;
  y_new <= x;
end

2'b10: begin 
  x_new <= x;
  y_new <= N - 1 - y;
end
                        
2'b11: begin 
  x_new <= M - 1 - x;
  y_new <= y;
end

endcase
end

S_WRITE: begin
  addr_out <= x_new * N + y_new;
  pixel_out <= pixel_in;
end

S_NEXT: begin
  if (y < N-1) begin
  y <= y + 1;
  end else begin
  y <= 0;
  x <= x + 1;
  end
end

S_DONE: begin
  done <= 1;
end
    
endcase
end
end
endmodule