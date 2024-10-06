module FSM_control (
    input logic i_clk, ni_rst,  
    input logic i_nickle, i_dime, i_quarter, 
    output logic [1:0] o_add_mux
);
    typedef enum bit [1:0] { Idle, Nickel, Dime, Quarter} state_e;
    state_e state, next; 

    always_ff @( posedge i_clk or negedge ni_rst ) begin
        if (~ni_rst)
            state <= Idle; 
        else 
            state <= next; 
    end

    always_comb begin  
        if (~i_nickle & ~i_dime & ~ i_quarter) begin
            next = Idle;
        end else begin
            next = state;
        end

        case (state)
        Idle: begin
            if(i_nickle)
                next = Nickel; 
            else if (i_dime)
                next = Dime; 
            else if ( i_quarter)
                next = Quarter; 
        end
        
        Nickel: begin
            if(i_nickle) 
                next = Nickel; 
            else if (i_dime)
                next = Dime; 
            else if ( i_quarter)
                next = Quarter; 
            else 
                next = Idle;
        end

        Dime: begin
            if(i_nickle)
                next = Nickel; 
            else if (i_dime)
                next = Dime; 
            else if ( i_quarter)
                next = Quarter; 
        end

        Quarter: begin
            if(i_nickle)
                next = Nickel; 
            else if (i_dime)
                next = Dime; 
            else if ( i_quarter)
                next = Quarter; 
        end
        endcase
    end

    always_comb begin
        case (state)
        Nickel: o_add_mux = 2'b00; 
        Dime: o_add_mux = 2'b01; 
        Quarter: o_add_mux = 2'b10;  
            default: o_add_mux = 2'b11; 
        endcase  
    end 

endmodule 