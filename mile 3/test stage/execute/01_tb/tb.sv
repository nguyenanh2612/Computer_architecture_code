`timescale 1ns / 1ps

module tb;
/******************************************* Declare signals *******************************************/
	// Input 
    logic [31:0] tb_pc_cur, tb_rs1_data, tb_rs2_data, tb_imme_value;
    logic [31:0] tb_wb_forwarding, tb_mem_forwarding;
    logic [3:0] tb_alu_op;
    logic [1:0] tb_forward_A, tb_forward_B;
    logic tb_imme_sel;
    // Output 
    logic [31:0] tb_alu_data, tb_pc_br;
    // Test case variables
    logic [31:0] expected_alu_data, expected_pc_br;
    int errors = 0;
/******************************************* Instance the module *******************************************/
    // Instantiate the UUT
    execute_stage uut (
        .i_pc_cur          (tb_pc_cur),
        .i_rs1_data        (tb_rs1_data),
        .i_rs2_data        (tb_rs2_data),
        .i_imme_value      (tb_imme_value),
        .i_wb_forwarding   (tb_wb_forwarding),
        .i_mem_forwarding  (tb_mem_forwarding),
        .i_alu_op          (tb_alu_op),
        .i_forward_A       (tb_forward_A),
        .i_forward_B       (tb_forward_B),
        .i_imme_sel        (tb_imme_sel),
        .o_alu_data        (tb_alu_data),
        .o_pc_br           (tb_pc_br)
    );
/******************************************* Test case *******************************************/
    // Testbench logic
    initial begin
        $display("Starting execute_stage testbench...");
/******************************************* ADD *******************************************/
        // Test case 1: Simple ADD operation
        tb_pc_cur = 32'h00000004;
        tb_rs1_data = 32'h00000010;
        tb_rs2_data = 32'h00000020;
        tb_imme_value = 32'h00000008;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd0;  // ADD
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10; // Wait for the outputs to stabilize
        expected_alu_data = 32'h00000030; // 0x10 + 0x20
        expected_pc_br = 32'h0000024;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 1 (ADD)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 1 (ADD)");
        end
/******************************************* SUB  *******************************************/
        // Test case 2: Simple SUB operation
        tb_pc_cur = 32'h00000010;
        tb_rs1_data = 32'h00000020;
        tb_rs2_data = 32'h00000010;
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd1;  // SUB
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000010; // 0x20 - 0x10
        expected_pc_br = 32'h00000010;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 2 (SUB)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 2 (SUB)");
        end
/******************************************* SLT *******************************************/
        // Test case 3: Simple SLT operation (Set Less Than)
        tb_pc_cur = 32'h00000008;
        tb_rs1_data = 32'h00000005;
        tb_rs2_data = 32'h00000010;
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd2;  // SLT
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000001; // 0x05 < 0x10 -> set to 1
        expected_pc_br = 32'h00000008;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 3 (SLT)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 3 (SLT)");
        end
/******************************************* XOR *******************************************/
        // Test case 4: Simple XOR operation
        tb_pc_cur = 32'h00000020;
        tb_rs1_data = 32'hF0F0F0F0;
        tb_rs2_data = 32'h0F0F0F0F;
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd4;  // XOR
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'hFFFFFFFF; // XOR: F0F0F0F0 ^ 0F0F0F0F
        expected_pc_br = 32'h00000020;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 4 (XOR)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 4 (XOR)");
        end
/******************************************* SLTU *******************************************/
        // Test case 5: Simple SLTU operation (Set Less Than Unsigned)
        tb_pc_cur = 32'h00000010;
        tb_rs1_data = 32'h00000005;  // rs1 = 5 (unsigned)
        tb_rs2_data = 32'h00000010;  // rs2 = 16 (unsigned)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd3;  // SLTU
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000001; // 5 < 16 (unsigned), so result is 1
        expected_pc_br = 32'h00000010;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 5 (SLTU)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 5 (SLTU - rs1 < rs2)");
        end

        // Test case 6: SLTU operation with rs1 > rs2 (unsigned)
        tb_pc_cur = 32'h00000020;
        tb_rs1_data = 32'hFFFFFFF0;  // rs1 = 4294967280 (unsigned)
        tb_rs2_data = 32'h00000010;  // rs2 = 16 (unsigned)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd3;  // SLTU
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000000; // 4294967280 > 16 (unsigned), so result is 0
        expected_pc_br = 32'h00000020;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 6 (SLTU)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 6 (SLTU - rs1 > rs2)");
        end
/******************************************* OR *******************************************/
        // Test case 7: Simple OR operation
        tb_pc_cur = 32'h00000030;
        tb_rs1_data = 32'hF0F0F0F0;  // rs1 = 0xF0F0F0F0
        tb_rs2_data = 32'h0F0F0F0F;  // rs2 = 0x0F0F0F0F
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd5;  // OR
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'hFFFFFFFF; // OR: 0xF0F0F0F0 | 0x0F0F0F0F
        expected_pc_br = 32'h00000030;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 7 (OR)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 7 (OR)");
        end
/******************************************* AND *******************************************/
        // Test case 8: Simple AND operation
        tb_pc_cur = 32'h00000040;
        tb_rs1_data = 32'hF0F0F0F0;  // rs1 = 0xF0F0F0F0
        tb_rs2_data = 32'h0F0F0F0F;  // rs2 = 0x0F0F0F0F
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd6;  // AND
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000000; // AND: 0xF0F0F0F0 & 0x0F0F0F0F
        expected_pc_br = 32'h00000040;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 8 (AND)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 8 (AND)");
        end

/******************************************* SLL *******************************************/
        // Test case 9: Simple SLL operation
        tb_pc_cur = 32'h00000050;
        tb_rs1_data = 32'h00000003;  // rs1 = 3 (binary: 000...0011)
        tb_rs2_data = 32'h00000002;  // rs2 = 2 (shift amount)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd7;  // SLL
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h0000000C; // SLL: 3 << 2 = 12 (binary: 000...1100)
        expected_pc_br = 32'h00000050;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 9 (SLL)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 9 (SLL)");
        end
/******************************************* SRL *******************************************/
        // Test case 10: Simple SRL operation
        tb_pc_cur = 32'h00000060;
        tb_rs1_data = 32'h0000000C;  // rs1 = 12 (binary: 000...1100)
        tb_rs2_data = 32'h00000002;  // rs2 = 2 (shift amount)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd8;  // SRL
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000003; // SRL: 12 >> 2 = 3 (binary: 000...0011)
        expected_pc_br = 32'h00000060;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 10 (SRL)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 10 (SRL)");
        end

/******************************************* SRA *******************************************/
        // Test case 11: Simple SRA operation with a positive number
        tb_pc_cur = 32'h00000070;
        tb_rs1_data = 32'h0000000C;  // rs1 = 12 (binary: 000...1100)
        tb_rs2_data = 32'h00000002;  // rs2 = 2 (shift amount)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd9;  // SRA
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000003; // SRA: 12 >> 2 = 3 (binary: 000...0011), same as SRL for positive values
        expected_pc_br = 32'h00000070;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 11 (SRA - Positive Number)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 11 (SRA - Positive Number)");
        end

        // Test case 12: SRA operation with a negative number
        tb_pc_cur = 32'h00000080;
        tb_rs1_data = 32'hFFFFFFF4;  // rs1 = -12 (binary: 111...110100)
        tb_rs2_data = 32'h00000002;  // rs2 = 2 (shift amount)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000;
        tb_mem_forwarding = 32'h00000000;
        tb_alu_op = 4'd9;  // SRA
        tb_forward_A = 2'd0;
        tb_forward_B = 2'd0;
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'hFFFFFFFD; // SRA: -12 >> 2 = -3 (arithmetic shift preserves sign bits)
        expected_pc_br = 32'h00000080;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 12 (SRA - Negative Number)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 12 (SRA - Negative Number)");
        end
/******************************************* AND *******************************************/
        // Test case 13: Forwarding from WB stage
        tb_pc_cur = 32'h00000090;
        tb_rs1_data = 32'h00000000;  // Default value (not used in forwarding)
        tb_rs2_data = 32'h00000000;  // Default value (not used in forwarding)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h12345678; // Forwarding value from WB stage
        tb_mem_forwarding = 32'h00000000; // No forwarding from MEM stage
        tb_alu_op = 4'd0;  // ADD operation
        tb_forward_A = 2'd1; // Select WB forwarding for A
        tb_forward_B = 2'd1; // Select WB forwarding for B
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h2468ACF0; // ADD: 0x12345678 + 0x12345678
        expected_pc_br = 32'h00000090;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 13 (Forwarding from WB)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 13 (Forwarding from WB)");
        end

        // Test case 14: Forwarding from MEM stage
        tb_pc_cur = 32'h000000A0;
        tb_rs1_data = 32'h00000000;  // Default value (not used in forwarding)
        tb_rs2_data = 32'h00000000;  // Default value (not used in forwarding)
        tb_imme_value = 32'h00000000;
        tb_wb_forwarding = 32'h00000000; // No forwarding from WB stage
        tb_mem_forwarding = 32'h87654321; // Forwarding value from MEM stage
        tb_alu_op = 4'd1;  // SUB operation
        tb_forward_A = 2'd2; // Select MEM forwarding for A
        tb_forward_B = 2'd2; // Select MEM forwarding for B
        tb_imme_sel = 1'b0;

        #10;
        expected_alu_data = 32'h00000000; // SUB: 0x87654321 - 0x87654321 = 0
        expected_pc_br = 32'h000000A0;   // PC increment example

        if (tb_alu_data !== expected_alu_data || tb_pc_br !== expected_pc_br) begin
            $display("FAILED: Test case 14 (Forwarding from MEM)");
            $display("  Expected tb_alu_data: %h, Got: %h", expected_alu_data, tb_alu_data);
            $display("  Expected tb_pc_br: %h, Got: %h", expected_pc_br, tb_pc_br);
            errors += 1;
        end else begin
            $display("PASS: Test case 14 (Forwarding from MEM)");
        end

/******************************************* SUMMARY *******************************************/
        // Summary
        if (errors == 0) begin
            $display("All test cases passed!");
        end else begin
            $display("%0d test cases failed.", errors);
        end

        $stop; // End simulation
    end
endmodule
