module singlecycle (
    // Input
    input logic i_clk, i_rst,
    input logic [31:0] i_io_sw, 
    input logic [3:0] i_io_btn, 
    
    // Output
    output logic o_insn_vld, 
    output logic [31:0] o_io_ledr, o_io_ledg, o_pc_debug,
    output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, 
    output logic [31:0] o_io_lcd , 

    // Sram output
    output logic [17:0] o_sram_addr, 
    inout wire [15:0] o_sram_dq, 
    output logic [2:0] o_sram_state, 
    output logic o_ce, o_we, o_lb, o_ub, 
    output logic o_oe
);

/*****************************************Immediate label ***************************************/
    // pc + mux for pc signal
    logic pc_sel, pc_stall, stall_flag; 
    logic [31:0] pc_next, pc_cur, pc_four; 
    logic [31:0] pc_br; 

    // Instruction memory signal
    logic [31:0] instruct; 

    // Regfile signal
    logic rd_wren; 
    logic [31:0] rs1_data, rs2_data,wb_data; 

    // alu signal 
    logic [31:0] operand_a, operand_b,alu_data; 
    logic [31:0] immediate_value; 
    logic opa_sel, opb_sel; 
    logic [3:0] alu_op; 

    // write back signal
    logic [1:0] wb_sel; 

    // lsu signal  
    logic [31:0] ld_data, hex_data_1, hex_data_2;
    logic [31:0] new_ld_data; 

    // control unit signal
    logic insn_vld, io_wren; 
    logic br_un, br_less, br_equal; 
    logic mem_wren,rden;   
    logic [1:0] st_rewrite_sel; 
    logic [2:0] ld_rewrite_sel; 

/*****************************************Fetch stage ***************************************/
    // Update pc next 
    always_comb begin
        pc_next = (pc_sel) ? pc_br : pc_four;
    end

    // Update pc at each positive clock
    pc program_counter(
        .i_clk         (i_clk), 
        .i_rst         (!i_rst), 
        .i_pc_stall    (pc_stall),
        .i_pc          (pc_next), 
        .o_pc          (pc_cur)
    );

    // Increasing pc by 4 
    assign pc_four = pc_cur + 32'd4; 
    //assign pc_stall = 1'b1; 

    // Load the instruction
    ins_mem instruction_memory(
        .i_address ({2'd0,pc_cur[31:2]}), 
        .o_data    (instruct)
    ); 

/*****************************************Decode stage ***************************************/
    // Control unit 
    ctrl_unit control_unit(
        // Input 
        .i_instruction    (instruct), 
        .i_br_less        (br_less), 
        .i_br_equal       (br_equal),
        // Output 
        .o_opa_sel        (opa_sel), 
        .o_opb_sel        (opb_sel), 
        .o_pc_sel         (pc_sel), 
        .o_wb_sel         (wb_sel), 
        .o_alu_op         (alu_op), 
        .o_st_rewrite     (st_rewrite_sel),
        .o_ld_rewrite     (ld_rewrite_sel),
        .o_mem_wren       (mem_wren),
        .o_rden           (rden), 
        .o_rd_wren        (rd_wren), 
        .o_br_uns         (br_un), 
        .o_insn_vld       (insn_vld)
    );
	 

    // Load + write data to register file
    regfile register_file(
        // Input 
        .i_clk            (i_clk),
        .i_rst            (!i_rst), 
        .i_rd_wren        (rd_wren),
        .i_rs1_addr       (instruct[19:15]), 
        .i_rs2_addr       (instruct[24:20]), 
        .i_rd_addr        (instruct[11:7]),
        .i_rd_data        (wb_data), 
        // Output 
        .o_rs1_data       (rs1_data), 
        .o_rs2_data       (rs2_data)
    ); 

    // Immediate value
    imme immediate (
        .i_instruction    (instruct), 
        .o_imme_value     (immediate_value)
    ); 

/*****************************************Execution stage ***************************************/
    // branch signal calculation
    brc branch_signal(
        // Input
        .i_br_uns         (br_un), 
        .i_operand_a      (rs1_data), 
        .i_operand_b      (rs2_data), 
        // Output 
        .o_br_equal       (br_equal), 
        .o_br_less        (br_less)
    ); 

    // Update operand value
    always_comb begin
        operand_a = (opa_sel) ? pc_cur : rs1_data; 
        operand_b = (opb_sel) ? immediate_value : rs2_data; 
    end

    // alu
    alu execution(
        // Input 
        .i_operand_a      (operand_a), 
        .i_operand_b      (operand_b), 
        // Output
        .i_alu_op         (alu_op), 
        .o_alu_data       (alu_data)
    ); 

    // branch address  
    assign pc_br = alu_data;   

/*****************************************Memory stage ***************************************/
    // lsu block
    lsu load_store_unit(
        // Input
        .i_clk         (i_clk), 
        .i_rst         (!i_rst),  
        .i_st_rewrite  (st_rewrite_sel), 
        .i_lsu_addr    (alu_data),  
        .i_st_data     (rs2_data), 
        .i_io_sw       (i_io_sw[17:0]), 
        .i_io_btn      (i_io_btn), 
        .i_mem_wren    (mem_wren), 
        .i_rden        (rden), 
        
        // Output sram
        .o_sram_state  (o_sram_state),
        .o_ack         (pc_stall),
        .o_sram_addr   (o_sram_addr), 
        .o_sram_dq     (o_sram_dq), 
        .o_ce          (o_ce), 
        .o_we          (o_we), 
        .o_ub          (o_ub), 
        .o_lb          (o_lb), 
        .o_oe          (o_oe), 

        // Output io
        .o_io_ledr     (o_io_ledr), 
        .o_io_ledg     (o_io_ledg), 
        .o_hex_data_1  (hex_data_1), 
        .o_hex_data_2  (hex_data_2), 
        .o_io_lcd      (o_io_lcd),  
        .o_ld_data     (ld_data)
    ); 

    // rewrite ld data (for LBU, LHU, LB, LH)
    ld_data_rewrite ld_rewrite(
        // Input 
        .i_segment_lsu_addr (alu_data[1:0]), 
        .i_rewrite_sel      (ld_rewrite_sel),
        // Output  
        .i_ld_data          (ld_data),
        .o_new_ld_data      (new_ld_data)
    );

    // Update hex
    assign o_io_hex0 =  hex_data_1[6:0];
    assign o_io_hex1 =  hex_data_1[14:8];
    assign o_io_hex2 =  hex_data_1[22:16];
    assign o_io_hex3 =  hex_data_1[30:24];
    assign o_io_hex4 =  hex_data_2[6:0];
    assign o_io_hex5 =  hex_data_2[14:8];
    assign o_io_hex6 =  hex_data_2[22:16];
    assign o_io_hex7 =  hex_data_2[30:24];
        
/*****************************************Write back stage ***************************************/
    // Choose write back data
    always_comb begin
        case (wb_sel)
        2'd0: wb_data = pc_four;
        2'd1: wb_data = alu_data; 
        2'd2: wb_data = new_ld_data;   
            default: wb_data = 32'd0; 
        endcase
    end

/*****************************************Debug signal ***************************************/
    // Debug signal
    always_ff @( posedge i_clk ) begin
        o_pc_debug <= pc_cur; 
        o_insn_vld <= insn_vld; 
    end
endmodule 