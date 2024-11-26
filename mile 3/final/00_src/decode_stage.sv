module decode_stage (
    // Clock and reset
    input logic i_clk, i_rst, 
    // Input 
    input logic i_rd_wren,
    input logic [4:0] i_rd_addr,  
    input logic [31:0] i_instruct, 
    input logic [31:0] i_rd_data,
    // Output 
    output logic [4:0] o_rs1_addr, o_rs2_addr, o_rd_addr, 
    output logic [31:0] o_rs1_data, o_rs2_data, 
    output logic [31:0] o_imme_value  
);
/***************************************** Immediate signals *******************************************/

/***************************************** Regster file ************************************************/
    regfile register_file(
      // Clock and reset
      .i_clk, 
      .i_rst,
      // Input
      .i_rd_wren, 
      .i_rs1_addr (i_instruct[19:15]), 
      .i_rs2_addr (i_instruct[24:20]),

      .i_rd_addr, 
      .i_rd_data, 
      // Output 
      .o_rs1_data, 
      .o_rs2_data
    );
/***************************************** Immediate generator ************************************************/
    imme immediate_generator(
       // Input
       .i_instruction (i_instruct), 
       // Output
       .o_imme_value
    );
/***************************************** Instante output ************************************************/
    assign o_rs1_addr = i_instruct[19:15]; 
    assign o_rs2_addr = i_instruct[24:20]; 
    assign o_rd_addr  = i_instruct[11:7]; 
endmodule