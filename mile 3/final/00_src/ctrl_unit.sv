module ctrl_unit (
    // Input 
    input logic [31:0] i_instruct,
    // Output 
    output logic o_pc_sel, o_rd_wren, o_mem_rden, o_mem_wren, o_br_unsigned, o_insn_vld, o_imme_sel, 
    output logic [3:0] o_alu_op, 
    output logic [2:0] o_ld_rewrite, 
    output logic [1:0] o_st_rewrite, o_wb_sel
);
/**************************************** Immediate signals *******************************************************/

/**************************************** Control unit's output signals *******************************************/
    always_comb begin
        case (i_instruct[6:0])
        // R-type
        7'b0110011: begin
            // PC selection
            o_pc_sel = 1'b0;
            // Register file write enable 
            o_rd_wren = 1'b1; 
            // Immediate value selection 
            o_imme_sel = 1'b0; 
            // Signed enable branch calculation 
            o_br_unsigned = 1'b0; 
            // Mem read enable
            o_mem_rden = 1'b0; 
            // Mem write enable 
            o_mem_wren = 1'b0; 
            // Load rewrite
            o_ld_rewrite = 3'd5; 
            // Store rewrite
            o_st_rewrite = 2'd3; 
            // Write back satge's data
            o_wb_sel = 2'd1;
            case (i_instruct[14:12])
            // ADD + SUB
            3'd0: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd0; 
                    o_insn_vld = 1'b1; 
                end else if (i_instruct[31:25] == 7'b0100000) begin
                    o_alu_op = 4'd1;
                    o_insn_vld = 1'b1;  
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;  
                end
            end
            // SLL: 
            3'd1: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd7;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // SLT
            3'd2: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd2;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // SLTU 
            3'd3: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd3;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // XOR
            3'd4: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd4;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // SRL + SRA
            3'd5: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd8;
                    o_insn_vld = 1'b1; 
                end else if (i_instruct[31:25] == 7'b0100000) begin
                    o_alu_op = 4'd9;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // OR
            3'd6: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd5;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // AND 
            3'd7: begin
                if (i_instruct[31:25] == 7'd0) begin
                    o_alu_op = 4'd6;
                    o_insn_vld = 1'b1; 
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            endcase
        end
        // I-type 
        7'b0010011: begin
            // PC selection
            o_pc_sel = 1'b0;
            // Register file write enable 
            o_rd_wren = 1'b1; 
            // Immediate value selection 
            o_imme_sel = 1'b1; 
            // Signed enable branch calculation 
            o_br_unsigned = 1'b0; 
            // Mem read enable
            o_mem_rden = 1'b0; 
            // Mem write enable 
            o_mem_wren = 1'b0; 
            // Load rewrite
            o_ld_rewrite = 3'd5; 
            // Store rewrite
            o_st_rewrite = 2'd3; 
            // Write back satge's data
            o_wb_sel = 2'd1;
            case (i_instruct[14:12])
            // ADD
            3'd0: begin
                o_alu_op = 4'd0; 
                o_insn_vld = 1'b1;
            end
            // SLLI
            3'd1: begin
                o_alu_op = 4'd7;
                o_insn_vld = (i_instruct[31:26] == 6'd0) ? 1'b1 : 1'b0;
            end
            // SLTI
            3'd2: begin
                o_alu_op = 4'd2;
                o_insn_vld = 1'b1;
            end
            // SLTIU 
            3'd3: begin
                o_alu_op = 4'd3;
                o_insn_vld = 1'b1;
            end
            // XORI 
            3'd4: begin
                o_alu_op = 4'd4; 
                o_insn_vld = 1'b1;
            end
            // SRLI + SRAI
            3'd5: begin
                if (i_instruct[31:26] == 6'd0) begin
                    o_alu_op = 4'd8;
                    o_insn_vld = 1'b1;
                end else if (i_instruct[31:26] == 6'b010000) begin
                    o_alu_op = 4'd9;
                    o_insn_vld = 1'b1;
                end else begin
                    o_alu_op = 4'd11; 
                    o_insn_vld = 1'b0;
                end
            end
            // ORI
            3'd6: begin
                o_alu_op = 4'd5; 
                o_insn_vld = 1'b1;
            end
            // ANDI
            3'd7: begin
                o_alu_op = 4'd6; 
                o_insn_vld = 1'b1;
            end 
            endcase
        end 
            default: begin
                // PC selection
                o_pc_sel = 1'b0;
                // Register file write enable 
                o_rd_wren = 1'b0; 
                // Immediate value selection 
                o_imme_sel = 1'b0; 
                // Signed enable branch calculation 
                o_br_unsigned = 1'b0; 
                // ALU operation selection 
                o_alu_op = 4'd11; 
                // Instruction valid 
                o_insn_vld = 1'b0; 
                // Mem read enable
                o_mem_rden = 1'b0; 
                // Mem write enable 
                o_mem_wren = 1'b0; 
                // Load rewrite
                o_ld_rewrite = 3'd5; 
                // Store rewrite
                o_st_rewrite = 2'd3; 
                // Write back satge's data
                o_wb_sel = 2'd3;
            end
        endcase
    end
endmodule