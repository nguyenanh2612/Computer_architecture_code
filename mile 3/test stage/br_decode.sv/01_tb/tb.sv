`timescale 1ps/1ps
module tb;
/******************************************** I/O signals *********************************************/
    // Input
    logic [31:0] tb_rs1_data;
    logic [31:0] tb_rs2_data;
    logic [2:0] tb_br_type;
    logic tb_br_uns;
    // Output
    logic tb_pc_sel;

/******************************************** Instantiate module *********************************************/
    // Instantiate the brc module
    brc uut (
        .i_rs1_data(tb_rs1_data),
        .i_rs2_data(tb_rs2_data),
        .i_br_type(tb_br_type),
        .i_br_uns(tb_br_uns),
        .o_pc_sel(tb_pc_sel)
    );

/******************************************** Test cases *********************************************/
    // Test cases
    initial begin 
        // Test 1: BEQ - Equal
        tb_rs1_data = 32'd10;
        tb_rs2_data = 32'd10;
        tb_br_type = 3'd0;
        tb_br_uns = 1'b0;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BEQ: PASSED");
        else
            $display("Test BEQ: FAILED");

        // Test 2: BNE - Not Equal
        tb_rs1_data = 32'd10;
        tb_rs2_data = 32'd20;
        tb_br_type = 3'd1;
        tb_br_uns = 1'b0;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BNE PASSED");
        else
            $display("Test BNE FAILED");

        // Test 3: BLT - Less Than
        tb_rs1_data = 32'd10;
        tb_rs2_data = 32'd20;
        tb_br_type = 3'd2;
        tb_br_uns = 1'b0;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BLT PASSED");
        else
            $display("Test BLT FAILED");

        // Test 4: BGE - Greater Than or Equal
        tb_rs1_data = 32'd20;
        tb_rs2_data = 32'd10;
        tb_br_type = 3'd3;
        tb_br_uns = 1'b0;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BGE PASSED");
        else
            $display("Test BGE FAILED");

        // Test 5: BLTU - Less Than Unsigned
        tb_rs1_data = 32'd10;
        tb_rs2_data = 32'd20;
        tb_br_type = 3'd4;
        tb_br_uns = 1'b1;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BLTU PASSED");
        else
            $display("Test BLTU FAILED");

        // Test 6: BGEU - Greater Than or Equal Unsigned
        tb_rs1_data = 32'd20;
        tb_rs2_data = 32'd10;
        tb_br_type = 3'd5;
        tb_br_uns = 1'b1;
        #10;
        if (tb_pc_sel == 1'b1)
            $display("Test BGEU PASSED");
        else
            $display("Test BGEU FAILED");

        // End the test
        $finish;
    end

endmodule
