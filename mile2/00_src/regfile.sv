module regfile (
    input logic i_clk, i_rst, i_rd_wren,
    input logic [4:0] i_rs1_addr, i_rs2_addr, 
    input logic [4:0] i_rd_addr, 
    input logic [31:0] i_rd_data, 
    output logic [31:0] o_rs1_data, o_rs2_data
);
    
    logic [31:0] register [0:31]; 

    assign o_rs1_data = register[i_rs1_addr]; 
    assign o_rs2_data = register[i_rs2_addr]; 

    always_ff @( posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            register = '{default: 32'd0}; 
        end else begin
            if (i_rd_wren & !(i_rd_addr == 5'd0)) begin
                register[i_rd_addr] <= i_rd_data; 
            end else begin
                register[i_rd_addr] <= register[i_rd_addr]; 
            end
        end
    end
endmodule 