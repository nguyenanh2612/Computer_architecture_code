module execute_stage (
    // Input 
    input logic [31:0] i_pc_cur, 
    input logic [31:0] i_rs1_data, i_rs2_data, 
    input logic [31:0] i_imme_value, 
    input logic [31:0] i_wb_forwarding, i_mem_forwarding, 

    input logic [3:0] i_alu_op, 
    input logic [1:0] i_forward_A, i_forward_B, 
    input logic i_imme_sel, i_rs1_sel, 

    input logic i_jalr_iden, 
    input logic i_br_unsigned, 
    input logic [2:0] i_br_type, 

    // Output
    output logic o_brc_pc_sel, 
    output logic [31:0] o_pc_br ,o_alu_data, o_operand_b
);
/******************************************* Immediate signals *******************************************/
    logic [31:0] temp_rs2_d, temp_rs1_d; 
    logic [31:0] operand_a_d, operand_b_d; 
/******************************************* Mux forwarding selection *******************************************/
    // Rs1 or PC 
    assign temp_rs1_d = (i_rs1_sel) ? i_pc_cur : i_rs1_data; 

    // Operand A forwarding 
    always_comb begin
        case (i_forward_A)
        // No forward
        2'd0: begin
            operand_a_d = temp_rs1_d; 
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
            operand_b_d = i_rs2_data; 
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
        .i_operand_b   (temp_rs2_d), 
        .i_alu_op      (i_alu_op), 
        // Output 
        .o_alu_data
    ); 

    // fw_result or immediate value
    assign temp_rs2_d = (i_imme_sel) ? i_imme_value : operand_b_d; 
    
    brc BR_COMPARE(
       // Input
       .i_rs1_data            (operand_a_d),
       .i_rs2_data            (operand_b_d), 
       .i_br_type             (i_br_type), 
       .i_br_uns              (i_br_unsigned),  
       // Ouput
       .o_pc_sel              (o_brc_pc_sel)
    );

    // ST data
    assign o_operand_b =  operand_b_d; 
    assign o_pc_br     =  (i_jalr_iden) ? o_alu_data : i_pc_cur + i_imme_value; 
endmodule