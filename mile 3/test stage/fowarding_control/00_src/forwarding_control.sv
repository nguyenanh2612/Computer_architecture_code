module forwarding_control (
	// Input
    input logic i_rd_wren_wb, i_rd_wren_mem, 
    input logic [4:0] i_rs1_addr, i_rs2_addr, i_mem_rd_addr, i_wb_rd_addr,
	// Output
    output logic [1:0] o_forwarding_a, o_forwarding_b
);
	
    assign o_forwarding_a = (i_rd_wren_mem & (i_mem_rd_addr !=0) 
							& (i_mem_rd_addr == i_rs1_addr)) ? 2'b10 
                            : (i_rd_wren_wb & (i_wb_rd_addr != 0) 
							& (i_wb_rd_addr == i_rs1_addr)) ? 2'b01 : 2'b00;

    assign o_forwarding_b = (i_rd_wren_mem & (i_mem_rd_addr !=0) 
							& (i_mem_rd_addr == i_rs2_addr)) ? 2'b10 
                            : (i_rd_wren_wb & (i_wb_rd_addr != 0) 
							& (i_wb_rd_addr == i_rs2_addr)) ? 2'b01 : 2'b00; 

endmodule 