module immgen (
    input logic [31:0] instr_i, 
    output logic [31:0] imm_o
);

    logic [19:0] imm_i_d;
    logic [31:0] imm_o_d; 
    
    always_comb begin
        case (instr_i[6:0])
        7'b1100011: begin
            imm_i_d = {7'd0,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]} << 1;
            imm_o_d = (instr_i[12]) ? {20'hFFFFF,imm_i_d[11:0]} : {20'd0,imm_i_d[11:0]};
            imm_o = imm_o_d << 2; 
        end
        7'b0010011: begin
            imm_i_d = {8'd0,instr_i[31:20]}; 
            imm_o_d = (instr_i[11]) ? {20'hFFFFF,imm_i_d[11:0]} : {20'd0,imm_i_d[11:0]}; 
            imm_o = imm_o_d; 
        end
            default: begin
			    imm_i_d = 20'd0; 
             imm_o_d = 32'd0; 
             imm_o = 32'd0; 
            end
        endcase
    end
endmodule 