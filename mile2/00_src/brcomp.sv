module brcomp (
    input logic [31:0] rs1_data_i, rs2_data_i, 
    input logic br_unsigned_i, 
    output logic br_less_o, br_equal_o
);
    logic [32:0] sub_d; 
    assign sub_d = rs1_data_i + ~rs2_data_i + 1;

    always_comb begin
        if (br_unsigned_i) begin
            br_less_o = (sub_d[32]) ? 1'b1 : 1'b0; 
        end
        else begin
            br_less_o = (rs1_data_i[31] == rs2_data_i[31]) ? sub_d[31] : ~sub_d & rs1_data_i[31]; 
        end
    end

    assign br_equal_o = (sub_d == 31'd0) ? 1'b1 : 1'b0; 
endmodule 
