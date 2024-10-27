module single_cycle (
    input logic i_clk, i_rst_n,
    input logic [31:0] i_io_sw, 
    //input logic [3:0] i_io_btn, 

    output logic o_insn_vld, o_tes_br_less, o_test_br_equal, o_test_pc_sel, o_test_pc_stall,  o_test_mem_wren, 
    output logic [31:0] o_pc_debug,   o_test_ld_data, o_test_rs1, o_test_rs2, o_test_pc_next, 
    output logic [31:0] o_io_ledr, o_io_ledg, 
    output logic [31:0] o_test_instruct, o_test_pc_four, o_test_alu_data, o_test_wb_data
   // output logic [6:0] o_io_hex [6:0], 
   // output logic [31:0] o_io_lcd
);
    // pc + mux for pc signal
    logic pc_sel, pc_stall, stall_flag; 
    logic [31:0] pc_next, pc, pc_four; 
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
    logic new_mem_wren, st_data_sel; 
    logic [31:0] ld_data; 
    logic [31:0] new_ld_data, new_st_data,new_st_data_sw_or_new; 

    // control unit signal
    logic insn_vld; 
    logic br_un, br_less, br_equal; 
    logic mem_wren; 
    logic [1:0] st_sel; 
    logic [2:0] ld_sel; 

    initial begin
        pc_four = 32'd0; 
        pc_next = 32'd0; 
        pc = 32'd0;
    end

    // Update pc next 
    always_comb begin
        pc_next = (pc_sel) ? pc_br : pc_four;
    end

    // Update pc at each positive clock
    pc program_counter(
        .i_clk, 
        .i_pc_stall (pc_stall),
        .i_pc (pc_next), 
        .o_pc (pc)
    );

    // Increasing pc by 4 
    assign pc_four = pc + 4; 

    // Load the instruction
    ins_mem instruction_memory(
        .i_address ({2'd0,pc[31:2]}), 
        .o_data (instruct)
    ); 

    // Stall signal
    assign pc_stall = (instruct[6:0] == 7'b0000011) | (instruct[6:0] == 7'b0100011);

    // Control unit 
    ctrl_unit control_unit(
        .i_instruction (instruct), 
        .i_br_less (br_less), 
        .i_br_equal (br_equal), 
        .o_opa_sel (opa_sel), 
        .o_opb_sel (opb_sel), 
        .o_pc_sel (pc_sel), 
        .o_wb_sel (wb_sel), 
        .o_st_sel (st_sel), 
        .o_ld_sel (ld_sel),
        .o_alu_op (alu_op), 
        .o_mem_wren (mem_wren),
        .o_rd_wren (rd_wren), 
        .o_br_uns (br_un), 
        .o_insn_vld (insn_vld)
    );
	 

    // Load + write data to register file
    regfile register_file(
        .i_clk,
        .i_rst (i_rst_n), 
        .i_rd_wren (rd_wren),
        .i_rs1_addr (instruct[19:15]), 
        .i_rs2_addr (instruct[24:20]), 
        .i_rd_addr (instruct[11:7]),
        .i_rd_data (wb_data), 
        .o_rs1_data (rs1_data), 
        .o_rs2_data (rs2_data)
    ); 

    // Immediate value
    imme immediate (
        .i_instruction (instruct), 
        .o_imme_value (immediate_value)
    ); 

    // branch signal calculation
    bru branch_signal(
        .i_br_uns (br_un), 
        .i_operand_a (rs1_data), 
        .i_operand_b (rs2_data), 
        .o_br_equal (br_equal), 
        .o_br_less (br_less)
    ); 

    // Update operand value
    always_comb begin
        operand_a = (opa_sel) ? pc : rs1_data; 
        operand_b = (opb_sel) ? immediate_value : rs2_data; 
    end

    // alu
    alu execution(
        .i_operand_a (operand_a), 
        .i_operand_b (operand_b), 
        .i_alu_op (alu_op), 
        .o_alu_data (alu_data)
    ); 

    // branch address  
    assign pc_br = alu_data;   

    // st data rewrite
    st_data_rewrite new_st(
        .i_lsu_addr_segment (alu_data[1:0]), 
        .i_st_type (st_sel), 
        .i_ld_data (ld_data), 
        .i_st_data (rs2_data), 
        .o_st_new_data (new_st_data)
    );

    // st data sel 
    wren_with_mm choose_data_and_mapping(
        .i_mem_wren (mem_wren), 
        .i_lsu_addr (alu_data), 
        .o_mem_wren (new_mem_wren), 
        .o_st_data_sel (st_data_sel)
    );

    assign new_st_data_sw_or_new = (st_data_sel) ? i_io_sw : new_st_data; 

    // lsu block
    lsu load_store_unit(
        .i_clk, 
        .i_rst (i_rst_n), 
        .i_st_type (3'd0), 
        .i_lsu_addr (alu_data), 
        .i_st_data (new_st_data_sw_or_new), 
        .i_lsu_wren (new_mem_wren), 
        .o_io_ledr, 
        .o_io_ledg, 
        .o_ld_data (ld_data)
    ); 

    // Rewrite data
    ld_data_rewrite new_ld (
        .i_segment_lsu_addr (alu_data[1:0]), 
        .i_rewrite_sel (ld_sel), 
        .i_ld_data (ld_data),
        .o_new_ld_data (new_ld_data)
    ); 

    // Choose write back data
    always_comb begin
        case (wb_sel)
        2'd0: wb_data = pc_four;
        2'd1: wb_data = alu_data; 
        2'd2: wb_data = new_ld_data;   
            default: wb_data = 32'd0; 
        endcase
    end
    
    // Debug signal
    always_ff @( posedge i_clk ) begin
        o_pc_debug <= pc; 
        o_insn_vld <= insn_vld; 
    end
	 
	 // Test signals
    assign o_test_instruct = instruct; 
    assign o_test_pc_four = pc_four; 
    assign o_test_alu_data = alu_data; 
    assign o_tes_br_less = br_less; 
    assign o_test_br_equal = br_equal; 
    assign o_test_pc_sel = pc_sel; 
    assign o_test_wb_data = wb_data; 
    assign o_test_pc_stall = pc_stall;
    assign o_test_ld_data = new_ld_data; 
    assign o_test_mem_wren = new_mem_wren; 
    assign o_test_rs1 = rs1_data; 
    assign o_test_rs2 = rs2_data; 
    assign o_test_pc_next = pc_next; 
endmodule 