module pc(
    input logic clk_i,  
    input logic [31:0] next_pc_i, 
    output logic [31:0] pc_o
);    
    always_ff @( posedge clk_i ) begin
        pc_o <= next_pc_i; 
    end
endmodule 