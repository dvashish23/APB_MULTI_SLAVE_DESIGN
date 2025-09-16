//***************************************************************
//
// Author :- Saroj Ashish
// Designation :- Design and Verification Engineer
//
//***************************************************************

module mod_n_cntr #(parameter N=1)
                     (
                       input clk,
                       input rstn,
                       output [4:0] cnt
                     );

  reg [4:0]cnt_r;
  assign cnt = cnt_r;

  //MOD - N counter logic 
  always@(posedge clk or negedge rstn)
    begin
      if(!rstn) // active low
        begin
          cnt_r <= {5{1'h0}};
        end
      else
        begin
          if(cnt_r < N)
            begin
              cnt_r <= cnt_r + 1'b1;
            end
          else
            begin
              cnt_r <= 1'b0;
            end
        end
    end

endmodule
