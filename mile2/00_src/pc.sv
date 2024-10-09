module PC (
    input logic i_clk, 
    input logic [31:0] i_pc, 
    output logic [31:0] o_pc
);
    
    /*Update new output at each positive edge clock*/
    always_ff @( posedge i_clk ) begin 
        o_pc <= i_pc; 
    end
    
endmodule