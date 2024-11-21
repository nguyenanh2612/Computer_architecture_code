`timescale 1ps/1ps
module tb;
    // Clock and Reset
    logic tb_clk, tb_rst; 

    // Inputs
    logic tb_pc_sel, tb_pc_stall;
    logic [31:0] tb_pc_br; 

    // Outputs
    logic [31:0] tb_pc_cur, tb_instruct; 

    // Instantiate the Unit Under Test (UUT)
    fetch_stage uut(
        .i_clk (tb_clk),
        .i_rst (tb_rst),
        .i_pc_sel (tb_pc_sel), 
        .i_pc_stall (tb_pc_stall), 
        .i_pc_br (tb_pc_br),
        .o_pc_cur (tb_pc_cur), 
        .o_instruct (tb_instruct)
    ); 

    // Generate clock
    initial begin
        tb_clk = 0; 
        forever #5 tb_clk = ~tb_clk; 
    end

    // Test
    initial begin
        $display("Starting test...");

        // Reset
        tb_rst = 1;
        tb_pc_sel = 0;
        tb_pc_stall = 0;
        tb_pc_br = 0;
        #40;
        tb_rst = 0;

        // Initial state check
        #10;
        tb_pc_stall = 1;

        // Check for PC and instruction values
        #10;
        check_pc_instruction(32'd4, 32'd1);
        #10;
        check_pc_instruction(32'd8, 32'd2);
        #10;
        check_pc_instruction(32'd12, 32'd4);
        #10;
        check_pc_instruction(32'd16, 32'd5);
        #10;
        check_pc_instruction(32'd20, 32'd6);
        #10;
        check_pc_instruction(32'd24, 32'd7);
        #10;
        check_pc_instruction(32'd28, 32'd8);

        #1000;
        $display("Double check:");

        // Branch test
        tb_pc_sel = 1'b1; 
        tb_pc_br = 32'd4; 
        #10;
        tb_pc_sel = 1'b0;
        check_pc_instruction(32'd4, 32'd1);
        #10;
        check_pc_instruction(32'd8, 32'd2);
        #10;
        check_pc_instruction(32'd12, 32'd4);
        #10;
        check_pc_instruction(32'd16, 32'd5);
        #10;
        check_pc_instruction(32'd20, 32'd6);
        #10;
        check_pc_instruction(32'd24, 32'd7);
        #10;
        check_pc_instruction(32'd28, 32'd8);
    end

    // Task to check PC and instruction values
    task check_pc_instruction(input logic [31:0] expected_pc, input logic [31:0] expected_instr);
        if (tb_pc_cur === expected_pc) begin
            if (tb_instruct === expected_instr) begin
                $display("PASS: PC=%h, Instruction=%h", tb_pc_cur, tb_instruct);
            end else begin
                $display("FAIL: PC=%h, Expected Instruction=%h, Got=%h", tb_pc_cur, expected_instr, tb_instruct);
            end
        end
    endtask
   
endmodule
