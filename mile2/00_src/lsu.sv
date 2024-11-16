module lsu (
    // Input 
    input logic i_clk, i_rst, i_mem_wren, i_rden, 
    input logic [1:0] i_st_rewrite, 
    input logic [31:0] i_lsu_addr,
    input logic [31:0] i_st_data, 
    input logic [17:0] i_io_sw, 
    input logic [3:0] i_io_btn,

    //Output sram controller
    output logic o_ack, 
    output logic [17:0] o_sram_addr,
    inout  wire [15:0] o_sram_dq, 
    output logic [2:0] o_sram_state,  
    output logic o_ce, 
    output logic o_we, 
    output logic o_lb, 
    output logic o_ub, 
    output logic o_oe, 

    // Output peripheral
    output logic [31:0] o_io_ledr, o_io_ledg, o_hex_data_1, o_hex_data_2, o_io_lcd,
    output logic [31:0] o_ld_data
);
    
    // Register of input and output peripheral
    logic [31:0] output_peripheral [15:0];
    logic [31:0] input_peripheral [8:0]; 
    
    // IO signals
    logic [31:0] temp_io_ledr, temp_o_ledr ;
    logic [31:0] temp_io_ledg, temp_o_ledg;
    logic [31:0] temp_hex_data_1, temp_o_hex_data_1;
    logic [31:0] temp_hex_data_2, temp_o_hex_data_2;
    logic [31:0] temp_io_lcd, temp_o_lcd;

    // Addr immediate
    logic [31:0] addr_shift; 
    logic [31:0] addr_hold; 

    // Wire new st data
    logic [31:0] new_st_data;
    logic [31:0] new_st_data_dmem; 

    // Sram signal 
    logic sram_enable,ack,oe; 
    logic [31:0] memory_data; 

    // Dmem register
    //logic [31:0] dmem [2047:0];

    // Shift right addr 2 bits
    assign addr_shift = {2'b00,i_lsu_addr[31:2]}; 

/*****************************************Initial of input and output ***************************************/
    initial begin
        output_peripheral <= '{default: 32'd0}; 
        input_peripheral <= '{default: 32'd0}; 
    end

/***************************************** Control IP Sram****************************************************/
    always_comb begin
        if (addr_shift[31:12] == 20'h00000 & addr_shift[11] & (i_mem_wren || i_rden)) begin
            sram_enable = 1; 
            o_ack = ack;
        end else begin
            sram_enable = 0; 
            o_ack = 1; 
        end
    end

    sram_IS61WV25616_controller_32b_3lr sram_controller(
        // Input
        .i_clk (i_clk), 
        .i_reset (!i_rst),
        // LSU connect
        .i_ADDR     (i_lsu_addr[17:0]),
        .i_WDATA    (i_st_data),
        .i_BMASK    (4'b1111),
        .i_WREN     (i_mem_wren & sram_enable),
        .i_RDEN     (i_rden & sram_enable),
        .o_RDATA    (memory_data),
        .o_ACK      (ack),
        // Sram connect
        .SRAM_STATE (o_sram_state), 
        .SRAM_ADDR  (o_sram_addr),
        .SRAM_DQ    (o_sram_dq),
        .SRAM_CE_N  (o_ce),
        .SRAM_WE_N  (o_we),
        .SRAM_LB_N  (o_lb),
        .SRAM_UB_N  (o_ub),
        .SRAM_OE_N  (o_oe)
    );  

/*****************************************Rewrite st data for SB SH *******************************************/
    st_data_rewrite st_rewrite(
        .i_lsu_addr_segment (i_lsu_addr[1:0]),
        .i_st_type (i_st_rewrite), 
        .i_ld_data (output_peripheral[addr_shift[3:0]]), 
        .i_st_data (i_st_data), 
        .o_st_new_data (new_st_data)
    );

/***************************************** Dmem with registers array ****************************************************/
// always_ff @( posedge i_clk or posedge i_rst ) begin
//     if (i_rst) begin
//         dmem <= '{default: 32'd0}; 
//     end else begin
//         if (addr_shift[31:12] == 20'h00000 & addr_shift[11] & i_mem_wren) begin
//             dmem[addr_shift[10:0]] <= new_st_data_dmem; 
//         end else begin
//              dmem[addr_shift[10:0]] <=  dmem[addr_shift[10:0]]; 
//         end
//     end
// end

/*****************************************Output peripheral update*********************************************/
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            output_peripheral <= '{default: 32'd0}; 
        end else begin
            if (addr_shift[31:4] == 28'h00001C0 && i_mem_wren) begin
                output_peripheral[addr_shift[3:0]] <= new_st_data; 
            end else begin
                output_peripheral[addr_shift[3:0]] <= output_peripheral[addr_shift[3:0]]; 
            end
        end
    end 

/****************************************Input peripheral update************************************************/   
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            input_peripheral <= '{default: 32'd0}; 
        end else begin
            if ((addr_shift == 32'h00001E00 || addr_shift == 32'h00001E01 || addr_shift == 32'h00001E02 || addr_shift == 32'h00001E03) && i_mem_wren) begin
                input_peripheral[addr_shift[3:0]] <= {14'd0,i_io_sw};
            end else if ((addr_shift == 32'h00001E04 || addr_shift == 32'h00001E05 || addr_shift == 32'h00001E06 || addr_shift == 32'h00001E07) && i_mem_wren) begin
                input_peripheral[addr_shift[3:0]] <= {18'd0,i_io_btn};
            end else begin
                input_peripheral[addr_shift[3:0]] <= input_peripheral[addr_shift[3:0]];
            end
        end
    end

/****************************************Output the lsu**********************************************************/
    always_ff @( posedge i_clk ) begin
        addr_hold <= addr_shift; 
    end

    always_ff @( posedge i_clk or posedge i_rst ) begin 
        if (i_rst) begin 
            o_io_ledr <= 32'd0; 
            o_io_ledg <= 32'd0;
            o_io_lcd <= 32'd0; 
            o_hex_data_1 <= 32'd0;
            o_hex_data_2 <= 32'd0;
        end else begin
            // Update o_io_ledr
            if (addr_hold == 32'h00001C00 || addr_hold == 32'h00001C01 || addr_hold == 32'h00001C02 || addr_hold == 32'h00001C03) begin
                o_io_ledr <= output_peripheral[addr_hold[3:0]];
            end else begin
                o_io_ledr <= o_io_ledr; 
            end
            // Update o_io_ledg
            if (addr_hold == 32'h00001C04 || addr_hold == 32'h00001C05 || addr_hold == 32'h00001C06 || addr_hold == 32'h00001C07) begin
                o_io_ledg <= output_peripheral[addr_hold[3:0]];
            end else begin
                o_io_ledg <= o_io_ledg; 
            end
            // update o_hex_data
            if (addr_hold == 32'h00001C08) begin
                o_hex_data_1 <= output_peripheral[addr_hold[3:0]];
            end else begin
                o_hex_data_1 <= o_hex_data_1; 
            end
            if (addr_hold == 32'h00001C09) begin
                o_hex_data_2 <= output_peripheral[addr_hold[3:0]];
            end else begin
                o_hex_data_2 <= o_hex_data_2; 
            end
            // Update o_io_lcd
            if (addr_hold == 32'h00001C0C || addr_hold == 32'h00001C0D || addr_hold == 32'h00001C0E || addr_hold == 32'h00001C0F) begin
                o_io_lcd <= output_peripheral[addr_hold[3:0]];
            end else begin
                o_io_lcd <= o_io_lcd; 
            end 
        end
    end
/**************************************** New output the lsu**********************************************************/	 
    //Initialize signals to default values
    // assign temp_io_ledr = o_io_ledr;
    // assign temp_io_ledg = o_io_ledg;
    // assign temp_hex_data_1 = o_hex_data_1;
    // assign temp_hex_data_2 = o_hex_data_2;
    // assign temp_io_lcd = o_io_lcd;

    // always_comb begin
    //     temp_io_ledr = o_io_ledr;
    //     temp_io_ledg = o_io_ledg;
    //     temp_hex_data_1 = o_hex_data_1;
    //     temp_hex_data_2 = o_hex_data_2;
    //     temp_io_lcd = o_io_lcd;
    //     // Update temp_io_ledr
    //     if (addr_shift == 32'h00001C00 || addr_shift == 32'h00001C01 || addr_shift == 32'h00001C02 || addr_shift == 32'h00001C03) begin
    //         temp_o_ledr = output_peripheral[addr_shift[3:0]];
    //     end else begin
    //         temp_o_ledr = temp_io_ledr; 
    //     end
    
    //     // Update temp_io_ledg
    //     if (addr_shift == 32'h00001C04 || addr_shift == 32'h00001C05 || addr_shift == 32'h00001C06 || addr_shift == 32'h00001C07) begin
    //         temp_o_ledg = output_peripheral[addr_shift[3:0]];
    //     end else begin
    //         temp_o_ledg = temp_io_ledg;
    //     end
    
    //     // Update temp_hex_data_1
    //     if (addr_shift == 32'h00001C08) begin
    //         temp_o_hex_data_1 = output_peripheral[addr_shift[3:0]];
    //     end else begin
    //         temp_o_hex_data_1 = temp_hex_data_1;
    //     end
    
    //     // Update temp_hex_data_2
    //     if (addr_shift == 32'h00001C09) begin
    //         temp_o_hex_data_2 = output_peripheral[addr_shift[3:0]];
    //     end else begin
    //         temp_o_hex_data_2 = temp_hex_data_2;
    //     end
    
    //     // Update temp_io_lcd
    //     if (addr_shift == 32'h00001C0C || addr_shift == 32'h00001C0D || addr_shift == 32'h00001C0E || addr_shift == 32'h00001C0F) begin
    //         temp_o_lcd = output_peripheral[addr_shift[3:0]];
    //     end else begin
    //         temp_o_lcd = temp_io_lcd;
    //     end
    // end

    // // Assign temporary signals to output signals
    // assign o_io_ledr = temp_o_ledr;
    // assign o_io_ledg = temp_o_ledg;
    // assign o_hex_data_1 = temp_o_hex_data_1;
    // assign o_hex_data_2 = temp_o_hex_data_2;
    // assign o_io_lcd = temp_o_lcd;


/****************************************Output the ld data**********************************************************/
    always_comb begin
        if (addr_shift[31:4] == 28'h00001C0) begin
            o_ld_data = output_peripheral[addr_shift[3:0]];
        end else if (addr_shift[31:4] == 28'h00001E0) begin 
            o_ld_data = input_peripheral[addr_shift[3:0]];
        end else if (addr_shift[31:12] == 20'h00000 & addr_shift[11]) begin
            o_ld_data =  memory_data; 
        end else begin
            o_ld_data = 32'd0; 
        end
    end
endmodule