module alu (
    input logic [31:0] i_operand_a, i_operand_b, 
    input logic [3:0] i_alu_op, 
    output logic [31:0] o_alu_data
);

    logic common_signed; 
    logic [31:0] arimethic_signed_shift; 
    logic [32:0] subtrac_result; 


    assign common_signed = (i_operand_a[31] == i_operand_b[31]); 
    assign subtrac_result = i_operand_a + ~i_operand_b + 1; 
    assign arimethic_signed_shift  = (i_operand_a[31]) ? 32'hFFFFFFFF : 32'd0; 

    always_comb begin
        case (i_alu_op)
        //ADD
        4'd0: begin
            o_alu_data = i_operand_a + i_operand_b; 
        end
        //SUB
        4'd1: begin
            o_alu_data = subtrac_result; 
        end
        //SLT
        4'd2: begin
            o_alu_data = (common_signed) ? {31'd0,subtrac_result[31]} : {31'd0,i_operand_a[31]}; 
        end
        //SLTU
        4'd3: begin
            o_alu_data = {31'd0,subtrac_result[32]}; 
        end
        //XOR
        4'd4: begin
            o_alu_data = i_operand_a ^ i_operand_b;
        end
        //OR
        4'd5: begin
            o_alu_data = i_operand_a | i_operand_b; 
        end
        //AND
        4'd6: begin
            o_alu_data = i_operand_a & i_operand_b; 
        end
        //SLL
        4'd7: begin
            logic [31:0] temp_sll;

            temp_sll = i_operand_a;

            if (i_operand_b[0]) begin
                temp_sll = {temp_sll[30:0],1'd0};
            end else begin
                temp_sll = temp_sll; 
            end

            if (i_operand_b[1]) begin
                temp_sll = {temp_sll[29:0],2'd0};
            end else begin
                temp_sll = temp_sll; 
            end

            if (i_operand_b[2]) begin
                temp_sll = {temp_sll[27:0],4'd0};
            end else begin
                temp_sll = temp_sll; 
            end

            if (i_operand_b[3]) begin
                temp_sll = {temp_sll[23:0],8'd0};
            end else begin
                temp_sll = temp_sll; 
            end

            if (i_operand_b[4]) begin
                temp_sll = {temp_sll[15:0],16'd0};
            end else begin
                temp_sll = temp_sll; 
            end

            o_alu_data = temp_sll; 
        end
        //SRL
        4'd8: begin
            logic [31:0] temp_srl;

            temp_srl = i_operand_a;

            if (i_operand_b[0]) begin
                temp_srl = {1'd0,temp_srl[31:1]};
            end else begin
                temp_srl = temp_srl; 
            end

            if (i_operand_b[1]) begin
                temp_srl = {2'd0,temp_srl[31:2]};
            end else begin
                temp_srl = temp_srl; 
            end

            if (i_operand_b[2]) begin
                temp_srl = {4'd0,temp_srl[31:4]};
            end else begin
                temp_srl = temp_srl; 
            end

            if (i_operand_b[3]) begin
                temp_srl = {8'd0,temp_srl[31:8]};
            end else begin
                temp_srl = temp_srl; 
            end

            if (i_operand_b[4]) begin
                temp_srl = {16'd0,temp_srl[31:16]};
            end else begin
                temp_srl = temp_srl; 
            end

            o_alu_data = temp_srl;
        end
        //SRA
        4'd9: begin
            logic [31:0] temp_sra;

            temp_sra = i_operand_a;

            if (i_operand_b[0]) begin
                temp_sra = {arimethic_signed_shift[0],temp_sra[31:1]};
            end else begin
                temp_sra = temp_sra; 
            end

            if (i_operand_b[1]) begin
                temp_sra = {arimethic_signed_shift[1:0],temp_sra[31:2]};
            end else begin
                temp_sra = temp_sra; 
            end

            if (i_operand_b[2]) begin
                temp_sra = {arimethic_signed_shift[3:0],temp_sra[31:4]};
            end else begin
                temp_sra = temp_sra; 
            end

            if (i_operand_b[3]) begin
                temp_sra = {arimethic_signed_shift[7:0],temp_sra[31:8]};
            end else begin
                temp_sra = temp_sra; 
            end

            if (i_operand_b[4]) begin
                temp_sra = {arimethic_signed_shift[15:0],temp_sra[31:16]};
            end else begin
                temp_sra = temp_sra; 
            end

            o_alu_data = temp_sra;
        end
        // LUI 
        4'd10: begin
            o_alu_data = i_operand_b; 
        end
            default: o_alu_data = 32'd0; 
        endcase
    end
endmodule 