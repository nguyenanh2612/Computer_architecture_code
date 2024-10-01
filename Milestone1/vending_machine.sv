module vending_machine (
    input logic clk_i, 
    input logic nickel_i, dime_i, quarter_i, 
    output logic soda_o, 
    output logic [2:0] change_o
);

    logic [1:0] add_mux; 
    logic [5:0] operand1, total_amount_d, total_amount1_d; 
    
    // FSM instantiation
    FSM_control fsm (
        .clk_i,
        .rst_ni (1'b1),
        .nickel_i, 
        .dime_i, 
        .quarter_i, 
        .add_mux_o  (add_mux) 
    ); 
    
    // Operand selection based on coin input
    always_comb begin
        case (add_mux)
            2'b00: operand1 = 6'd5;     // Nickel
            2'b01: operand1 = 6'd10;    // Dime
            2'b10: operand1 = 6'd25;    // Quarter
            2'b11: operand1 = 6'd0;     // No coin
        endcase
    end
    
    // Sequential logic to accumulate total amount
    always_ff @(posedge clk_i) begin
        if (soda_o) begin
            total_amount1_d <= 6'd0;  // Reset total amount if soda is dispensed
        end
        else begin
            total_amount1_d <= total_amount_d;  // Update total amount
        end
    end

    // Combinational logic to calculate the new total amount
    assign total_amount_d = operand1 + total_amount1_d;

    // Change calculation
    always_comb begin
        if (total_amount_d >= 6'd20) begin
            soda_o = 1'b1;  // Dispense soda
            // Calculate change
            case (total_amount_d - 6'd20)
                5'd5: change_o = 3'b001;   // 5 cents change
                5'd10: change_o = 3'b010;  // 10 cents change
                5'd15: change_o = 3'b011;  // 15 cents change
                5'd20: change_o = 3'b100;  // 20 cents change
                default: change_o = 3'b000;  // No change
            endcase
        end
        else begin
            soda_o = 1'b0;  // No soda dispensed
            change_o = 3'b000;  // No change
        end
    end


endmodule 