module pipeline (
    // Clock and reset
    input logic i_clk, i_rst,
    // Input 
    input logic [31:0] i_io_sw, 
    input logic [3:0] i_io_btn, 
    // Test 
    output logic [31:0] o_wb_dt, o_al_dt, o_st_data, 
    output logic [1:0]  o_fw_a, o_fw_b, 
    output logic o_brc, 
    // Output
    output logic [31:0] o_io_ledr, o_io_ledg, o_pc_debug,
    output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7, 
    output logic [31:0] o_io_lcd
);
/************************************************** Immediate signals **************************************/ 
    // Fetch's output signals
    logic if_id_enable; 
    logic if_prediction; 
    logic [31:0] if_instruct; 
    logic [31:0] if_pc_four; 
    logic [31:0] if_pc_cur;  
    
    // Decode's output signals 
    logic pc_enable; 
    logic id_prediction; 
    logic id_enable; 
    logic [4:0] id_rs1_addr, id_rs2_addr, id_rd_addr; 
    logic [31:0] id_instruct;
    logic [31:0] id_pc_four; 
    logic [31:0] id_pc_cur; 
    logic [31:0] id_rs1_data, id_rs2_data; 
    logic [31:0] id_imme_value; 

    // IO
    logic [3:0] id_io_btn; 
    logic [31:0] id_io_sw; 
    
    // Ctrl's output signals
    // EX register
    logic id_imme_sel, id_rs1_sel; 
    logic id_br_unsigned;
    logic id_jalr_iden; 
    logic [2:0] id_br_type; 
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

    // IO
    logic [3:0]  ex_io_btn; 
    logic [31:0] ex_io_sw; 

    // EX register
    logic ex_imme_sel, ex_rs1_sel; 
    logic ex_br_unsigned;
    logic ex_prediction; 
    logic ex_pc_re; 
    logic ex_jalr_iden; 
    logic [2:0] ex_br_type; 
    logic [3:0] ex_alu_op; 
    
    // MEM register
    logic ex_pc_sel;
    logic ex_mem_rden, ex_mem_wren; 
    logic [1:0] ex_st_rewrite; 
    
    // WB register
    logic ex_rd_wren; 
    logic [2:0] ex_ld_rewrite; 
    logic [1:0] ex_wb_sel;
    
    // ID-EX register 
    logic [31:0] ex_pc_br_re, ex_pc_br; 
    logic [31:0] ex_alu_data;
    logic [31:0] ex_st_data;
    logic [1:0] ex_fw_a, ex_fw_b; 
    logic ex_brc_pc_sel; 

    // Mem's output signals 
    // MEM register
    logic mem_mem_rden, mem_mem_wren; 
    logic [1:0] mem_st_rewrite; 
    
    // WB register 
    logic mem_rd_wren; 
    logic [2:0] mem_ld_rewrite; 
    logic [1:0] mem_wb_sel;
    
    // BRP
    // logic mem_pc_sel, mem_brc_pc_sel; 
    // logic mem_id_enable; 
    // logic mem_pc_re; 
    // logic [31:0] mem_pc_br_re; 
    
    // EX-MEM register
    logic [4:0] mem_rd_addr; 
    logic [31:0] mem_pc_four; 
    logic [31:0] mem_st_data; 
    logic [31:0] mem_alu_data; 
    logic [31:0] mem_ld_data; 

    // IO
    logic [3:0]  mem_io_btn; 
    logic [31:0] mem_io_sw; 
    logic [31:0] mem_hex_data_1, mem_hex_data_2; 

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
       .i_pc_sel       (ex_pc_sel | ex_brc_pc_sel),
       .i_pc_sel_re    (ex_pc_re),  
       .i_pc_enable    (pc_enable), 
       .i_pc_br        (ex_pc_br_re), 
       // Output
       .o_prediction   (if_prediction),
       .o_pc_cur       (if_pc_cur), 
       .o_pc_four      (if_pc_four),
       .o_instruct     (if_instruct)
    ); 
/************************************************** IF-ID register  ******************************/
    always_ff @( negedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            id_prediction <= 1'b0 ; 
            id_io_sw      <= 4'd0 ; 
            id_instruct   <= 32'd0; 
            id_pc_four    <= 32'd0; 
            id_pc_cur     <= 32'd0; 
            id_io_sw      <= 32'd0; 
        end else begin
            if (if_id_enable & id_enable) begin
                id_prediction <= if_prediction; 
                id_io_btn     <= i_io_btn     ; 
                id_instruct   <= if_instruct  ; 
                id_pc_four    <= if_pc_four   ; 
                id_pc_cur     <= if_pc_cur    ;    
                id_io_sw      <= i_io_sw      ; 
            end else begin
                id_prediction <= 1'b0 ; 
                id_io_btn     <= 4'd0 ; 
                id_instruct   <= 32'd0; 
                id_pc_four    <= 32'd0; 
                id_pc_cur     <= 32'd0;
                id_io_sw      <= 32'd0; 
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
       .o_imme_value     (id_imme_value) 
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
       .o_rs1_sel           (id_rs1_sel), 
       .o_jalr_iden         (id_jalr_iden),
       .o_alu_op            (id_alu_op), 
       .o_ld_rewrite        (id_ld_rewrite), 
       .o_br_type           (id_br_type), 
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
       .o_if_id_register_enable       (if_id_enable)
    );
/************************************************** ID to EX register  *******************************************/
    // EX register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_rs1_sel     <= 1'b0 ; 
            ex_imme_sel    <= 1'b0 ; 
            ex_br_unsigned <= 1'b0 ; 
            ex_prediction  <= 1'b0 ; 
            ex_jalr_iden   <= 1'b0 ; 
            ex_br_type     <= 3'd6 ; 
            ex_alu_op      <= 4'd11;
        end else begin
            if (id_enable & if_id_enable) begin
                ex_rs1_sel     <= id_rs1_sel; 
                ex_imme_sel    <= id_imme_sel; 
                ex_br_unsigned <= id_br_unsigned;
                ex_prediction  <= id_prediction; 
                ex_jalr_iden   <= id_jalr_iden; 
                ex_br_type     <= id_br_type;
                ex_alu_op      <= id_alu_op;
            end else begin
                ex_rs1_sel     <= 1'b0 ; //ex_rs1_sel    ;  
                ex_imme_sel    <= 1'b0 ; //ex_imme_sel   ;  
                ex_br_unsigned <= 1'b0 ; //ex_br_unsigned;
                ex_prediction  <= 1'b0 ; //ex_prediction ;  
                ex_jalr_iden   <= 1'b0 ; 
                ex_br_type     <= 3'd6 ; //ex_br_type    ;  
                ex_alu_op      <= 4'd11; //ex_alu_op     ;  
            end
        end 
    end
    // MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_pc_sel     <= 1'b0; 
            ex_mem_rden   <= 1'b0;
            ex_mem_wren   <= 1'b0;  
            ex_st_rewrite <= 2'd3; 
        end else begin
            if (id_enable & if_id_enable) begin
                ex_pc_sel     <= id_pc_sel; 
                ex_mem_rden   <= id_mem_rden;
                ex_mem_wren   <= id_mem_wren;  
                ex_st_rewrite <= id_st_rewrite;
            end else begin
                ex_pc_sel     <= 1'b0; //ex_pc_sel     ;
                ex_mem_rden   <= 1'b0; //ex_mem_rden   ;
                ex_mem_wren   <= 1'b0; //ex_mem_wren   ;
                ex_st_rewrite <= 2'd3; //ex_st_rewrite ;
            end
        end
    end
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_rd_wren    <= 1'b0; 
            ex_ld_rewrite <= 3'd5; 
            ex_wb_sel     <= 2'd3; 
        end else begin
            if (id_enable & if_id_enable) begin
                ex_rd_wren    <= id_rd_wren; 
                ex_ld_rewrite <= id_ld_rewrite; 
                ex_wb_sel     <= id_wb_sel; 
            end else begin
                ex_rd_wren    <= 1'b0; //ex_rd_wren    ; 
                ex_ld_rewrite <= 3'd5; //ex_ld_rewrite ;
                ex_wb_sel     <= 2'd3; //ex_wb_sel     ; 
            end
        end
    end
    // ID to EX register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            ex_io_btn     <= 4'd0 ; 
            ex_rs1_addr   <= 5'd0 ; 
            ex_rs2_addr   <= 5'd0 ; 
            ex_rd_addr    <= 5'd0 ;
            ex_pc_four    <= 32'd0; 
            ex_pc_cur     <= 32'd0; 
            ex_rs1_data   <= 32'd0; 
            ex_rs2_data   <= 32'd0; 
            ex_imme_value <= 32'd0; 
            ex_io_sw      <= 32'd0; 
        end else begin
            if (id_enable & if_id_enable) begin
                ex_io_btn     <= id_io_btn  ;
                ex_rs1_addr   <= id_rs1_addr; 
                ex_rs2_addr   <= id_rs2_addr; 
                ex_rd_addr    <= id_rd_addr; 
                ex_pc_four    <= id_pc_four; 
                ex_pc_cur     <= id_pc_cur; 
                ex_rs1_data   <= id_rs1_data;
                ex_rs2_data   <= id_rs2_data; 
                ex_imme_value <= id_imme_value; 
                ex_io_sw      <= id_io_sw; 
            end else begin
                ex_io_btn     <= 4'd0 ;
                ex_rs1_addr   <= 5'd0 ; //ex_rs1_addr   ;
                ex_rs2_addr   <= 5'd0 ; //ex_rs2_addr   ;
                ex_rd_addr    <= 5'd0 ; //ex_rd_addr    ;
                ex_pc_four    <= 32'd0; //ex_pc_four    ;
                ex_pc_cur     <= 32'd0; //ex_pc_cur     ;
                ex_rs1_data   <= 32'd0; //ex_rs1_data   ;
                ex_rs2_data   <= 32'd0; //ex_rs2_data   ;
                ex_imme_value <= 32'd0; //ex_imme_value ; 
                ex_io_sw      <= 32'd0; 
            end
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
       .i_rs1_sel             (ex_rs1_sel), 
       .i_br_unsigned         (ex_br_unsigned),
       .i_br_type             (ex_br_type), 
       .i_jalr_iden           (ex_jalr_iden), 
       // Output  
       .o_brc_pc_sel          (ex_brc_pc_sel),
       .o_pc_br               (ex_pc_br), 
       .o_alu_data            (ex_alu_data), 
       .o_operand_b           (ex_st_data)
    ); 
    
    // Recheck prediction
    always_comb begin
        if (ex_prediction == (ex_brc_pc_sel | ex_pc_sel)) begin   // Prediction is right
            id_enable = 1'b1;
            ex_pc_br_re = ex_pc_four;	
        end else begin                                            // Prediction is wrong
            id_enable = 1'b0; 
            ex_pc_br_re = (ex_brc_pc_sel | ex_pc_sel) ? ex_pc_br : ex_pc_four;
        end
    end

    assign ex_pc_re = ~id_enable;                              // Choose right address (distiguish prediction or re_choose)

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
    // BRP register
    // always_ff @( posedge i_clk or posedge i_rst ) begin
    //     if (i_rst) begin
    //         mem_pc_sel     <= 1'b0; 
    //         mem_brc_pc_sel <= 1'b0; 
    //         mem_id_enable  <= 1'b0;  
    //         mem_pc_re      <= 1'b0; 
    //         mem_pc_br_re   <= 32'd0; 
    //     end else begin 
    //         mem_pc_sel     <= ex_pc_sel    ; 
    //         mem_brc_pc_sel <= ex_brc_pc_sel;
    //         mem_id_enable  <= id_enable    ; 
    //         mem_pc_re      <= ex_pc_re     ; 
    //         mem_pc_br_re   <= ex_pc_br_re  ;
    //     end
    // end
    // MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_mem_rden   <= 1'b0; 
            mem_mem_wren   <= 1'b0; 
            mem_st_rewrite <= 2'd3;  
        end else begin
            mem_mem_rden   <= ex_mem_rden; 
            mem_mem_wren   <= ex_mem_wren; 
            mem_st_rewrite <= ex_st_rewrite; 
        end
    end 
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_rd_wren    <= 1'b0; 
            mem_ld_rewrite <= 3'd5; 
            mem_wb_sel     <= 2'd3; 
        end else begin
            mem_rd_wren    <= ex_rd_wren; 
            mem_ld_rewrite <= ex_ld_rewrite; 
            mem_wb_sel     <= ex_wb_sel; 
        end
    end
    // EX-MEM register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            mem_io_btn   <= 4'd0; 
            mem_rd_addr  <= 5'd0; 
            mem_alu_data <= 32'd0; 
            mem_st_data  <= 32'd0;
            mem_pc_four  <= 32'd0;
            mem_io_sw    <= 32'd0;  
        end else begin
            mem_io_btn   <= ex_io_btn;
            mem_rd_addr  <= ex_rd_addr; 
            mem_alu_data <= ex_alu_data; 
            mem_st_data  <= ex_st_data; 
            mem_pc_four  <= ex_pc_four; 
            mem_io_sw    <= ex_io_sw; 
        end
    end
/****************************************************  MEM stage *************************************************/ 
    mem_stage MEM(
       // Clock and reset 
       .i_clk, 
       .i_rst, 
       // Input 
       .i_mem_wren     (mem_mem_wren), 
       .i_io_btn       (mem_io_btn),
       .i_st_rewrite   (mem_st_rewrite), 
       .i_alu_data     (mem_alu_data), 
       .i_st_data      (mem_st_data),
       .i_io_sw        (mem_io_sw), 
       // Output
       .o_io_ledr      , 
       .o_io_ledg      , 
       .o_hex_data_1   (mem_hex_data_1), 
       .o_hex_data_2   (mem_hex_data_2), 
       .o_io_lcd       ,
       .o_ld_data      (mem_ld_data)
    ); 

    // Update hex
    assign o_io_hex0 =  mem_hex_data_1[6:0];
    assign o_io_hex1 =  mem_hex_data_1[14:8];
    assign o_io_hex2 =  mem_hex_data_1[22:16];
    assign o_io_hex3 =  mem_hex_data_1[30:24];
    assign o_io_hex4 =  mem_hex_data_2[6:0];
    assign o_io_hex5 =  mem_hex_data_2[14:8];
    assign o_io_hex6 =  mem_hex_data_2[22:16];
    assign o_io_hex7 =  mem_hex_data_2[30:24];
/****************************************************  MEM-WB register *******************************************/ 
    // WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin 
            wb_rd_wren    <= 1'b0;
            wb_ld_rewrite <= 3'd5; 
            wb_wb_sel     <= 2'd3; 
        end else begin
            wb_rd_wren    <= mem_rd_wren; 
            wb_ld_rewrite <= mem_ld_rewrite; 
            wb_wb_sel     <= mem_wb_sel; 
        end
    end
    // MEM-WB register
    always_ff @( posedge i_clk or posedge i_rst ) begin
        if (i_rst) begin
            wb_rd_addr  <= 5'd0;
            wb_alu_data <= 32'd0; 
            wb_ld_data  <= 32'd0; 
            wb_pc_four  <= 32'd0; 
        end else begin
            wb_rd_addr  <= mem_rd_addr; 
            wb_alu_data <= mem_alu_data; 
            wb_ld_data  <= mem_ld_data; 
            wb_pc_four  <= mem_pc_four; 
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
    assign o_pc_debug = ex_pc_cur; 
    assign o_wb_dt    = wb_wb_data; 
    assign o_al_dt    = ex_alu_data; 
    assign o_fw_a     = ex_fw_a; 
    assign o_fw_b     = ex_fw_b; 
    assign o_st_data  = mem_st_data; 
    assign o_brc      = ex_brc_pc_sel; 
endmodule