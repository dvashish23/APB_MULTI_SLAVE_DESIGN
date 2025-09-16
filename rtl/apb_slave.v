//***************************************************************
//
// Author :- Saroj Ashish
// Designation :- Design and Verification Engineer
//
//***************************************************************

module apb_slave #(parameter DATA_WDTH = 8, parameter ADDR_WDTH = 8, parameter BOUND_ADDR = 100)
             ( input presetn, pclk, psel, penable, pwrite,
               input [ADDR_WDTH-1:0] paddr, 
               input [DATA_WDTH-1:0] pwdata,
               output [DATA_WDTH-1:0] prdata,
               output pready, pslverr
             );
  
                       
  parameter MEM_DEPTH = 256;
  parameter DELAY     = 0;

  reg [7:0] mem [0:MEM_DEPTH-1];
  wire [4:0] counter;
  reg cnt_rstn;

  reg pslverr_r;
  reg prdy_r;

  integer i;
  integer j;
  integer k;

  reg [DATA_WDTH-1:0] prdata_r;

  reg [1:0] curr_st;
  reg [1:0] nxt_st;
  
  parameter idle      = 2'b00;
  parameter setup     = 2'b01;
  parameter access    = 2'b10;
  
  
  assign pslverr = pslverr_r;
  assign pready  = prdy_r;
  assign prdata  = prdata_r;

  always@(posedge pclk or negedge presetn)
    begin
      if(~presetn) //active low
        begin
          curr_st   <= idle;  //jumps to idle state
          prdata_r  <= {DATA_WDTH{1'h0}};
     	    prdy_r    <= 1'b0;
      	  pslverr_r <= 1'b0;
          cnt_rstn  <= 1'b0;
          for(i=0;i<MEM_DEPTH;i++)
            begin
              mem[i] <= {8{1'h0}};   //memory initializing to 0
       	    end
        end
      else
        begin
          curr_st <= nxt_st;
        end
    end

  mod_n_cntr #(DELAY) delay_cntr
                                (
                                 .clk(pclk),
                                 .rstn(cnt_rstn),
                                 .cnt(counter)
                                );

  always@(*)
    begin
      case(curr_st)
        idle:
          begin   //initializing all the outputs
            prdata_r  = {DATA_WDTH{1'h0}};
            prdy_r    = 1'b0;
            pslverr_r = 1'b0;
            cnt_rstn  = 1'b0;
            if(psel)
              nxt_st = setup;
            else
              nxt_st = idle;
          end
        setup:  //start of transition
          begin
            if(psel) 
              begin
               if(penable)  
                 nxt_st = access;
               else
                 nxt_st = setup;
              end
            else
              nxt_st = idle;
            
            cnt_rstn = 1'b0;
            prdy_r    = 1'b0;
          end
               
        access:
          begin
            cnt_rstn   = 1'b1;
            if(pwrite)   //during write operation
              begin
                if(paddr[5:0]<=BOUND_ADDR)  //checking if the addr range
                   begin
                     for(j=0; j<=3; j=j+1)
                       begin
                         mem[paddr[5:0] + j] = pwdata[j*8+:8];  //writing the data into particular location
                       end
                     pslverr_r  = 1'b0;     
                     if(counter == DELAY)
                       begin
                         prdy_r   = 1'b1;
                         if(psel) //if it is same slave operation then
                           nxt_st = setup;
                         else
                           nxt_st = idle;
                       end
                     else
                       nxt_st   = access; 
                   end 
                else
                   begin
                     if(counter == DELAY)
                       begin
                         pslverr_r  = 1'b1;                                              
                         prdy_r     = 1'b1;
                         if(psel) //if it is same slave operation then
                           nxt_st = setup;
                         else
                           nxt_st = idle;
                       end
                     else
                       begin
                         nxt_st     = access;
                       end
                   end
              end
            else
              begin
                if(paddr[5:0]<=BOUND_ADDR)
                  begin
                    for(k=0; k<=3; k=k+1)
                      begin
                        prdata_r[k*8+:8]    = mem[paddr[5:0] + k]; // reading from the memory location
                      end
                    pslverr_r   = 1'b0;
                    prdy_r      = 1'b1;
                  end
                else
                  begin
                    pslverr_r   = 1'b1;
                    prdy_r      = 1'b1;
                  end
               if(psel) //if it is same slave operation then
                 nxt_st = setup;
               else
                 nxt_st = idle;
              end
          end
           
        default: curr_st = idle;
      endcase
    end

endmodule:apb_slave
