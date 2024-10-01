module FSM_control (
    input logic clk_i, rst_ni,  
    input logic nickel_i, dime_i,quarter_i, 
    output logic [1:0] add_mux_o
);
    typedef enum bit [1:0] { Idle, Nickel, Dime, Quarter} state_e;
    state_e state, next; 

    always_ff @( posedge clk_i or negedge rst_ni ) begin
        if (~rst_ni)
            state <= Idle; 
        else 
            state <= next; 
    end

    always_comb begin  

        if (~nickel_i & ~dime_i & ~quarter_i) begin
            next = Idle;
        end 
        else begin
            next = state;
        end

        case (state)
        Idle: begin
            if(nickel_i)
                next = Nickel; 
            else if (dime_i)
                next = Dime; 
            else if (quarter_i)
                next = Quarter; 
        end
        
        Nickel: begin
            if(nickel_i)
                next = Nickel; 
            else if (dime_i)
                next = Dime; 
            else if (quarter_i)
                next = Quarter; 
            else 
                next = Idle;
        end

        Dime: begin
            if(nickel_i)
                next = Nickel; 
            else if (dime_i)
                next = Dime; 
            else if (quarter_i)
                next = Quarter; 
        end

        Quarter: begin
            if(nickel_i)
                next = Nickel; 
            else if (dime_i)
                next = Dime; 
            else if (quarter_i)
                next = Quarter; 
        end
        endcase
    end

    always_comb begin
        case (next)
        Nickel: add_mux_o = 2'b00; 
        Dime: add_mux_o = 2'b01; 
        Quarter: add_mux_o = 2'b10;  
            default: add_mux_o = 2'b11; 
        endcase  
    end 

endmodule 