module mux_2_inputs (
    input logic [31:0] operand1_i, operand2_i, 
    input logic sel_i, 
    output logic [31:0] mux_o
);
    always_comb begin
        if (sel_i)
            mux_o = operand2_i; 
        else 
            mux_o = operand1_i; 
    end
endmodule 