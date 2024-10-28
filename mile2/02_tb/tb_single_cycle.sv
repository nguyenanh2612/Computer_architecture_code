`timescale 1ps/1ps

module tb_single_cycle;

  // Inputs
  logic        tb_clk   ; 
  logic        tb_rst_n ;
  //logic [3:0]  tb_io_btn;
  logic [31:0] tb_io_sw ;

  // Outputs
  logic        tb_insn_vld;             	
  logic [31:0] tb_io_ledg ; 
  logic [31:0] tb_pc_debug; 
  logic [31:0] tb_io_ledr ;
  logic [31:0] tb_io_lcd; 
  logic [6:0]  tb_io_hex0, tb_io_hex1, tb_io_hex2, tb_io_hex3, tb_io_hex4, tb_io_hex5, tb_io_hex6, tb_io_hex7;
  logic [31:0] tb_wb_data, tb_instruct,tb_ld_data; 

  // Instantiate the singlecycle module
    single_cycle uut (
        .i_clk (tb_clk),
        .i_rst_n (tb_rst_n),
        .i_io_sw (tb_io_sw),
        .o_insn_vld (tb_insn_vld),
        .o_io_ledr (tb_io_ledr),
        .o_io_ledg (tb_io_ledg),
        .o_pc_debug (tb_pc_debug),  
        .o_test_wb_data (tb_wb_data), 
		  .o_test_instruct (tb_instruct),
		  .o_test_ld_data (tb_ld_data),
        .o_io_hex0 (tb_io_hex0), 
        .o_io_hex1 (tb_io_hex1), 
        .o_io_hex2 (tb_io_hex2), 
        .o_io_hex3 (tb_io_hex3), 
        .o_io_hex4 (tb_io_hex4), 
        .o_io_hex5 (tb_io_hex5), 
        .o_io_hex6 (tb_io_hex6),  
        .o_io_hex7 (tb_io_hex7), 
        .o_io_lcd (tb_io_lcd)
    );

  // Clock generation
    initial begin
        tb_clk = 0;
        forever #5 tb_clk = ~tb_clk; // Clock period of 10 time units
    end

  // Testbench stimulus
  initial begin
    // Initialize inputs
    tb_rst_n = 1           ;
    tb_io_sw = 32'h00000000;  

    // Apply reset for 500ps
    #20;
    tb_rst_n = 0     ;
    tb_io_sw = 32'hFFFFFFFF;
    #40000 tb_rst_n = 1    ;
  end

endmodule 