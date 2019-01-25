`timescale 1ps / 1ps
module tb_task2();

// Your testbench goes here.
logic CLOCK_50;
logic [3:0] KEY; 
logic [9:0] SW;
logic [8:0] temp, k;
logic [7:0] i, c, j;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic [9:0] LEDR;

task2 dut(.*);

initial begin
CLOCK_50 = 1'b0; #5;
forever begin
CLOCK_50 = 1'b1; #5;
CLOCK_50 = 1'b0; #5;
end 
end 

initial begin
KEY[3] = 1'b1; 
SW = 10'b1100111100; #5;
KEY[3] = 1'b0; #5;
assert(dut.initrdy === 1'b1);
KEY[3] = 1'b1;#20;
assert(dut.initen === 1'b0);
assert(dut.initrdy === 1'b0);
assert(dut.initaddr === 0);
assert(dut.initwrdata === 0);
assert(dut.initwren === 1);
i = 1;
for(temp = 1; temp < 256; temp ++) begin
 #10;
 assert(dut.initaddr === i);
 assert(dut.initwrdata === i);
 assert(dut.initwren === 1);
 i = i + 1;
end
#10;
assert(dut.initdone === 1);
assert(dut.initaddr === 0);
assert(dut.initwrdata === 0);
assert(dut.wren === 1);
#10;
assert(dut.initrdy === 1);
assert(dut.initdone === 1);
assert(dut.initwren === 0);
assert(dut.ksaen === 1);
assert(dut.ksardy === 1);
assert(dut.wren === 0);
#100;
i = 1;
for(temp = 1; temp < 256; temp ++) begin
#10;
assert(dut.ksaaddr === i);
assert(dut.addr === (i - 1));
#80;
assert(dut.ksaaddr === i);
assert(dut.wren === 1);
assert(dut.ksawren === 1);
i = i + 1;
end
#100;
$display("Test passed");
$stop;
end

initial begin
#2700;
c = 1;
for(k = 1; k < 256; k ++) begin
assert(dut.k.count === c);
assert(dut.k.i === k);
assert(dut.k.addr === k - 1);
assert(dut.k.wrdata === dut.k.jVal);
assert(dut.k.wren === 1);
#10;
c = c + 1;
assert(dut.k.count === c);
c = c + 1;
#10;
assert(dut.k.count === c);
c = c + 1;
#10;
assert(dut.k.count === c);
c = c + 1;
#10;
assert(dut.k.count === c);
assert(dut.k.iAddr === k);
c = c + 1;
#10;
assert(dut.k.count === c);
assert(dut.k.iVal === dut.k.rddata);

c = c + 1;
#10;
assert(dut.k.count === c);
c = c + 1;
#10;
assert(dut.k.count === c);
c = c + 1;
#10;
assert(dut.k.count === c);
assert(dut.k.jVal === dut.k.rddata);
assert(dut.k.addr === dut.k.j);
assert(dut.k.wrdata === dut.k.iVal);
assert(dut.k.wren === 1);
c = 1;
#10;
end
end

endmodule: tb_task2
