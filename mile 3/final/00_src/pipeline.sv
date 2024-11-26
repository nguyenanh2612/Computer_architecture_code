module pipeline (
    // Clock and reset
    input logic i_clk, i_rst,
    // Input 
    // Output
    output logic [1:0] o_fw_a, o_fw_b,
    output logic [4:0] o_rs1_addr, o_rs2_addr, o_mem_rd_addr, o_wb_rd_addr,
    output logic [31:0] o_instruct, o_alu_data,  
    output logic [31:0] o_wb_data
);
/************************************************** Immediate signals **************************************/ 
    // Fetch's output signals
    logic if_id_enable; 
    logic [31:0] if_instruct; 
    logic [31:0] if_pc_four; 
    logic [31:0] if_pc_cur;  
    
    // Decode's output signals 
    logic pc_enable; 
    logic [4:0] id_rs1_addr, id_rs2_addr, id_rd_addr; 
    logic [31:0] id_instruct;
    logic [31:0] id_pc_four; 
    logic [31:0] id_pc_cur; 
    logic [31:0] id_rs1_data, id_rs2_data; 
    logic [31:0] id_imme_value; 
    // Ctrl's output signals
    // EX register
    logic id_imme_sel; 
    logic id_br_unsigned;
    logic [3:0] id_alu_op; 
    // MEM register
    logic id_pc_sel;
    logic id_mem_rden, id_mem_wren; 
    logic [1:0] id_st_rewrite; 
    // WB register
    logic id_rd_wren; 
    logic [2:0] id_ld_rewrite; 
    logic [1:0] id_wb_sel;

    // Execute's output signals 
    // ID_EX register
    logic [4:0] ex_rs1_addr, ex_rs2_addr, ex_rd_addr; 
    logic [31:0] ex_pc_cur; 
    logic [31:0] ex_pc_four; 
    logic [31:0] ex_rs1_data, ex_rs2_data; 
    logic [31:0] ex_imme_value; 

    // EX register
    logic ex_imme_sel; 
    logic ex_br_unsigned;
    logic [3:0] ex_alu_op; 
    // MEM register
    logic ex_pc_sel;
    logic ex_mem_rden, ex_mem_wren; 
    logic [1:0] ex_st_rewrite; 
    // WB register
    logic ex_rd_wren; 
    logic [2:0] ex_ld_rewrite; 
    logic [1:0] ex_wb_sel;

    logic [31:0] ex_alu_data;
    logic [31:0] ex_st_data;
    logic [31:0] ex_pc_br; 
    logic [1:0] ex_fw_a, ex_fw_b; 

    // Mem's output signals 
    // MEM register
    logic mem_pc_sel;
    logic mem_mem_rden, mem_mem_wren; 
    logic [1:0] mem_st_rewrite; 
    // WB register 
    logic mem_rd_wren; 
    logic [2:0] mem_ld_rewrite; 
    logic [1:0] mem_wb_sel;
    
    logic [4:0] mem_rd_addr; 
    logic [31:0] mem_pc_four; 
    logic [31:0] mem_st_data; 
    logic [31:0] mem_alu_data; 
    logic [31:0] mem_ld_data; 

    // WB's output signals 
    // WB register 
    logic wb_rd_wren; 
    logic [1:0] wb_wb_sel; 
    logic [2:0] wb_ld_rewrite; 

    // MEM-WB register
    logic [4:0] wb_rd_addr; 
    logic [31:0] wb_pc_four; 
    logic [31:0] wb_ld_data; 
    logic [31:0] wb_alu_data; 
    logic [31:0] wb_wb_data; 

/************************************************** Fetch stage  *******************************************/
    fetch_stage IF(
       // Clock and reset 
       .i_clk, 
       .i_rst, 
       // Input 
       .i_pc_sel       (mem_pc_sel), 
       .i_pc_enable    (pc_enable), 
       .i_pc_br        (ex_alu_data), 
       // Output
       .o_pc_cur       (if_pc_cur), 
       .o_pc_four      (if_pc_four),
       .o_instruct     (if_instruct)
    ); 
/************************************************** IF-ID register  ******************************/
    always_ff @( negedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            id_instruct <= 32'd0; 
            id_pc_four <= 32'd0; 
            id_pc_cur <= 32'd0; 
        end else begin
            if (if_id_enable) begin
                id_instruct <= if_instruct; 
                id_pc_four <= if_pc_four; 
                id_pc_cur <= if_pc_cur;    
            end else begin
                id_instruct <= id_instruct; 
                id_pc_four <= id_pc_four; 
                id_pc_cur <= id_pc_cur;
            end 
        end 
    end
/************************************************** Decode stage  *******************************************/
    decode_stage ID(
       // CLock and reset 
       .i_clk, 
       .i_rst, 
       // Input
       .i_rd_wren        (wb_rd_wren), 
       .i_rd_addr        (wb_rd_addr),
       .i_instruct       (id_instruct), 
       .i_rd_data        (wb_wb_data), 
       // Output
       .o_rs1_addr       (id_rs1_addr),
       .o_rs2_addr       (id_rs2_addr), 
       .o_rd_addr        (id_rd_addr), 
       .o_rs1_data       (id_rs1_data), 
       .o_rs2_data       (id_rs2_data),      
       .o_imme_value     (id_imme_value), 
    ); 
/************************************************** Control unit  *******************************************/
    ctrl_unit Control_unit(
       // Input
       .i_instruct          (id_instruct), 
       // Ouput
       .o_pc_sel            (id_pc_sel), 
       .o_rd_wren           (id_rd_wren), 
       .o_mem_rden          (id_mem_rden), 
       .o_mem_wren          (id_mem_wren), 
       .o_br_unsigned       (id_br_unsigned), 
       .o_insn_vld          (id_insn_vld), 
       .o_imme_sel          (id_imme_sel),
       .o_alu_op            (id_alu_op), 
       .o_ld_rewrite        (id_ld_rewrite), 
       .o_st_rewrite        (id_st_rewrite),
       .o_wb_sel            (id_wb_sel)
    );
/************************************************** Harzard detection  *******************************************/
    harzard_dection HD(
       // Input 
       .i_id_rs1                      (id_rs1_addr), 
       .i_id_rs2                      (id_rs2_addr), 
       .i_id_rd                       (id_rd_addr), 
       .i_ex_rd                       (ex_rd_addr), 
       .i_ex_read                     (ex_mem_rden),
       // Output 
       .o_pc_enable                   (pc_enable), 
       .o_if_id_register_enable       (if_id_enable), 
    );
/************************************************** ID to EX register  *******************************************/
    // EX register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_imme_sel <= 1'b0; 
            ex_br_unsigned <= 1'b0; 
            ex_alu_op <= 4'd11;
        end else begin
            ex_imme_sel <= id_imme_sel; 
            ex_br_unsigned <= id_br_unsigned;
            ex_alu_op <= id_alu_op;
        end
    end
    // MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_pc_sel <= 1'b0; 
            ex_mem_rden <= 1'b0;
            ex_mem_wren <= 1'b0;  
            ex_st_rewrite <= 2'd3; 
        end else begin
            ex_pc_sel <= id_pc_sel; 
            ex_mem_rden <= id_mem_rden;
            ex_mem_wren <= id_mem_wren;  
            ex_st_rewrite <= id_st_rewrite; 
        end
    end
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_rd_wren <= 1'b0; 
            ex_ld_rewrite <= 3'd5; 
            ex_wb_sel <= 2'd3; 
        end else begin
            ex_rd_wren <= id_rd_wren; 
            ex_ld_rewrite <= id_ld_rewrite; 
            ex_wb_sel <= id_wb_sel; 
        end
    end
    // ID to EX register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_rs1_addr <= 5'd0; 
            ex_rs2_addr <= 5'd0; 
            ex_rd_addr <= 5'd0;
            ex_pc_four <= 32'd0; 
            ex_pc_cur <= 32'd0; 
            ex_rs1_data <= 32'd0; 
            ex_rs2_data <= 32'd0; 
            ex_imme_value <= 32'd0; 
        end else begin
            ex_rs1_addr <= id_rs1_addr; 
            ex_rs2_addr <= id_rs2_addr; 
            ex_rd_addr <= id_rd_addr; 
            ex_pc_four <= id_pc_four; 
            ex_pc_cur <= id_pc_cur; 
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data; 
            ex_imme_value <= id_imme_value; 
        end
    end
/**************************************************** Execute stage *******************************************/ 
    execute_stage EX(
       // Input 
       // Data
       .i_pc_cur              (ex_pc_cur), 
       .i_rs1_data            (ex_rs1_data),  
       .i_rs2_data            (ex_rs2_data), 
       .i_imme_value          (ex_imme_value), 
       .i_wb_forwarding       (wb_wb_data), 
       .i_mem_forwarding      (mem_alu_data), 
       // Control
       .i_alu_op              (ex_alu_op), 
       .i_forward_A           (ex_fw_a), 
       .i_forward_B           (ex_fw_b), 
       .i_imme_sel            (ex_imme_sel),
       // Output  
       .o_alu_data            (ex_alu_data), 
       .o_operand_b           (ex_st_data), 
       .o_pc_br               (ex_pc_br) 
    ); 

    forwarding_control FW(
       // Input 
       .i_rd_wren_mem         (mem_rd_wren), 
       .i_rd_wren_wb          (wb_rd_wren),
       .i_rs1_addr            (ex_rs1_addr),
       .i_rs2_addr            (ex_rs2_addr), 
       .i_mem_rd_addr         (mem_rd_addr), 
       .i_wb_rd_addr          (wb_rd_addr), 
       // Output 
       .o_forwarding_a        (ex_fw_a), 
       .o_forwarding_b        (ex_fw_b) 
    );
/**************************************************** EX to MEM register *******************************************/ 
    // MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_mem_rden <= 1'b0; 
            mem_mem_wren <= 1'b0; 
            mem_st_rewrite <= 2'd3; 
            mem_pc_sel <= 1'b0; 
        end else begin
            mem_mem_rden <= ex_mem_rden; 
            mem_mem_wren <= ex_mem_wren; 
            mem_st_rewrite <= ex_st_rewrite; 
            mem_pc_sel <= ex_pc_sel; 
        end
    end
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_rd_wren <= 1'b0; 
            mem_ld_rewrite <= 3'd5; 
            mem_wb_sel <= 2'd3; 
        end else begin
            mem_rd_wren <= ex_rd_wren; 
            mem_ld_rewrite <= ex_ld_rewrite; 
            mem_wb_sel <= ex_wb_sel; 
        end
    end
    // EX-MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_rd_addr <= 5'd0; 
            mem_alu_data <= 32'd0; 
            mem_st_data <= 32'd0;
            mem_pc_four <= 32'd0; 
        end else begin
            mem_rd_addr <= ex_rd_addr; 
            mem_alu_data <= ex_alu_data; 
            mem_st_data <= ex_st_data; 
            mem_pc_four <= ex_pc_four; 
        end
    end
/****************************************************  MEM stage *******************************************/ 
/****************************************************  MEM-WB register *******************************************/ 
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin 
            wb_rd_wren <= 1'b0;
            wb_ld_rewrite <= 3'd5; 
            wb_wb_sel <= 2'd3; 
        end else begin
            wb_rd_wren <= mem_rd_wren; 
            wb_ld_rewrite <= mem_ld_rewrite; 
            wb_wb_sel <= mem_wb_sel; 
        end
    end
    // MEM-WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            wb_rd_addr <= 5'd0;
            wb_alu_data <= 32'd0; 
            wb_ld_data <= 32'd0; 
            wb_pc_four <= 32'd0; 
        end else begin
            wb_rd_addr <= mem_rd_addr; 
            wb_alu_data <= mem_alu_data; 
            wb_ld_data <= mem_ld_data; 
            wb_pc_four <= mem_pc_four; 
        end
    end
/****************************************************  Write back stage *******************************************/ 
    wb_stage WB(
       // Input 
       .i_wb_sel           (wb_wb_sel), 
       .i_ld_rewrite       (wb_ld_rewrite),  
       .i_pc_four          (wb_pc_four), 
       .i_alu_data         (wb_alu_data), 
       .i_ld_data          (wb_ld_data), 
       // Output 
       .o_wb_data          (wb_wb_data)
    );
/**************************************************** Instante output *******************************************/ 
    assign o_wb_data = wb_wb_data;
    assign o_alu_data = ex_alu_data; 
    assign o_instruct = id_instruct; 
    assign o_fw_a = ex_fw_a; 
    assign o_fw_b = ex_fw_b; 
    assign o_rs1_addr = ex_rs1_addr; 
    assign o_rs2_addr = ex_rs2_addr; 
    assign o_mem_rd_addr = mem_rd_addr; 
    assign o_wb_rd_addr = wb_rd_addr; 
endmodule