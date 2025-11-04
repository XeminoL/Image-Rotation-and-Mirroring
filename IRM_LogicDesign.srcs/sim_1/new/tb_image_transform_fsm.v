`timescale 1ns / 1ps
module tb_image_transform_fsm;
 parameter M = 4;
 parameter N = 4;
 reg clk, rst;
 reg [7:0] pixel_in;
 wire [7:0] pixel_out;
 wire [15:0] addr_in, addr_out;
 reg [1:0] mode;
 wire done;
 reg [7:0] RAM_in [0:M*N-1];
 reg [7:0] RAM_out [0:M*N-1];
 image_transform_fsm #(M,N) dut (
 .clk(clk),
 .rst(rst),
 .pixel_in(pixel_in),
 .pixel_out(pixel_out),
 .addr_in(addr_in),
 .addr_out(addr_out),
 .mode(mode),
 .done(done)
 );

 always #5 clk = ~clk;
 always @(*) begin
 pixel_in = RAM_in[addr_in];
 end
 always @(posedge clk) begin
 if (!rst) RAM_out[addr_out] <= pixel_out;
 end
 integer i, j;
 initial begin
 clk = 0; rst = 1; mode = 2'b00;
 RAM_in[0]=1; RAM_in[1]=2; RAM_in[2]=3; RAM_in[3]=4;
 RAM_in[4]=5; RAM_in[5]=6; RAM_in[6]=7; RAM_in[7]=8;
 RAM_in[8]=9; RAM_in[9]=10; RAM_in[10]=11; RAM_in[11]=12;
 RAM_in[12]=13; RAM_in[13]=14; RAM_in[14]=15; RAM_in[15]=16;
 #20 rst = 0;
 wait(done == 1);
 $display("\nẢnh gốc (%0dx%0d):", M, N);
 for (i = 0; i < M; i = i + 1) begin
 for (j = 0; j < N; j = j + 1) begin
 $write("%3d ", RAM_in[i*N + j]);
end

 $display("");
end
 $display("\nẢnh xoay 90° CW:");
 for (i = 0; i < M; i = i + 1) begin
 for (j = 0; j < N; j = j + 1) begin
 $write("%3d ", RAM_out[i*N + j]);
end

 $display("");
end
 #50 $finish;
end
endmodule