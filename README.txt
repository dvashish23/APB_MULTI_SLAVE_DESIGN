# APB_MULTI_SLAVE_DESIGN
--> This project is compatible with AMBA APB (ADVANCE PERIPHERAL BUS).

✅ PROJECT OVERVIEW ✅                                                
--> This project implements an AMBA APB (Advanced Peripheral Bus) architecture with 3 slave devices, an 8-bit address bus, and a 32-bit data bus. The master interface communicates with slaves using address decoding, ready/valid handshakes, and error signaling.                  
--> The design enables communication between a master (or processor/HLE) and multiple APB slaves in a simple, efficient, and low-power manner.

--> The APB protocol is widely used in SoC designs for connecting low-bandwidth peripherals such as timers, GPIO, UART, and more.                             
--> This project serves as a reference design and learning resource for students, beginners, and professionals working in SoC/RTL design and verification.


✅ FEATURES ✅                              
--> Master Interface: A single master (processor/HLE) initiates read/write transactions.              
--> 3 APB Slaves: Each slave can be independently accessed via address decoding logic.             
--> Address Decoder: Routes master transactions to the correct slave.                        
--> Read/Write Support: Handles both read and write transactions at one time.                   
--> Protocol Compliance: Follows APB standard handshake mechanism (PSEL, PENABLE, PREADY).              
--> Reusable Logic: Modular Verilog implementation for scalability.       


✅ DESIGN SPECIFICATION ✅        
   🔹 Address Decoding (Slave Selection)                   
      --> Master Interface has to access any of 3 slave then he has some specific address value to decode the slave                                      
      PADDR = 8'h00 → APB Slave 1 selected                            
      PADDR = 8'h01 → APB Slave 2 selected                         
      PADDR = 8'h02 → APB Slave 3 selected                            
      PADDR = 8'h03 → No Slave Selected → generates error interrupt to master                         

   🔹 Ready Signal (PREADY)                               
      --> Each slave can insert a programmable wait state.                           
      --> PREADY can be delayed 1 to 16 cycles before transaction completion.    
      --> Configurable PREADY delay per slave.
   
   🔹 Transaction Rules                                   
      --> At once only one transaction (either read or write) can occur.                                        
      --> Transactions follow standard APB handshake:                               
            PSEL → PENABLE → PREADY → PSLVERR (if any)                           
   
   🔹 Error Handling (PSLVERR)                                 
      --> PSLVERR is asserted when:                          
      --> Invalid slave address will be transfered.                      
      --> Accessing beyond defined address range of each slave.                        
      --> Address boundary rules:                     
      Slave 1 → Valid range: 0 – 20 | Reserved: 21 – 64                          
      Slave 2 → Valid range: 0 – 36 | Reserved: 37 – 64                   
      Slave 3 → Valid range: 0 – 54 | Reserved: 55 – 64                        
      --> PSLVERR validity condition:                                     
          PSEL & PENABLE & PREADY must be HIGH simultaneously.                              

  🔹 Reset Behavior
     --> Define what happens on reset (PRDATA=0, PSLVERR=0).
     --> This is standard in most IP specs.

     
  🔹 Design Parameters                                  
     --> Address width: 8 bits                                 
     --> Data width: 32 bits                          
     --> Delay: 1–16 cycles                               
     --> Memory Depth: 256 bytes                                   
     --> Boundary Address: 20 ranges

  🔹 Signal Descriptions
      --> A table of all important signals:                              
            Signal	      Direction	            Width	              Description                                           
            PCLK     --      Input    --         1     --        apb clk which will work approx 100 Mhz from clock controller                        
            PRESETn  --      Input    --         1     --        Active Low Reset signal from master                          
            PADDR	 --      Input	  --         8	   --        Address bus from master                                
            PWDATA	 --      Input    --         32	   --        Write data bus from master                                 
            PRDATA	 --      Output   --         32	   --        Read data bus from slave                                
            PWRITE	 --      Input    --         1	   --        Write=1, Read=0                                          
            PSEL	 --      Input	  --         1	   --        Slave select from master                                 
            PENABLE	 --      Input    --         1	   --        Enable signal for access phase from master                       
            PREADY	 --      Output   --         1	   --        Slave ready (wait state are inserted)                                
            PSLVERR	 --      Output   --         1	   --        Slave error response                                              
    

    


