module wren_with_mm (
    input logic i_mem_wren, 
    input logic [31:0] i_lsu_addr,  
    output logic o_mem_wren, o_st_data_sel
);
    always_comb begin
        if (i_mem_wren) begin
            if (i_lsu_addr[15:12] == 4'd0 & i_lsu_addr[11] ) begin
                o_mem_wren = 1; 
            end else if (i_lsu_addr[15:4] == 12'h1C0) begin
                o_mem_wren = 1; 
            end else if (i_lsu_addr[15:4] == 12'h1E0 & ~i_lsu_addr[3]) begin
                o_mem_wren = 1; 
            end else begin
                o_mem_wren = 0; 
            end
        end else begin
		      o_mem_wren = 0; 
		  end 
    end

    assign o_st_data_sel =  (i_lsu_addr[15:4] == 12'h1E0 & i_lsu_addr[3:2] == 2'd0); 
endmodule 