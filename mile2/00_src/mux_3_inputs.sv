module mux_3_inputs (
    input logic [31:0] operand1_i, operand2_i, operand3_i,
    input logic [1:0] sel_i, 
    output logic [31:0] mux_o
);
    always_comb begin
        case (sel_i)
        2'd0: mux_o = operand1_i;
        2'd1: mux_o = operand2_i; 
        2'd2: mux_o = operand3_i;
            default: mux_o = 32'd0; 
        endcase
    end
endmodule 