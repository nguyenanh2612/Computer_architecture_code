module ctrl_unit (
    input logic [31:0] i_instruction, 
    input logic i_br_less, i_br_equal,
    
    output logic o_opa_sel, o_opb_sel, o_pc_sel, 
    output logic [1:0] o_wb_sel, o_st_sel,
    output logic [2:0] o_ld_sel,  
    output logic [3:0] o_alu_op, 
    output logic o_mem_wren, o_rd_wren, 
    output logic o_br_uns,
    output logic o_insn_vld
); 
    always_comb begin
        o_opa_sel = 0; 
        o_opb_sel = 0; 
        o_mem_wren = 0; 
        o_wb_sel = 2'b01; 
        o_rd_wren = 0; 
        o_br_uns = 0; 
        o_pc_sel = 0; 
        o_insn_vld = 0;
        o_alu_op = 4'd11;
        o_ld_sel = 3'd5; 
        o_st_sel = 2'd3; 
        case (i_instruction[6:0])
        //R_type
        7'b0110011: begin
            o_opa_sel = 0; 
            o_opb_sel = 0; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b01; 
            o_rd_wren = 1; 
            o_br_uns = 0; 
            o_pc_sel = 0; 
            o_insn_vld = 1;
            o_ld_sel = 3'd5;
            case (i_instruction[14:12])
            // ADD + SUB
            3'd0: begin
                if (i_instruction[30]) begin
                    o_alu_op = 4'b0001; 
                end else begin
                    o_alu_op = 4'b0000;
                end
            end
            //SLL
            3'd1: begin
                o_alu_op = 4'b0111; 
            end
            //SLT 
            3'd2: begin
                o_alu_op = 4'b0010; 
            end
            //SLTU 
            3'd3: begin
                o_alu_op = 4'b0011; 
            end
            //XOR
            3'd4: begin
                o_alu_op = 4'b0100; 
            end
            //SRL + SRA
            3'd5: begin
                if (i_instruction[30]) begin
                    o_alu_op = 4'b1001; 
                end else begin
                    o_alu_op = 4'b1000; 
                end
            end
            //OR
            3'd6: begin
                o_alu_op = 4'b0101; 
            end
            //AND  
            3'd7: begin
                o_alu_op = 4'b0110; 
            end
            endcase
        end
        //I_type
        7'b0010011: begin
            o_opa_sel = 0; 
            o_opb_sel = 1; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b01; 
            o_rd_wren = 1; 
            o_br_uns = 0; 
            o_pc_sel = 0; 
            o_insn_vld = 1;
            o_ld_sel = 3'd5;
            case (i_instruction[14:12])
            // ADDI
            3'd0: begin
                o_alu_op = 4'b0000;
            end
            //SLLI
            3'd1: begin
                o_alu_op = 4'b0111; 
            end
            //SLTI
            3'd2: begin
                o_alu_op = 4'b0010; 
            end
            //SLTIU 
            3'd3: begin
                o_alu_op = 4'b0011; 
            end
            //XORI
            3'd4: begin
                o_alu_op = 4'b0100; 
            end
            //SRLI + SRAI
            3'd5: begin
                if (i_instruction[30]) begin
                    o_alu_op = 4'b1001; 
                end else begin
                    o_alu_op = 4'b1000; 
                end
            end
            //ORI
            3'd6: begin
                o_alu_op = 4'b0101; 
            end
            //ANDI
            3'd7: begin
                o_alu_op = 4'b0110; 
            end
            endcase
        end
        // BR_Type
        7'b1100011: begin 
            o_rd_wren = 0; 
            o_opa_sel = 1;
            o_opb_sel = 1; 
            o_alu_op = 4'b0000; 
            o_wb_sel = 2'd3; 
            o_mem_wren = 0; 
            o_insn_vld = 1; 
            o_ld_sel = 3'd5;
            case (i_instruction[14:12])
            // BEQ
            3'd0: begin
                o_br_uns = 0; 
                o_pc_sel = (i_br_equal) ? 1 : 0;
            end
            // BNE
            3'd1: begin
                o_br_uns = 0; 
                o_pc_sel = (i_br_equal) ? 0 : 1;
            end
            // BLT
            3'd4: begin
                o_br_uns = 0; 
                o_pc_sel = (i_br_less) ? 1 : 0;
            end
            // BGE
            3'd5: begin
                o_br_uns = 0; 
                o_pc_sel = (~i_br_less | i_br_equal) ? 1 : 0;
            end
            // BLTU
            3'd6: begin
                o_br_uns = 1; 
                o_pc_sel = (i_br_less) ? 1 : 0;
            end
            // BGEU
            3'd7: begin
                o_br_uns = 1; 
                o_pc_sel = (~i_br_less | i_br_equal) ? 1 : 0;
            end
                default: begin
                    o_br_uns = 0;
                    o_pc_sel = 0;
                end
            endcase
        end
        // LOAD_type
        7'b0000011: begin
            o_pc_sel = 0; 
            o_rd_wren = 1; 
            o_br_uns = 0; 
            o_opa_sel = 0; 
            o_opb_sel = 1; 
            o_alu_op = 4'b0000; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b10;
            o_insn_vld = 1;
            case (i_instruction[14:12])
            // LB
            3'd0: begin
                o_ld_sel = 3'd0; 
            end
            // LH
            3'd1: begin
                o_ld_sel = 3'd1; 
            end
            // LW 
            3'd2: begin
                o_ld_sel = 3'd2; 
            end
            // LBU 
            3'd4: begin
                o_ld_sel = 3'd3; 
            end
            // LHU
            3'd5: begin
                o_ld_sel = 3'd4; 
            end
            endcase
        end
        // STORE Type
        7'b0100011: begin
            o_pc_sel = 0; 
            o_rd_wren = 0; 
            o_insn_vld = 1; 
            o_opa_sel = 0; 
            o_opb_sel = 1; 
            o_alu_op = 4'd0; 
            o_br_uns = 0; 
            o_mem_wren = 1;
            o_wb_sel = 2'b11; 
            case (i_instruction[14:12])
            // SB
            3'd0: begin
                o_st_sel = 2'd0; 
            end
            // SH
            3'd1: begin
                o_st_sel = 2'd1; 
            end
            // SW 
            3'd2: begin
                o_st_sel = 2'd2; 
            end
            endcase
        end
        // LUI
        7'b0110111: begin
            o_pc_sel = 0; 
            o_rd_wren = 1; 
            o_opa_sel = 0; 
            o_opb_sel = 1; 
            o_alu_op = 4'd10; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b01; 
            o_insn_vld = 1; 
        end
        // AUIPC 
        7'b0010111: begin
            o_pc_sel = 0; 
            o_rd_wren = 1; 
            o_opa_sel = 1; 
            o_opb_sel = 1; 
            o_alu_op = 4'd0; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b01; 
            o_insn_vld = 1; 
        end
        // JAL
        7'b1101111: begin
            o_pc_sel = 1; 
            o_rd_wren = 1; 
            o_opa_sel = 1; 
            o_opb_sel = 1; 
            o_alu_op = 4'd0; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b00; 
            o_insn_vld = 1; 
        end
        // JALR
        7'b1100111: begin
            o_pc_sel = 1; 
            o_rd_wren = 1; 
            o_opa_sel = 0; 
            o_opb_sel = 1; 
            o_alu_op = 4'd0; 
            o_mem_wren = 0; 
            o_wb_sel = 2'b00; 
            o_insn_vld = 1; 
        end
        endcase 
    end
endmodule 