module lsu (
    input logic i_clk, i_rst,
	 input logic [2:0] i_ld_type, 
    input logic [31:0] i_lsu_addr, 
    input logic [31:0] i_st_data, 
    input logic i_lsu_wren, 

    output logic [31:0] o_io_ledr,o_io_ledg,
    output logic [31:0] o_ld_data	 
);

    logic [31:0] ram [7687:0]; 

    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            o_ld_data <= 32'd0; 
			o_io_ledr <= 32'd0; 
            o_io_ledg <= 32'd0;
        end else begin
            if (i_lsu_wren) begin
                ram[i_lsu_addr] <= i_st_data;
            end else begin
                o_ld_data <= ram[i_lsu_addr];
					 
		    // Update o_io_ledr
            if ((i_lsu_addr == 32'h00001C00 || i_lsu_addr == 32'h00001C01 || i_lsu_addr == 32'h00001C02 || i_lsu_addr == 32'h00001C03) && !i_lsu_wren) begin
                o_io_ledr <= o_ld_data;
            end

            // Update o_io_ledg
            if ((i_lsu_addr == 32'h00001C04 || i_lsu_addr == 32'h00001C05 || i_lsu_addr == 32'h00001C06 || i_lsu_addr == 32'h00001C07) && !i_lsu_wren) begin
                o_io_ledg <= o_ld_data;
            end

            end
        end 
    end
	
endmodule 