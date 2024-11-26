module execute_stage (
    // Input 
    input logic [31:0] i_pc_cur, 
    input logic [31:0] i_rs1_data, i_rs2_data, 
    input logic [31:0] i_imme_value, 
    input logic [31:0] i_wb_forwarding, i_mem_forwarding, 

    input logic [3:0] i_alu_op, 
    input logic [1:0] i_forward_A, i_forward_B, 
    input logic i_imme_sel, 

    // Output
    output logic [31:0] o_alu_data, o_operand_b,
    output logic [31:0] o_pc_br
);
/******************************************* Immediate signals *******************************************/
    logic [31:0] temp_rs2_d; 
    logic [31:0] operand_a_d, operand_b_d; 
/******************************************* Mux forwarding selection *******************************************/
    // Rs2 or immediate value
    assign temp_rs2_d = (i_imme_sel) ? i_imme_value : i_rs2_data; 

    // Operand A forwarding 
    always_comb begin
        case (i_forward_A)
        // No forward
        2'd0: begin
            operand_a_d = i_rs1_data; 
        end
        // Forward from WB
        2'd1: begin
            operand_a_d = i_wb_forwarding;
        end
        // Forward from MEM
        2'd2: begin
            operand_a_d = i_mem_forwarding; 
        end
        // Reserved value
        2'd3: begin
            operand_a_d = 32'd0; 
        end
        endcase
    end

    // Operand B forwarding
    always_comb begin
        case (i_forward_B)
        // No forward
        2'd0: begin
            operand_b_d = temp_rs2_d; 
        end
        // Forward from WB
        2'd1: begin
            operand_b_d = i_wb_forwarding;
        end
        // Forward from MEM
        2'd2: begin
            operand_b_d = i_mem_forwarding; 
        end
        // Reserved value
        2'd3: begin
            operand_b_d = 32'd0; 
        end
        endcase
    end
/******************************************* ALU execution *******************************************/
    // ALU 
    alu ALU(
        // Input 
        .i_operand_a   (operand_a_d), 
        .i_operand_b   (operand_b_d), 
        .i_alu_op      (i_alu_op), 
        // Output 
        .o_alu_data
    ); 

    // PC branch
    assign o_pc_br = i_pc_cur + {i_imme_value[29:0],2'b00}; 
    // ST data
    assign o_operand_b = operand_b_d; 
endmodule