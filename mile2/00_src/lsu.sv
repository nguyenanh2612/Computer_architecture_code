module lsu (
    input logic i_clk, i_rst, i_io_wren, 
    input logic [31:0] i_lsu_addr, 
    input logic [31:0] i_st_data, 
    input logic i_lsu_wren, 

    output logic [31:0] o_io_ledr,o_io_ledg, o_hex_data_1, o_hex_data_2, o_io_lcd, 
    output logic [31:0] o_ld_data	 
);

    logic [31:0] ram [7687:0]; 
	 initial begin
	     ram = '{default: 32'd0};
	 end 

    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            o_ld_data <= 32'd0; 
            o_io_ledr <= 32'd0; 
            o_io_ledg <= 32'd0;
            o_io_lcd <= 32'd0; 
            o_hex_data_1 <= 32'd0; 
            o_hex_data_2 <= 32'd0; 
        end else begin
            if (i_lsu_wren) begin
                ram[i_lsu_addr] <= i_st_data;
            end 
            o_ld_data <= ram[i_lsu_addr];
					 
		    // Update o_io_ledr
            if ((i_lsu_addr == 32'h00001C00 || i_lsu_addr == 32'h00001C01 || i_lsu_addr == 32'h00001C02 || i_lsu_addr == 32'h00001C03) && i_io_wren) begin
                o_io_ledr <= {14'd0,o_ld_data[17:0]};
            end else begin
                o_io_ledr <= o_io_ledr; 
            end

            // Update o_io_ledg
            if ((i_lsu_addr == 32'h00001C04 || i_lsu_addr == 32'h00001C05 || i_lsu_addr == 32'h00001C06 || i_lsu_addr == 32'h00001C07) && i_io_wren ) begin
                o_io_ledg <= {24'd0,o_ld_data[7:0]};
            end else begin
                o_io_ledg <= o_io_ledg; 
            end

            // update o_hex_data
            if (i_lsu_addr == 32'h00001C08 && i_io_wren) begin
                o_hex_data_1 <= o_ld_data;
            end else begin
                o_hex_data_1 <= o_hex_data_1; 
            end

            if (i_lsu_addr == 32'h00001C09 && i_io_wren) begin
                o_hex_data_2 <= o_ld_data;
            end else begin
                o_hex_data_2 <= o_hex_data_2; 
            end

            // Update o_io_lcd
            if ((i_lsu_addr == 32'h00001C0C || i_lsu_addr == 32'h00001C0D || i_lsu_addr == 32'h00001C0E || i_lsu_addr == 32'h00001C0F) && i_io_wren) begin
                o_io_lcd <= o_ld_data;
            end else begin
                o_io_lcd <= o_io_lcd; 
            end
        end 
    end
	
endmodule 