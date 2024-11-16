module imme (
    // Input 
    input logic [31:0] i_instruction, 
    // Output
    output logic [31:0] o_imme_value
); 

/*****************************************Immediate label ***************************************/
    logic [19:0] sign_extend; 
    logic [31:0] imme_value;

/*****************************************Prepare extended ***************************************/
    assign sign_extend = (i_instruction[31]) ? 20'hFFFFF : 20'd0; 

/*****************************************Extend case ***************************************/
    always_comb begin
        if ((i_instruction[6:0] == 7'b0010011) || (i_instruction[6:0] == 7'b0000011) || (i_instruction[6:0] == 7'b1100111)) begin //I_Type + LD_type + JALR
            imme_value = {sign_extend,i_instruction[31:20]};
        end else if (i_instruction[6:0] == 7'b0100011) begin // ST_type
            imme_value = {sign_extend,i_instruction[31:25],i_instruction[11:7]}; 
        end else if (i_instruction[6:0] == 7'b1100011) begin // BR_type
            imme_value = {sign_extend[18:0],i_instruction[31],i_instruction[7],i_instruction[30:25],i_instruction[11:8],1'd0};  
        end else if ((i_instruction[6:0] == 7'b0110111) || (i_instruction[6:0] == 7'b0010111)) begin // LUI + AUIPC
            imme_value = {i_instruction[31:12],12'd0}; 
        end else if (i_instruction[6:0] == 7'b1101111)begin // JAL 
            imme_value = {sign_extend[10:0],i_instruction[31],i_instruction[19:12],i_instruction[20],i_instruction[30:21],1'b0};
        end else begin
            imme_value = 32'd0;
        end
    end

/***************************************** Output  ***************************************/
    assign o_imme_value = imme_value; 
endmodule 