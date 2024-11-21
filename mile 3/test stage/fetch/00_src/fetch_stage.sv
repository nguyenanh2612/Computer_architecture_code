module fetch_stage (
    // Clock and  Reset
    input logic i_clk, i_rst, 
    // Input
    input logic i_pc_sel, i_pc_stall,
    input logic [31:0] i_pc_br,
    // Output 
    output logic [31:0] o_pc_cur, o_instruct  
);
/********************************************* Immediate signals *********************************************/
    logic [31:0] pc_cur, pc_four, pc_next; 
/*********************************************     PC            *********************************************/
    // pc_next selectiom
    assign pc_next = (i_pc_sel) ? i_pc_br : pc_four; 
    // Program counter
    pc program_counter(
        // Input
       .i_clk, 
       .i_rst, 
       .i_pc_stall, 
        // Output 
       .i_pc (pc_next), 
       .o_pc (pc_cur)
    ); 
    // PC increase by 4
    assign pc_four = pc_cur + 32'd4; 
/********************************************* Instruction memory *********************************************/
    ins_mem instruction_memory(
        .i_address (pc_cur>>2), 
        .o_data (o_instruct)
    );
/********************************************* Instane output ************************************************/
    assign o_pc_cur = pc_cur; 
endmodule