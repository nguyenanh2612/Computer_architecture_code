`timescale 1ps/1ps
module tb;
/***************************************** Decler I/O ***************************************/
    // Clock and reset  
    logic tb_clk, tb_rst; 
    // Output 
    logic [1:0] tb_fw_a, tb_fw_b;
    logic [31:0] tb_pc_debug;
    logic [31:0] tb_alu_d;  
    logic [31:0] tb_wb_data;  
/***************************************** Instante the module ***************************************/
    pipeline uut(
      // Clock and reset
      .i_clk           (tb_clk), 
      .i_rst           (tb_rst), 
      // Output
      .o_fw_a          (tb_fw_a),
      .o_fw_b          (tb_fw_b),
      .o_pc_debug      (tb_pc_debug),
      .o_alu_d         (tb_alu_d),  
      .o_wb_data       (tb_wb_data)
    );
/***************************************** Generate clock + test case ***************************************/
    // Generate clock
    initial begin
      tb_clk = 1'b0; 
      forever #5 tb_clk = ~tb_clk; 
    end

    // Test case
    initial begin
        tb_rst = 1'b1; 
        #40 
        tb_rst = 1'b0; 
        
        // Add some delay to observe the changes in pc_debug and wb_data
        #100;
    end

    always @(posedge tb_clk) begin
        if (tb_pc_debug >= 32'd16) begin
            check_results(tb_pc_debug, tb_wb_data); 
        end
    end

    task check_results(input logic [31:0] tb_pc_debug, input logic [31:0] tb_wb_data);
        case (tb_pc_debug)
        32'd16: begin
            if (tb_wb_data == 32'h00000023) begin
                $display("1.ADDI...................PASSED");
            end else begin
                $display("1.ADDI...................FAILED");
            end
        end 
        32'd20: begin
            if (tb_wb_data == 32'h00000023) begin
                $display("2.ADD....................PASSED");
            end else begin
                $display("2.ADD....................FAILED");
            end
        end 
        32'd24: begin
            if (tb_wb_data == 32'd0) begin
                $display("3.SUB....................PASSED");
            end else begin
                $display("3.SUB....................FAILED");
            end
        end 
        32'd28: begin
            if (tb_wb_data == 32'd0) begin
                $display("4.SLL....................PASSED");
            end else begin
                $display("4.SLL....................FAILED");
            end
        end 
        32'd32: begin
            if (tb_wb_data == 32'd1) begin
                $display("5.SLT....................PASSED");
            end else begin
                $display("5.SLT....................FAILED");
            end
        end 
        32'd36: begin
            if (tb_wb_data == 32'd1) begin
                $display("6.SLTU...................PASSED");
            end else begin
                $display("6.SLTU...................FAILED");
            end
        end 
        32'd40: begin
            if (tb_wb_data == 32'd0) begin
                $display("7.XOR....................PASSED");
            end else begin
                $display("7.XOR....................FAILED");
            end
        end 
        32'd44: begin
            if (tb_wb_data == 32'd0) begin
                $display("8.SRL....................PASSED");
            end else begin
                $display("8.SRL....................FAILED");
            end
        end 
        32'd48: begin
            if (tb_wb_data == 32'd0) begin
                $display("9.SRA....................PASSED");
            end else begin
                $display("9.SRA....................FAILED");
            end
        end 
        32'd52: begin
            if (tb_wb_data == 32'd0) begin
                $display("10.OR.....................PASSED");
            end else begin
                $display("10.OR.....................FAILED");
            end
        end 
        32'd56: begin
            if (tb_wb_data == 32'd0) begin
                $display("11.AND....................PASSED");
            end else begin
                $display("11.AND....................FAILED");
            end
        end 
        32'd60: begin
            if (tb_wb_data == 32'd1) begin
                $display("12.ADDI...................PASSED");
            end else begin
                $display("12.ADDI...................FAILED");
            end
        end 
        32'd64: begin
            if (tb_wb_data == 32'd2) begin
                $display("13.SLLI...................PASSED");
            end else begin
                $display("13.SLLI...................FAILED");
            end
        end 
        32'd68: begin
            if (tb_wb_data == 32'd1) begin
                $display("14.SLTI...................PASSED");
            end else begin
                $display("14.SLTI...................FAILED");
            end
        end 
        32'd72: begin
            if (tb_wb_data == 32'd1) begin
                $display("15.SLTIU..................PASSED");
            end else begin
                $display("15.SLTIU..................FAILED");
            end
        end 
        32'd76: begin
            if (tb_wb_data == 32'd0) begin
                $display("16.XORI...................PASSED");
            end else begin
                $display("16.XORI...................FAILED");
            end
        end 
        32'd80: begin
            if (tb_wb_data == 32'd0) begin
                $display("17.SRLI...................PASSED");
            end else begin
                $display("17.SRLI...................FAILED");
            end
        end 
        32'd84: begin
            if (tb_wb_data == 32'd0) begin
                $display("18.SRAI...................PASSED");
            end else begin
                $display("18.SRAI...................FAILED");
            end
        end 
        32'd88: begin
            if (tb_wb_data == 32'd1) begin
                $display("19.ORI....................PASSED");
            end else begin
                $display("19.ORI....................FAILED");
            end
        end 
        32'd92: begin
            if (tb_wb_data == 32'd1) begin
                $display("20.ANDI...................PASSED");
            end else begin
                $display("20.ANDI...................FAILED");
            end
        end 
        32'd96: begin
            if (tb_wb_data == 32'h00023000) begin
                $display("21.LUI...................PASSED");
            end else begin
                $display("21.LUI...................FAILED");
            end
        end
        32'd100: begin
            if (tb_wb_data == 32'h00023058) begin
                $display("22.AUIPC...................PASSED");
            end else begin
                $display("22.AUIPC...................FAILED");
            end
        end
        32'd116: begin
            if (tb_wb_data == 32'h00023058) begin
                $display("23.SW + LW...................PASSED");
            end else begin
                $display("23.SW + LW...................FAILED");
            end
        end
        32'd120: begin
            if (tb_wb_data == 32'h00000058) begin
                $display("24.LB...................PASSED");
            end else begin
                $display("24.LB...................FAILED");
            end
        end
        32'd124: begin
            if (tb_wb_data == 32'h00003058) begin
                $display("25.LH...................PASSED");
            end else begin
                $display("25.LH...................FAILED");
            end
        end
        32'd128: begin
            if (tb_wb_data == 32'h00000058) begin
                $display("26.LBU...................PASSED");
            end else begin
                $display("26.LBU...................FAILED");
            end
        end
        32'd132: begin
            if (tb_wb_data == 32'h00003058) begin
                $display("27.LHU...................PASSED");
            end else begin
                $display("27.LHU...................FAILED");
            end
        end
        default: begin
            // Do nothing for other values
        end
        endcase
    endtask 
endmodule
