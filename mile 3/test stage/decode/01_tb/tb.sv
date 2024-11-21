`timescale 1ps/1ps

module tb;
    // Clock and Reset
    logic tb_clk, tb_rst; 

    // Inputs
    logic tb_rd_wren;
    logic [31:0] tb_instruct;
    logic [31:0] tb_rd_data;  

    // Outputs
    logic [31:0] tb_rs1_data, tb_rs2_data; 
    logic [31:0] tb_imme_value; 

    // Instantiate the Unit Under Test (UUT)
    decode_stage uut (
        .i_clk        (tb_clk),
        .i_rst        (tb_rst),
        .i_rd_wren    (tb_rd_wren), 
        .i_instruct   (tb_instruct), 
        .i_rd_data    (tb_rd_data),
        .o_rs1_data   (tb_rs1_data), 
        .o_rs2_data   (tb_rs2_data), 
        .o_imme_value (tb_imme_value)
    ); 

    // Generate clock
    initial begin
        tb_clk = 0; 
        forever #5 tb_clk = ~tb_clk; 
    end

    // Test sequence
    initial begin
        $display("Starting test...");

        // Reset
        tb_rst = 1;
        tb_rd_wren = 0;
        tb_instruct = 0;
        tb_rd_data = 0;
        #40;
        tb_rst = 0;

        // Test case 1
        #10;
        tb_instruct = 32'b00000000001000010000000100110011; // Example instruction
        tb_rd_wren = 1;
        tb_rd_data = 32'h00410133;
        // Wait for outputs to stabilize
        #20;
        check_results(32'h00410133, 32'h00410133, 32'h00000000);

        // Test case 2
        #10;
        tb_instruct = 32'b00000000001000010000000110110011; // Another example instruction
        tb_rd_data = 32'h44556677;
        // Wait for outputs to stabilize
        #20;
        check_results(32'h00410133, 32'h00410133, 32'h00000000); 
    end

    // Task to check results
    task check_results(input logic [31:0] expected_rs1, input logic [31:0] expected_rs2, input logic [31:0] expected_imme);
        if (tb_rs1_data === expected_rs1 && tb_rs2_data === expected_rs2 && tb_imme_value === expected_imme) begin
            $display("PASS: RS1 Data=%h, RS2 Data=%h, Immediate Value=%h", tb_rs1_data, tb_rs2_data, tb_imme_value);
        end else begin
            $display("FAILED: Expected RS1 Data=%h, Got=%h, Expected RS2 Data=%h, Got=%h, Expected Immediate Value=%h, Got=%h", 
                      expected_rs1, tb_rs1_data, expected_rs2, tb_rs2_data, expected_imme, tb_imme_value);
        end
    endtask

endmodule
