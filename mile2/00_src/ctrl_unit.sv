module ctrl_unit (
    input logic [31:0] i_instruction, 
    input logic i_br_less, i_br_equal,
    
    output logic o_opa_sel, o_opb_sel, o_pc_sel, 
    output logic [1:0] o_wb_sel,
    output logic [3:0] o_alu_op, 
    output logic o_mem_wren, o_rd_wren, 
    output logic o_br_uns,
    output logic o_insn_vld
);
    
    always_comb begin
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
            default:begin
                o_opa_sel = 0; 
                o_opb_sel = 0; 
                o_mem_wren = 0; 
                o_wb_sel = 2'b01; 
                o_rd_wren = 0; 
                o_br_uns = 0; 
                o_pc_sel = 0; 
                o_insn_vld = 0;
                o_alu_op = 4'd10; 
            end
        endcase 
    end
endmodule 