`timescale 1ps/1ps

module tb_new_single_cycle;

  // Inputs
  logic        tb_clk   ; 
  logic        tb_rst   ;
  logic [3:0]  tb_io_btn;
  logic [17:0] tb_io_sw ;

  // Outputs
  logic        tb_insn_vld;             	
  logic [31:0] tb_io_ledg ; 
  logic [31:0] tb_pc_debug; 
  logic [31:0] tb_io_ledr ;
  logic [31:0] tb_io_lcd; 
  logic [6:0]  tb_io_hex0, tb_io_hex1, tb_io_hex2, tb_io_hex3, tb_io_hex4, tb_io_hex5, tb_io_hex6, tb_io_hex7;
  logic [31:0] tb_alu, tb_wb, tb_ld; 

  logic [17:0] tb_sram_addr; 
  wire [15:0] tb_sram_dq; 
  logic tb_ce, tb_we, tb_lb, tb_ub, tb_oe; 

  // Instantiate the singlecycle module
    new_single_cycle uut (
        .i_clk (tb_clk),
        .i_rst (tb_rst),
        .i_io_sw (tb_io_sw),
        .i_io_btn (tb_io_btn), 
        .o_insn_vld (tb_insn_vld),
        .o_io_ledr (tb_io_ledr),
        .o_io_ledg (tb_io_ledg),
        .o_pc_debug (tb_pc_debug),  
        .o_io_hex0 (tb_io_hex0), 
        .o_io_hex1 (tb_io_hex1), 
        .o_io_hex2 (tb_io_hex2), 
        .o_io_hex3 (tb_io_hex3), 
        .o_io_hex4 (tb_io_hex4), 
        .o_io_hex5 (tb_io_hex5), 
        .o_io_hex6 (tb_io_hex6),  
        .o_io_hex7 (tb_io_hex7), 
        .o_io_lcd (tb_io_lcd), 
        .o_sram_addr (tb_sram_addr), 
        .o_sram_dq (tb_sram_dq), 
        .o_ce (tb_ce), 
        .o_we (tb_we), 
        .o_lb (tb_lb), 
        .o_ub (tb_ub),
        .o_oe (tb_oe), 
        .o_test_alu_data (tb_alu), 
        .o_test_ld_data (tb_ld), 
        .o_test_wb_data (tb_wb)
    );

  // Clock generation
    initial begin
        tb_clk = 0;
        forever #5 tb_clk = ~tb_clk; // Clock period of 10 time units
    end

  // Testbench stimulus
  initial begin
    // Initialize inputs
    tb_rst = 1           ;
    tb_io_sw = 32'h00000000;  

    // Apply reset for 500ps
    #20;
    tb_rst = 0     ;
    tb_io_btn = 4'b1111;
    tb_io_sw = 18'h1FFFF;
    #15000 tb_rst = 1    ;
  end
  
  // Display hexadecimal outputs with labels
  initial begin
    $monitor("Time: %0t | tb_io_hex0: %h | tb_io_hex1: %h | tb_io_hex2: %h | tb_io_hex3: %h | tb_io_hex4: %h | tb_io_hex5: %h | tb_io_hex6: %h | tb_io_hex7: %h", 
             $time, tb_io_hex0, tb_io_hex1, tb_io_hex2, tb_io_hex3, tb_io_hex4, tb_io_hex5, tb_io_hex6, tb_io_hex7);
  end
endmodule 