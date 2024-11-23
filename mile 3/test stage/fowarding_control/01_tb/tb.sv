`timescale 1ns/1ps

module tb;

    // Inputs
    logic tb_rd_wren_wb;
    logic tb_rd_wren_mem;
    logic [4:0] tb_rs1_addr, tb_rs2_addr, tb_mem_rd_addr, tb_wb_rd_addr;

    // Outputs
    logic [1:0] tb_forwarding_a, tb_forwarding_b;

    // Instantiate the UUT (Unit Under Test)
    forwarding_control uut (
        // Input 
        .i_rd_wren_wb           (tb_rd_wren_wb),
        .i_rd_wren_mem          (tb_rd_wren_mem),
        .i_rs1_addr             (tb_rs1_addr),
        .i_rs2_addr             (tb_rs2_addr),
        .i_mem_rd_addr          (tb_mem_rd_addr),
        .i_wb_rd_addr           (tb_wb_rd_addr),
        // Output
        .o_forwarding_a         (tb_forwarding_a),
        .o_forwarding_b         (tb_forwarding_b)
    );

    // Task for validation
    task validate;
        input [1:0] expected_a, expected_b;
        begin
            if (tb_forwarding_a === expected_a && tb_forwarding_b === expected_b) begin
                $display("PASS -> o_forwarding_a: %b, o_forwarding_b: %b", tb_forwarding_a, tb_forwarding_b);
            end else begin
                $display("FAILED -> Expected o_forwarding_a: %b, o_forwarding_b: %b; Got o_forwarding_a: %b, o_forwarding_b: %b",
                         expected_a, expected_b, tb_forwarding_a, tb_forwarding_b);
            end
        end
    endtask

    // Testbench logic
    initial begin
        // Test Case: No Forwarding
        tb_rd_wren_wb = 0; tb_rd_wren_mem = 0;
        tb_rs1_addr = 5'd1; tb_rs2_addr = 5'd2;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b00, 2'b00); // Expected: No forwarding

        // Test Case: Forwarding from MEM to RS1
        tb_rd_wren_wb = 0; tb_rd_wren_mem = 1;
        tb_rs1_addr = 5'd3; tb_rs2_addr = 5'd2;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b10, 2'b00); // Expected: Forwarding MEM->RS1

        // Test Case: Forwarding from MEM to RS2
        tb_rd_wren_wb = 0; tb_rd_wren_mem = 1;
        tb_rs1_addr = 5'd1; tb_rs2_addr = 5'd3;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b00, 2'b10); // Expected: Forwarding MEM->RS2

        // Test Case: Forwarding from WB to RS1
        tb_rd_wren_wb = 1; tb_rd_wren_mem = 0;
        tb_rs1_addr = 5'd4; tb_rs2_addr = 5'd2;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b01, 2'b00); // Expected: Forwarding WB->RS1

        // Test Case: Forwarding from WB to RS2
        tb_rd_wren_wb = 1; tb_rd_wren_mem = 0;
        tb_rs1_addr = 5'd1; tb_rs2_addr = 5'd4;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b00, 2'b01); // Expected: Forwarding WB->RS2

        // Test Case: Forwarding from MEM has higher priority than WB (RS1)
        tb_rd_wren_wb = 1; tb_rd_wren_mem = 1;
        tb_rs1_addr = 5'd3; tb_rs2_addr = 5'd4;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b10, 2'b01); // Expected: Priority MEM->RS1 over WB->RS1

        // Test Case: Forwarding from MEM has higher priority than WB (RS2)
        tb_rd_wren_wb = 1; tb_rd_wren_mem = 1;
        tb_rs1_addr = 5'd1; tb_rs2_addr = 5'd3;
        tb_mem_rd_addr = 5'd3; tb_wb_rd_addr = 5'd4;
        #10;
        validate(2'b00, 2'b10); // Expected: Priority MEM->RS2 over WB->RS2

        $stop;
    end

endmodule