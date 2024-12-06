module mem_stage (
    // Clock and reset
    input logic i_clk, i_rst, 
    // Input
    input logic i_mem_wren, 
    input logic [1:0]  i_st_rewrite,
    input logic [3:0]  i_io_btn, 
    input logic [31:0] i_io_sw, 
    input logic [31:0] i_alu_data,
    input logic [31:0] i_st_data,
    // Output
    output logic [31:0] o_io_ledr, o_io_ledg, o_hex_data_1, o_hex_data_2, o_io_lcd,
    output logic [31:0] o_ld_data
);
/***************************************** Immediate signal ***************************************/
    logic [31:0] output_peripheral [15:0]; 
    logic [31:0] input_peripheral [8:0]; 
    logic [31:0] data_memory [2047:0]; 

    logic [31:0] addr_shifted; 
    logic mem_access_vld; 
    logic [31:0] new_output_data; 
    logic [31:0] new_mem_data, ld_mem_data; 

    // IO signals 
    logic [31:0] temp_io_ledr;
    logic [31:0] temp_io_ledg;
    logic [31:0] temp_hex_data_1;
    logic [31:0] temp_hex_data_2;
    logic [31:0] temp_io_lcd;
/***************************************** Initial data  ***************************************/ 
    initial begin
        output_peripheral <= '{default:32'd0}; 
        input_peripheral <= '{default:32'd0}; 
        data_memory <= '{default:32'd0}; 
    end
/***************************************** Shift address ***************************************/
    assign addr_shifted = i_alu_data >> 2; 
    assign mem_access_vld = (addr_shifted[31:12] == 20'h00000 & addr_shifted[11]) ? 1'b1: 1'b0; 
/***************************************** Store rewrite ***************************************/
    st_data_rewrite st_rewrite_output(
       // Input 
       .i_lsu_addr_segment        (i_alu_data[1:0]),
       .i_st_type                 (i_st_rewrite),  
       .i_st_data                 (i_st_data), 
       .i_ld_data                 (output_peripheral[addr_shifted[3:0]]), 
       // Output
       .o_st_new_data             (new_output_data)
    ); 

    st_data_rewrite st_rewrite_mem(
       // Input 
       .i_lsu_addr_segment        (i_alu_data[1:0]),
       .i_st_type                 (i_st_rewrite),  
       .i_st_data                 (i_st_data), 
       .i_ld_data                 (ld_mem_data), 
       // Output
       .o_st_new_data             (new_mem_data)
    );
/***************************************** Load and Store ***************************************/
    /***************************************** Input ***************************************/
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            input_peripheral <= '{default:32'd0};
        end else begin
            if ((addr_shifted == 32'h00001E00 || addr_shifted == 32'h00001E01 || addr_shifted == 32'h00001E02 || addr_shifted == 32'h00001E03) & i_mem_wren) begin
                input_peripheral[addr_shifted[3:0]] <= i_io_sw;
            end else if ((addr_shifted == 32'h00001E04 || addr_shifted == 32'h00001E05 || addr_shifted == 32'h00001E06 || addr_shifted == 32'h00001E07) & i_mem_wren) begin
                input_peripheral[addr_shifted[3:0]] <= {28'd0,i_io_btn};
            end else begin
                input_peripheral[addr_shifted[3:0]] <= input_peripheral[addr_shifted[3:0]];
            end
        end
    end 
    /***************************************** Output ***************************************/
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            output_peripheral <= '{default:32'd0};
        end else begin
            if ( addr_shifted[31:4] == 32'h00001C0 && i_mem_wren) begin
                output_peripheral[addr_shifted[3:0]] <= new_output_data;
            end else begin
                output_peripheral[addr_shifted[3:0]] <= output_peripheral[addr_shifted[3:0]]; 
            end
        end
    end
    /***************************************** Data ***************************************/
    // Read task
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ld_mem_data <= 32'd0; 
        end else begin
            if (mem_access_vld) begin
                ld_mem_data <= data_memory[addr_shifted[10:0]];
            end else begin
                ld_mem_data <= ld_mem_data; 
            end
        end
    end
    // Write task
    always_ff @( negedge i_clk) begin
        if (mem_access_vld & i_mem_wren) begin
            data_memory[addr_shifted[10:0]] <= new_mem_data;
        end 
    end
/***************************************** Output assign ***************************************/
    logic [31:0] addr_hold; 
    always_ff @(posedge i_clk) begin
        addr_hold <= addr_shifted;
    end

    always_ff @(posedge i_clk) begin
        // Update temp_io_ledr
        if (addr_hold == 32'h00001C00 || addr_hold == 32'h00001C01 || addr_hold == 32'h00001C02 || addr_hold == 32'h00001C03) begin
            o_io_ledr <= output_peripheral[addr_hold[3:0]];
        end else begin
            o_io_ledr <= o_io_ledr; 
        end
    
        // Update temp_io_ledg
        if (addr_hold == 32'h00001C04 || addr_hold == 32'h00001C05 || addr_hold == 32'h00001C06 || addr_hold == 32'h00001C07) begin
            o_io_ledg <= output_peripheral[addr_hold[3:0]];
        end else begin
            o_io_ledg <= o_io_ledg; 
        end
    
        // Update temp_hex_data_1
        if (addr_hold == 32'h00001C08) begin
            o_hex_data_1 <= output_peripheral[addr_hold[3:0]];
        end else begin
            o_hex_data_1 <= o_hex_data_1; 
        end
    
        // Update temp_hex_data_2
        if (addr_hold == 32'h00001C09) begin
            o_hex_data_2 <= output_peripheral[addr_hold[3:0]];
        end else begin
            o_hex_data_2 <= o_hex_data_2; 
        end
    
        // Update temp_io_lcd
        if (addr_hold == 32'h00001C0C || addr_hold == 32'h00001C0D || addr_hold == 32'h00001C0E || addr_hold == 32'h00001C0F) begin
            o_io_lcd <= output_peripheral[addr_hold[3:0]];
        end else begin
            o_io_lcd <= o_io_lcd; 
        end
    end

/***************************************** Load output ***************************************/
    always_comb begin
        if (addr_shifted[31:4] == 32'h00001C0) begin
            o_ld_data = output_peripheral[addr_shifted[3:0]];
        end else if (addr_shifted[31:4] == 32'h00001E0) begin
            o_ld_data = input_peripheral[addr_shifted[3:0]];
        end else if (mem_access_vld) begin
            o_ld_data = ld_mem_data;
        end else begin
            o_ld_data = 32'd0; 
        end
    end

endmodule 