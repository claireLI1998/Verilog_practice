module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata,
           output logic [7:0] wrdata, output logic wren);

logic [7:0] j;
logic signed [8:0] i;
logic [7:0] iVal;
logic [7:0] jVal;
logic [7:0] iAddr;
logic [7:0] jAddr;
logic [3:0] count;
logic [7:0] keyVal;
logic done, protocol;

 always_ff @(posedge clk or negedge rst_n) begin
 if(rst_n == 1'b0) begin
  rdy = 1'b1;
  protocol = 1'b0;
 end 
 
 else if(en == 1'b1) begin
  protocol = 1'b1;
  rdy = 1'b0;
 end 
 
 else if(done == 1) begin
  rdy = 1'b1;
 end
 
end 
 always @(*) begin
 case(i % 3)
  2: keyVal = key[7:0];
  1: keyVal = key[15:8];
  0: keyVal = key[23:16];
  default: keyVal = 8'b0;
 endcase
end
 
assign done = (i[8] == 1'b1);
 always@(posedge clk or negedge rst_n) begin
 if(rst_n == 1'b0)begin
  j = 0;
  i = 0;
  count = 0;
  addr = 0;
  wren = 0;
 end
 
 else if(protocol == 1'b1 && done == 1'b0)begin//2
  if(count == 0) begin
   j = 0;
   i = 0;
   wren = 0;
   count = count + 1;
  end 
  
  else if(count == 1) begin
   addr = i;
   wren = 0;
   count = count + 1;
  end 
  
  else if(count == 2) begin
   wren = 0;
   count = count + 1; //wait a cycle
  end 
  
  else if(count == 3) begin
   wren = 0;
   count = count + 1; //wait a cycle
  end 
  
  else if(count == 4) begin
   iVal = rddata; //get s[i]
   iAddr = i;
   j = (j + iVal + keyVal) % 256;
   count = count + 1;
   wren = 0;
  end 
  
  else if(count == 5) begin
   addr = j;
   wren = 0;
   count = count + 1;
  end 
  
  else if(count == 6) begin
   wren = 0;
   count = count + 1;
  end 
  
  else if(count == 7) begin
   wren = 0;
   count = count + 1;
  end 
  
  else if(count == 8) begin
   jVal = rddata;
   jAddr = j;
   addr = j;
   wrdata = iVal; //s[j] = iVal;
   wren = 1;
   count = count + 1;
  end 
  
  else begin//1
   addr = i;
   wrdata = jVal; //s[i] = jVal;
   i = i + 1; 
   wren = 1;
   count = 1;
  end//1
  
 end//2
 
 else begin 
  wren = 0;
 end 
end
endmodule: ksa
