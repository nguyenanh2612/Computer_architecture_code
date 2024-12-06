module fetch_stage (
    // Clock and  Reset
    input logic i_clk, i_rst, 
    // Input
    input logic i_pc_sel, i_pc_enable,  i_pc_sel_re,
    input logic [31:0] i_pc_br,
    // Output 
    output logic o_prediction, 
    output logic [31:0] o_pc_cur, o_pc_four, 
    output logic [31:0] o_instruct  
);
/********************************************* Immediate signals *********************************************/
    logic [31:0] pc_cur, pc_four, pc_next; 
    logic prediction; 

/*********************************************     PC            *********************************************/
    // pc_next selectiom
    assign pc_next = ((prediction & ~i_pc_sel_re) | i_pc_sel_re) ? i_pc_br : pc_four; 
    // Program counter
    pc program_counter(
        // Input
       .i_clk, 
       .i_rst, 
       .i_pc_enable, 
        // Output 
       .i_pc (pc_next), 
       .o_pc (pc_cur)
    ); 
    // PC increase by 4
    assign pc_four = pc_cur + 32'd4; 

/********************************************* Instruction memory *********************************************/
    ins_mem instruction_memory(
        .i_address (pc_cur>>2), 
        .o_data    (o_instruct)
    );

/********************************************* Branch prediction *********************************************/
    branch_prediction BRP(
       // CLock and reset
       .i_clk, 
       .i_rst, 
       // Input
       .i_actual_branch_taken (i_pc_sel),
       // Output
       .o_prediction          (prediction)
    ); 
/********************************************* Instane output ************************************************/
    assign o_pc_cur = pc_cur; 
    assign o_pc_four = pc_four; 
    assign o_prediction = prediction; 
endmodule