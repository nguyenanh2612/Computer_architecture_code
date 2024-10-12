module imme (
    input logic [31:0] i_instruction, 
    output logic [31:0] o_imme_value
); 
   
    logic [19:0] sign_extend; 

    assign sign_extend = (i_instruction[31]) ? 20'hFFFFF : 20'd0; 

    always_comb begin
        if ((i_instruction[6:0] == 7'b0010011) || (i_instruction[6:0] == 7'b0000011)) begin //I_Type + LD_type
            o_imme_value = {sign_extend,i_instruction[31:20]};
        end else if (i_instruction[6:0] == 7'b0100011) begin // ST_type
            o_imme_value = {sign_extend,i_instruction[31:25],i_instruction[11:7]}; 
        end else if (i_instruction[6:0] == 7'b1100011) begin // BR_type
            o_imme_value = {sign_extend[18:0],i_instruction[31],i_instruction[7],i_instruction[30:25],i_instruction[11:8],1'd0}; 
        end else begin
            o_imme_value = 32'd0;
        end
    end
endmodule 