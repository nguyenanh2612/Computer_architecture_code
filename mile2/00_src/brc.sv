module brc (
    // Input 
    input logic i_br_uns, 
    input logic [31:0] i_operand_a, i_operand_b, 
    // Output 
    output logic o_br_less, o_br_equal
);

/*****************************************Immediate label ***************************************/
    logic common_signed; 
    logic [32:0] subtrac_result; 

/*****************************************Prepare calculation ***************************************/
    assign common_signed = (i_operand_a[31] == i_operand_b[31]); 
    assign subtrac_result = i_operand_a + ~i_operand_b + 1;

/*****************************************BRC calculation ***************************************/
    always_comb begin 
        if (i_br_uns) begin
            o_br_less = subtrac_result[32]; 
            o_br_equal = (subtrac_result[31:0] == 32'd0); 
        end
        else begin
            o_br_less = (common_signed) ? subtrac_result[31] : i_operand_a[31];
            o_br_equal = (subtrac_result[30:0] == 31'd0);  
        end
    end
endmodule 