//***************************************************************
//
// Author :- Saroj Ashish
// Designation :- Design and Verification Engineer
//
//***************************************************************

module apb_slave_wrap #(parameter DATA_WDTH = 32, parameter ADDR_WDTH = 8)
                       (
                         input pclk, presetn,   // global clk and rst of apb
                         input psel, penable, pwrite,
                         input [ADDR_WDTH-1:0] paddr, 
                         input [DATA_WDTH-1:0] pwdata,
                         output [DATA_WDTH-1:0] prdata,
                         output pready, pslverr,intr 
                       );

  wire [3:0] psel_w;
  wire [3:0] pready_w;
  wire [3:0] pslverr_w;

  wire [DATA_WDTH-1:0] prdata_0;
  wire [DATA_WDTH-1:0] prdata_1;
  wire [DATA_WDTH-1:0] prdata_2;

  assign psel_w[0] = psel & (paddr[7:6] == 2'b00);
  assign psel_w[1] = psel & (paddr[7:6] == 2'b01);
  assign psel_w[2] = psel & (paddr[7:6] == 2'b10);
  assign psel_w[3] = psel & (paddr[7:6] == 2'b11);
  assign intr      = (psel_w[3] == 1'b1) ? 1'b1 : 1'b0;

  assign pready   = pready_w[0]  | pready_w[1]  | pready_w[2];
  assign pslverr  = pslverr_w[0] | pslverr_w[1] | pslverr_w[2];
  assign prdata   = prdata_0     | prdata_1     | prdata_2;

  apb_slave #(DATA_WDTH,ADDR_WDTH,20) apb_slave_inst_0
             (
               .pclk             (pclk          ),
               .presetn          (presetn       ),
               .psel             (psel_w[0]     ),
               .penable          (penable       ), 
               .pwrite           (pwrite        ),
               .paddr            (paddr         ),
               .pwdata           (pwdata        ),
               .prdata           (prdata_0      ),
               .pready           (pready_w[0]   ),
               .pslverr          (pslverr_w[0]  )
             );

  apb_slave #(DATA_WDTH,ADDR_WDTH,36) apb_slave_inst_1
             (
               .pclk             (pclk          ),
               .presetn          (presetn       ),
               .psel             (psel_w[1]     ),
               .penable          (penable       ), 
               .pwrite           (pwrite        ),
               .paddr            (paddr         ),
               .pwdata           (pwdata        ),
               .prdata           (prdata_1      ),
               .pready           (pready_w[1]   ),
               .pslverr          (pslverr_w[1]  )
             );

  apb_slave #(DATA_WDTH,ADDR_WDTH,54) apb_slave_inst_2
             (
               .pclk             (pclk          ),
               .presetn          (presetn       ),
               .psel             (psel_w[2]     ),
               .penable          (penable       ), 
               .pwrite           (pwrite        ),
               .paddr            (paddr         ),
               .pwdata           (pwdata        ),
               .prdata           (prdata_2      ),
               .pready           (pready_w[2]   ),
               .pslverr          (pslverr_w[2]  )
             );

endmodule:apb_slave_wrap
