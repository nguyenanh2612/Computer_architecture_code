`timescale 1ns / 1ps
module tb;
/***************************************** Declare signals ***************************************/
    // Input 
    logic [1:0] tb_wb_sel;
    logic [2:0] tb_ld_rewrite;
    logic [31:0] tb_pc_four, tb_alu_data, tb_ld_data;
    // Output
    logic [31:0] tb_wb_data;
/***************************************** Instantate the module ***************************************/
    wb_stage uut (
        // Input 
        .i_wb_sel       (tb_wb_sel),
        .i_ld_rewrite   (tb_ld_rewrite),
        .i_pc_four      (tb_pc_four),
        .i_alu_data     (tb_alu_data),
        .i_ld_data      (tb_ld_data),
        // Output 
        .o_wb_data      (tb_wb_data)
    );
/***************************************** Test case ***************************************/
    // Task to check output and print result
    task check_output(input [31:0] expected, input [31:0] actual);
        if (actual === expected) begin
            $display("PASS: Output matched. Expected: %h, Got: %h", expected, actual);
        end else begin
            $display("FAILED: Output mismatched. Expected: %h, Got: %h", expected, actual);
        end
    endtask

    // Stimulus and verification
    initial begin
        // Test case 1: tb_wb_sel = 0 (output = i_pc_four)
        tb_pc_four = 32'h12345678;
        tb_wb_sel = 2'd0;
        #1 check_output(tb_pc_four, tb_wb_data);

        // Test case 2: i_wb_sel = 1 (output = i_alu_data)
        tb_alu_data = 32'h87654321;
        tb_wb_sel = 2'd1;
        #1 check_output(tb_alu_data, tb_wb_data);

        // Test case 3: i_wb_sel = 2 (output = new_ld_data via ld_data_rewrite)
        tb_alu_data = 32'h87654320;
        tb_ld_data = 32'hAABBCCDD;
        tb_ld_rewrite = 3'd0; // Select LB operation
        tb_wb_sel = 2'd2;
        #1 check_output({24'hFFFFFF, tb_ld_data[7:0]}, tb_wb_data);

        tb_alu_data = 32'h87654321;
        tb_ld_rewrite = 3'd0; // Select LB operation
        tb_wb_sel = 2'd2;
        #1 check_output({24'hFFFFFF, tb_ld_data[15:8]}, tb_wb_data);

        tb_alu_data = 32'h87654322;
        tb_ld_rewrite = 3'd0; // Select LB operation
        tb_wb_sel = 2'd2;
        #1 check_output({24'hFFFFFF, tb_ld_data[23:16]}, tb_wb_data);

        tb_alu_data = 32'h87654323;
        tb_ld_rewrite = 3'd0; // Select LB operation
        tb_wb_sel = 2'd2;
        #1 check_output({24'hFFFFFF, tb_ld_data[31:24]}, tb_wb_data);

        // tb_i_ld_rewrite = 1 (LH operation)
        tb_ld_rewrite = 3'd1;
        #1 check_output({16'hFFFF, tb_ld_data[31:16]}, tb_wb_data);

        // tb_i_ld_rewrite = 3 (LBU operation)
        tb_ld_rewrite = 3'd3;
        #1 check_output({24'd0, tb_ld_data[31:24]}, tb_wb_data);

        // tb_i_ld_rewrite = 4 (LHU operation)
        tb_ld_rewrite = 3'd4;
        #1 check_output({16'd0, tb_ld_data[31:16]}, tb_wb_data);

        // Test case 4: tb_i_wb_sel = 3 (output = 0)
        tb_wb_sel = 2'd3;
        #1 check_output(32'd0, tb_wb_data);
    end 
endmodule