module divide_st_data (
    input logic [31:0] st_data, addr, 
    input logic sth_en, stb_en, 
    output logic [31:0] st_data_new
);

    always_comb begin 
        st_data_new = st_data; 
        
        if (sth_en) begin
            if (addr[1]) 
                st_data_new = st_data & 32'hFFFF0000; 
            else 
                st_data_new = st_data & 32'h0000FFFF; 
        end 
        
        else if (stb_en) begin
            case (addr[1:0])
                2'd0: st_data_new = st_data & 32'h000000FF; 
                2'd1: st_data_new = st_data & 32'h0000FF00; 
                2'd2: st_data_new = st_data & 32'h00FF0000; 
                2'd3: st_data_new = st_data & 32'hFF000000; 
            endcase
        end
    end
endmodule
