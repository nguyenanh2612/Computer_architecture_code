module alu (
    input logic [31:0] operand_a_i, operand_b_i, 
    input logic [3:0] alu_op_i, 
    output logic [31:0] alu_data_o
);

    logic common_signed_d; 
    logic [31:0] arimethic_signed_shift; 
    logic [32:0] sub_d; 


    assign common_signed_d = (operand_a_i[31] == operand_b_i[31]); 
    assign sub_d = operand_a_i + ~operand_b_i + 1; 
    assign arimethic_signed_shift  = (operand_a_i[31]) ? 32'hFFFFFFFF : 32'd0; 

    always_comb begin
        case (alu_op_i)
        //ADD
        4'd0: begin
            alu_data_o = operand_a_i + operand_b_i; 
        end
        //SUB
        4'd1: begin
            alu_data_o = sub_d; 
        end
        //SLT
        4'd2: begin
            alu_data_o = (common_signed_d) ? {31'd0,sub_d[31]} :{31'd0,~sub_d[31]} & {31'd0,operand_a_i[31]}; 
        end
        //SLTU
        4'd3: begin
            alu_data_o = {31'd0,sub_d[32]}; 
        end
        //XOR
        4'd4: begin
            alu_data_o = operand_a_i ^ operand_b_i;
        end
        //OR
        4'd5: begin
            alu_data_o = operand_a_i | operand_b_i; 
        end
        //AND
        4'd6: begin
            alu_data_o = operand_a_i & operand_b_i; 
        end
        //SLL
        4'd7: begin
            alu_data_o = operand_a_i << operand_b_i[4:0]; 
        end
        //STL
        4'd8: begin
            alu_data_o = operand_a_i >> operand_b_i[4:0]; 
        end
        //SRA
        4'd9: begin
            case (operand_b_i[4:0])
            5'd0 : alu_data_o = operand_a_i; 
            5'd1 : alu_data_o = {arimethic_signed_shift[0],operand_a_i[31:1]};
            5'd2 : alu_data_o = {arimethic_signed_shift[1:0],operand_a_i[31:2]};
            5'd3 : alu_data_o = {arimethic_signed_shift[2:0],operand_a_i[31:3]};
            5'd4 : alu_data_o = {arimethic_signed_shift[3:0],operand_a_i[31:4]};
            5'd5 : alu_data_o = {arimethic_signed_shift[4:0],operand_a_i[31:5]};
            5'd6 : alu_data_o = {arimethic_signed_shift[5:0],operand_a_i[31:6]};
            5'd7 : alu_data_o = {arimethic_signed_shift[6:0],operand_a_i[31:7]};
            5'd8 : alu_data_o = {arimethic_signed_shift[7:0],operand_a_i[31:8]};
            5'd9 : alu_data_o = {arimethic_signed_shift[8:0],operand_a_i[31:9]};
            5'd10: alu_data_o = {arimethic_signed_shift[9:0],operand_a_i[31:10]};
            5'd11: alu_data_o = {arimethic_signed_shift[10:0],operand_a_i[31:11]};
            5'd12: alu_data_o = {arimethic_signed_shift[11:0],operand_a_i[31:12]};
            5'd13: alu_data_o = {arimethic_signed_shift[12:0],operand_a_i[31:13]};
            5'd14: alu_data_o = {arimethic_signed_shift[13:0],operand_a_i[31:14]};
            5'd15: alu_data_o = {arimethic_signed_shift[14:0],operand_a_i[31:15]};
            5'd16: alu_data_o = {arimethic_signed_shift[15:0],operand_a_i[31:16]};
            5'd17: alu_data_o = {arimethic_signed_shift[16:0],operand_a_i[31:17]};
            5'd18: alu_data_o = {arimethic_signed_shift[17:0],operand_a_i[31:18]};
            5'd19: alu_data_o = {arimethic_signed_shift[18:0],operand_a_i[31:19]};
            5'd20: alu_data_o = {arimethic_signed_shift[19:0],operand_a_i[31:20]};
            5'd21: alu_data_o = {arimethic_signed_shift[20:0],operand_a_i[31:21]};
            5'd22: alu_data_o = {arimethic_signed_shift[21:0],operand_a_i[31:22]};
            5'd23: alu_data_o = {arimethic_signed_shift[22:0],operand_a_i[31:23]};
            5'd24: alu_data_o = {arimethic_signed_shift[23:0],operand_a_i[31:24]};
            5'd25: alu_data_o = {arimethic_signed_shift[24:0],operand_a_i[31:25]};
            5'd26: alu_data_o = {arimethic_signed_shift[25:0],operand_a_i[31:26]};
            5'd27: alu_data_o = {arimethic_signed_shift[26:0],operand_a_i[31:27]};
            5'd28: alu_data_o = {arimethic_signed_shift[27:0],operand_a_i[31:28]};
            5'd29: alu_data_o = {arimethic_signed_shift[28:0],operand_a_i[31:29]};
            5'd30: alu_data_o = {arimethic_signed_shift[29:0],operand_a_i[31:30]};
            5'd31: alu_data_o = {arimethic_signed_shift[30:0],operand_a_i[31]};
                default: alu_data_o = 0; 
            endcase
        end
            default: alu_data_o = 32'd0; 
        endcase
    end


endmodule 