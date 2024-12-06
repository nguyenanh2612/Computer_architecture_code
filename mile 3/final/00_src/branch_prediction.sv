module branch_prediction(
    // Clock and reset
    input logic i_clk,
    input logic i_rst,                          // Active-high reset
    // Input
    input logic i_actual_branch_taken,          // Actual branch outcome
    // Output 
    output logic o_prediction                   // Predicted outcome (1: Taken, 0: Not Taken)
);
/******************************************** Immediate signals *********************************************/
    logic [1:0] current_state;                  // Current prediction state for the given PC

/******************************************* Branch history table *******************************************/ 
    // Initialize BHT on reset
    always_ff @(posedge i_clk or posedge i_rst) begin
        if (i_rst) begin
            current_state <=  2'b01; 
        end else begin
            case (current_state)
                2'b00: current_state <= i_actual_branch_taken ? 2'b01 : 2'b00; // Strongly Not Taken
                2'b01: current_state <= i_actual_branch_taken ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: current_state <= i_actual_branch_taken ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: current_state <= i_actual_branch_taken ? 2'b11 : 2'b10; // Strongly Taken
            endcase
        end
    end

/********************************************* Output ******************************************************/ 
    // Output prediction based on current state
    always_comb begin
        o_prediction = (current_state > 2'b01); // Predict Taken if MSB is 1
    end 
endmodule
