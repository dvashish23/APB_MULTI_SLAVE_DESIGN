//***************************************************************
//
// Author :- Saroj Ashish
// Designation :- Design and Verification Engineer
//
//***************************************************************

parameter MEM_DEPTH = 256;
parameter DELAY     = 0;

module tb;

bit clk;
bit rst;
bit penable, psel, pwrite, pready,pslverr;
bit [7:0] paddr;
bit [31:0] pwdata, prdata;

  //apb slave wrapper dut instantiation
apb_slave_wrap  dut (
                     .pclk(clk), 
                     .presetn(rst), 
                     .psel(psel), 
                     .penable(penable), 
                     .pwrite(pwrite), 
                     .pready(pready), 
                     .paddr(paddr), 
                     .pwdata(pwdata), 
                     .prdata(prdata), 
                     .pslverr(pslverr)  
                    );
  
initial begin
 clk = 1'b0;
 rst = 1'b0;

 forever #10 clk=~clk;
end

initial begin
 @(posedge clk);
 @(posedge clk);
 #1;
  //making rst deasserted
 rst = 1'b1;
 psel = 1'b1;
 paddr = 8'b10_00_0011; // selection of 3rd slave and doing write operation
 pwrite = 1'b1;
 pwdata = 'h55ffaaff;
 @(posedge clk); #1;
 penable = 1'b1;
  wait(pready==1)  // waiting for p ready to get high
  begin
   @(posedge clk);#1; 
   penable = 1'b0;
   pwrite = 1'b0;
   psel = 1'b0;
  end


// selection of 1st slave and doing write operation
 @(posedge clk); #1;
 psel = 1'b1;
 paddr = 8'b00_00_0101;
 pwrite = 1'b1;
 pwdata = 100;
 @(posedge clk); #1;
 penable = 1'b1;
  wait(pready==1)   // waiting for p ready to get high
  begin
    @(posedge clk);  #1;
    penable = 1'b0;
    pwrite = 1'b0;
    psel = 1'b0;
  end
 // selection of 3rd slave and doing read operation
 @(posedge clk); #1;
 psel = 1'b1;
 paddr = 8'b10_00_0011;
 pwrite = 1'b0;
 @(posedge clk); #1;
 penable = 1'b1;
  wait(pready==1)   // waiting for p ready to get high
  begin
   @(posedge clk); #1; 
   penable = 1'b0;
   pwrite = 1'b0;
   psel = 1'b0;
  end

end
// creating dumpfile 
initial begin
 $dumpvars();
 $dumpfile("dump.vcd");
end

// stoping the stimalus
initial begin
 #1000; 
 $finish();
end

endmodule:tb

