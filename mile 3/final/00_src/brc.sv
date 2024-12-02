module brc (
    // Input
    input logic [31:0] i_rs1_data, i_rs2_data, 
    input logic [2:0] i_br_type,
    input logic i_br_uns,  
    // Output
    output logic o_pc_sel
);

/*****************************************Immediate label ***************************************/
    logic br_less, br_equal; 
    logic common_signed; 
    logic [32:0] subtrac_result; 

/*****************************************Prepare calculation ***************************************/
    assign common_signed = (i_rs1_data[31] == i_rs2_data[31]); 
    assign subtrac_result = i_rs1_data + ~i_rs2_data + 1;

/*****************************************BRC calculation ***************************************/
    always_comb begin 
        if (i_br_uns) begin
            br_less = subtrac_result[32]; 
            br_equal = (subtrac_result[31:0] == 32'd0); 
        end
        else begin
            br_less = (common_signed) ? subtrac_result[31] : i_rs1_data[31];
            br_equal = (subtrac_result[30:0] == 31'd0);  
        end
    end
    
    always_comb begin
        case (i_br_type)
        // BEQ
        3'd0: begin
            o_pc_sel = br_equal; 
        end
        // BNE 
        3'd1: begin
            o_pc_sel = ~br_equal;
        end
        // BLT 
        3'd2: begin
            o_pc_sel = (br_less & ~br_equal); 
        end
        // BGE
        3'd3: begin
            o_pc_sel = (~br_less | br_equal); 
        end
        // BLTU
        3'd4: begin
            o_pc_sel = (br_less & ~br_equal);
        end
        // BGEU 
        3'd5: begin
           o_pc_sel = (~br_less | br_equal);
        end
            default: begin
                o_pc_sel = 1'b0; 
            end
        endcase
    end  
endmodule