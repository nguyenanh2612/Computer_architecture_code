module divide_ld_data (
    input logic [31:0] addr, ld_data, 
    input logic ld_unsigned, lh_en, lb_en, 
    output logic [31:0] ld_data_new
);
    logic [31:0] signed_extend; 

    always_comb begin
        signed_extend = 32'd0;
        ld_data_new = ld_data;  
        if (lh_en) begin
            if (addr[1]) begin
                signed_extend = (ld_data[31]) ? 32'hFFFFFFFF : 32'd0; 
                ld_data_new = (~ld_unsigned) ? {signed_extend[15:0] , ld_data[31:16]} : (ld_data >> 16) & 32'h0000FFFF;
            end
            else begin
                signed_extend = (ld_data[15]) ? 32'hFFFFFFFF : 32'd0; 
                ld_data_new = (~ld_unsigned) ? {signed_extend[15:0] , ld_data[15:0]} : ld_data & 32'h0000FFFF;
            end
        end
        else if (lb_en) begin
            case (addr[1:0])
            2'd0: begin
                signed_extend = (ld_data[7]) ? 32'hFFFFFFFF : 32'd0;
                ld_data_new = (~ld_unsigned) ? {signed_extend[23:0] , ld_data[7:0]} : ld_data & 32'h000000FF;
            end
            2'd1: begin
                signed_extend = (ld_data[15]) ? 32'hFFFFFFFF : 32'd0;
                ld_data_new = (~ld_unsigned) ? {signed_extend[23:0] , ld_data[15:8]} : (ld_data >> 8) & 32'h000000FF;
            end
            2'd2: begin
                signed_extend = (ld_data[23]) ? 32'hFFFFFFFF : 32'd0;
                ld_data_new = (~ld_unsigned) ? {signed_extend[23:0] , ld_data[23:16]} : (ld_data >> 16) & 32'h000000FF;
            end
            2'd3: begin
                signed_extend = (ld_data[31]) ? 32'hFFFFFFFF : 32'd0;
                ld_data_new = (~ld_unsigned) ? {signed_extend[23:0] , ld_data[31:24]} : (ld_data >> 24) & 32'h000000FF;
            end
            endcase
        end
    end
endmodule 