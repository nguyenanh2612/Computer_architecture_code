module harzard_dection (
    // Input 
    input logic [4:0] i_id_rs1, i_id_rs2, i_id_rd, 
    input logic [4:0] i_ex_rd, 
    input logic i_ex_read,
    // Output
    output logic o_pc_enable, 
    output logic o_if_id_register_enable, 
    output logic o_pipeline_stall
);
/******************************************  Execute after Read *******************************************************/ 
    always_comb begin
        if (((i_ex_rd == i_id_rs1 && i_ex_rd != 5'd0) || (i_ex_rd == i_id_rs2 && i_ex_rd != 5'd0)) && i_ex_read) begin
            o_pc_enable = 1'b0; 
            o_if_id_register_enable = 1'b0; 
            o_pipeline_stall = 1'b0; 
        end else begin
            o_pc_enable = 1'b1; 
            o_if_id_register_enable = 1'b1; 
            o_pipeline_stall = 1'b1;
        end
    end
    
endmodule