module vending_machine (
    input logic i_clk, 
    input logic i_nickle, i_dime, i_quarter, 
    output logic o_soda, 
    output logic [2:0] o_change
);

    logic [1:0] add_mux; 
    logic [5:0] operand1, total_amount_d, total_amount1_d; 
    
    // FSM instantiation
    FSM_control fsm (
        .i_clk,
		  .ni_rst (1'b1),
        .i_nickle, 
        .i_dime, 
        .i_quarter, 
        .o_add_mux  (add_mux) 
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
    always_ff @(posedge i_clk) begin
        if (o_soda) begin
            total_amount1_d <= 6'd0;  // Reset total amount if soda is dispensed
        end else begin
            total_amount1_d <= total_amount_d;  // Update total amount
        end
    end

    // Combinational logic to calculate the new total amount
    assign total_amount_d = operand1 + total_amount1_d;

    // Change calculation
    always_comb begin
        if (total_amount_d >= 6'd20) begin
            o_soda = 1'b1;  // Dispense soda
            // Calculate change
            case (total_amount_d - 6'd20)
                6'd5: o_change = 3'b001;   // 5 cents change
                6'd10: o_change = 3'b010;  // 10 cents change
                6'd15: o_change = 3'b011;  // 15 cents change
                6'd20: o_change = 3'b100;  // 20 cents change
                default: o_change = 3'b000;  // No change
            endcase
        end else begin
            o_soda = 1'b0;  // No soda dispensed
            o_change = 3'b000;  // No change
        end
    end


endmodule 