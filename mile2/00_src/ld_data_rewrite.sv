module ld_data_rewrite (
    input logic [1:0] i_segment_lsu_addr, 
    input logic [2:0] i_rewrite_sel, 
    input logic [31:0] i_ld_data, 
    output logic [31:0] o_new_ld_data
);
    always_comb begin
        case (i_rewrite_sel)
        // LB
        3'd0: begin
            case (i_segment_lsu_addr)
            2'd0: begin
                o_new_ld_data = {{24{i_ld_data[7]}}, i_ld_data[7:0]};
            end
            2'd1: begin
                o_new_ld_data = {{24{i_ld_data[15]}},i_ld_data[15:8]};
            end
            2'd2: begin
                o_new_ld_data = {{24{i_ld_data[23]}},i_ld_data[23:16]};
            end
            2'd3: begin
                o_new_ld_data = {{24{i_ld_data[31]}},i_ld_data[31:24]};
            end
            endcase
        end
        // LH
        3'd1: begin
            if (i_segment_lsu_addr[1]) begin
                o_new_ld_data = {{16{i_ld_data[31]}},i_ld_data[31:16]};
            end else begin
                o_new_ld_data = {{16{i_ld_data[15]}},i_ld_data[15:0]};
            end
        end
        // LW
        3'd2: begin
            o_new_ld_data = i_ld_data; 
        end
        // LBU
        3'd3: begin
            case (i_segment_lsu_addr)
            2'd0: begin
                o_new_ld_data = {24'd0,i_ld_data[7:0]};
            end
            2'd1: begin
                o_new_ld_data = {24'd0,i_ld_data[15:8]};
            end
            2'd2: begin
                o_new_ld_data = {24'd0,i_ld_data[23:16]};
            end
            2'd3: begin
                o_new_ld_data = {24'd0,i_ld_data[31:24]};
            end
            endcase 
        end
        // LHU
        3'd4: begin
            if (i_segment_lsu_addr[1]) begin
                o_new_ld_data = {16'd0,i_ld_data[31:16]};
            end else begin
                o_new_ld_data = {16'd0,i_ld_data[15:0]};
            end
        end
            default: begin
                o_new_ld_data = 32'd0; 
            end
        endcase
    end
endmodule 