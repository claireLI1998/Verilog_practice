module tb_task4();

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.
logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] SW;
logic [9:0] LEDR;

logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_HS, VGA_VS, VGA_CLK;

task4 dut(.*);

initial begin
 CLOCK_50 = 1'b0; #1;
 forever begin
  CLOCK_50 = 1'b1; #1;
  CLOCK_50 = 1'b0; #1;
 end
end

initial begin
 KEY[3] = 1'b0; #10;
 KEY[3] = 1'b1;
 #500000;
 $stop;
 end
endmodule: tb_task4

