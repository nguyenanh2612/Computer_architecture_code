module mem_stage (
    // Clock and reset
    input logic i_clk, i_rst, 
    // Input
    input logic i_mem_wren, 
    input logic [1:0]  i_st_rewrite,
    input logic [31:0] i_alu_data,
    input logic [31:0] i_st_data,
    // Output
    output logic [31:0] o_ld_data
);
/***************************************** Immediate signal ***************************************/
    logic [31:0] output_peripheral [15:0]; 
    //logic [31:0] input_peripheral [8:0]; 
    logic [31:0] data_memory [2047:0]; 

    logic [31:0] addr_shifted; 
    logic mem_access_vld; 
    logic [31:0] new_output_data; 
    logic [31:0] new_mem_data, ld_mem_data; 
/***************************************** Initial data  ***************************************/ 
    initial begin
        output_peripheral <= '{default:32'd0}; 
        //input_peripheral <= '{default:32'd0}; 
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
/***************************************** Load output ***************************************/
    always_comb begin
        if (addr_shifted[31:4] == 32'h00001C0) begin
            o_ld_data = output_peripheral[addr_shifted[3:0]];
        end else if (mem_access_vld) begin
            o_ld_data = ld_mem_data;
        end else begin
            o_ld_data = 32'd0; 
        end
    end

endmodule 