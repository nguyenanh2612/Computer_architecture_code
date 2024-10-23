module pc (
    input logic i_clk, i_pc_stall, 
    input logic [31:0] i_pc, 
    output logic [31:0] o_pc
);
    
    logic stall_count;
    /*Update new output at each positive edge clock*/
    always_ff @( posedge i_clk ) begin 
        if (i_pc_stall) begin
            stall_count = stall_count + 1;
            if (stall_count) begin
                o_pc <= o_pc;
            end else begin
                o_pc <= i_pc;
            end  
        end else begin
            stall_count = 0; 
            o_pc <= i_pc; 
        end 
    end
    
endmodule 