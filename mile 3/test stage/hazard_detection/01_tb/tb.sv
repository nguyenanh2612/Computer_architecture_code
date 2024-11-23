`timescale 1ns/1ps
module tb;

    // Inputs
    logic [4:0] tb_id_rs1, tb_id_rs2, tb_id_rd, tb_ex_rd;
    logic tb_ex_read;

    // Outputs
    logic tb_pc_enable, tb_IF_ID_register_enable, tb_pipeline_stall;

    // Instantiate the DUT (Device Under Test)
    harzard_dection uut (
        // Input 
        .i_id_rs1                     (tb_id_rs1),
        .i_id_rs2                     (tb_id_rs2),
        .i_id_rd                      (tb_id_rd),
        .i_ex_rd                      (tb_ex_rd),
        .i_ex_read                    (tb_ex_read),
        // Output 
        .o_pc_enable                  (tb_pc_enable),
        .o_if_id_register_enable      (tb_IF_ID_register_enable),
        .o_pipeline_stall             (tb_pipeline_stall)
    );

    // Testbench logic
    initial begin
        // Test Case 1: No hazard (Different register addresses)
        tb_id_rs1 = 5'd1;
        tb_id_rs2 = 5'd2; 
        tb_ex_rd = 5'd3; 
        tb_ex_read = 1;
        #10;
        if (tb_pc_enable && tb_IF_ID_register_enable && tb_pipeline_stall)
            $display("Test Case 1 PASS");
        else
            $display("Test Case 1 FAILED");

        // Test Case 2: RAW Hazard with rs1 (ex_rd matches id_rs1)
        tb_id_rs1 = 5'd3; tb_id_rs2 = 5'd2; tb_ex_rd = 5'd3; tb_ex_read = 1;
        #10;
        if (!tb_pc_enable && !tb_IF_ID_register_enable && !tb_pipeline_stall)
            $display("Test Case 2 PASS");
        else
            $display("Test Case 2 FAILED");

        // Test Case 3: RAW Hazard with rs2 (ex_rd matches id_rs2)
        tb_id_rs1 = 5'd1; tb_id_rs2 = 5'd3; tb_ex_rd = 5'd3; tb_ex_read = 1;
        #10;
        if (!tb_pc_enable && !tb_IF_ID_register_enable && !tb_pipeline_stall)
            $display("Test Case 3 PASS");
        else
            $display("Test Case 3 FAILED");

        // Test Case 4: No hazard (ex_read = 0)
        tb_id_rs1 = 5'd3; tb_id_rs2 = 5'd3; tb_ex_rd = 5'd3; tb_ex_read = 0;
        #10;
        if (tb_pc_enable && tb_IF_ID_register_enable && tb_pipeline_stall)
            $display("Test Case 4 PASS");
        else
            $display("Test Case 4 FAILED");

        // Test Case 5: RAW Hazard with both rs1 and rs2 (ex_rd matches both id_rs1 and id_rs2)
        tb_id_rs1 = 5'd3; tb_id_rs2 = 5'd3; tb_ex_rd = 5'd3; tb_ex_read = 1;
        #10;
        if (!tb_pc_enable && !tb_IF_ID_register_enable && !tb_pipeline_stall)
            $display("Test Case 5 PASS");
        else
            $display("Test Case 5 FAILED");

        $stop;
    end

endmodule
