# APB_MULTI_SLAVE_DESIGN
--> This project is compatible with AMBA APB (ADVANCE PERIPHERAL BUS).

✅ PROJECT OVERVIEW ✅
--> This project implements an AMBA APB (Advanced Peripheral Bus) architecture with 3 slave devices. 
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
