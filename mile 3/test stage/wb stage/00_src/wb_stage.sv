module wb_stage (
    // Input 
    input logic [1:0] i_wb_sel, 
    input logic [2:0] i_ld_rewrite, 
    input logic [31:0] i_pc_four, 
    input logic [31:0] i_alu_data, 
    input logic [31:0] i_ld_data, 
    // Output 
    output logic [31:0] o_wb_data 
);
/***************************************** Immediate signals ***************************************/
    logic [31:0] new_ld_data; 
/***************************************** LD instructions's data rewrite ***************************************/
    ld_data_rewrite rewrite_ld(
       // Input
       .i_segment_lsu_addr  (i_alu_data[1:0]),
       .i_rewrite_sel       (i_ld_rewrite),
       .i_ld_data, 
       // Output
       .o_new_ld_data       (new_ld_data)
    ); 
/***************************************** WB data selection ***************************************/
    always_comb begin : blockName
        case (i_wb_sel)
        2'd0: o_wb_data = i_pc_four;
        2'd1: o_wb_data = i_alu_data; 
        2'd2: o_wb_data = new_ld_data; 
        2'd3: o_wb_data = 32'd0;
        endcase
    end
endmodule