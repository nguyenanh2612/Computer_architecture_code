module pc (
    // Input 
    input logic i_clk, i_pc_enable, i_rst,
    input logic [31:0] i_pc, 
    // Output
    output logic [31:0] o_pc
);
    
    /*Update new output at each positive edge clock*/
    always_ff @( posedge i_clk or posedge i_rst) begin 
        if (i_rst) begin
            o_pc <= 0; 
        end else begin
            if (!i_pc_enable) begin
                o_pc <= o_pc;
            end else begin
                o_pc <= i_pc; 
            end

        end
    end
    
endmodule 