module st_data_rewrite (
    input logic [1:0] i_lsu_addr_segment,  i_st_type, 
    input logic [31:0] i_ld_data, 
    input logic [31:0] i_st_data, 
    output logic [31:0] o_st_new_data
);
    always_comb begin
        case (i_st_type)
        2'd0: begin
            case (i_lsu_addr_segment)
            2'd0: begin
                o_st_new_data = {i_ld_data[31:8], i_st_data[7:0]}; 
            end
            2'd1: begin
                o_st_new_data = {i_ld_data[31:16], i_st_data[15:8], i_ld_data[7:0]}; 
            end
            2'd2: begin
                o_st_new_data = {i_ld_data[31:24], i_st_data[23:16], i_ld_data[15:0]}; 
            end
            2'd3: begin
                o_st_new_data = {i_st_data[31:24], i_ld_data[23:0]}; 
            end
            endcase
        end
        2'd1: begin
            if (i_lsu_addr_segment[1]) begin
                o_st_new_data = {i_st_data[31:16], i_ld_data[15:0]};
            end else begin
                o_st_new_data = {i_ld_data[31:16], i_st_data[15:0]};
            end
        end
        2'd2: begin
            o_st_new_data = i_st_data; 
        end
            default: begin
                o_st_new_data = 32'd0; 
            end
        endcase
    end
endmodule 