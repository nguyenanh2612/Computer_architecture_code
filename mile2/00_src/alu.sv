module alu (
    input logic [31:0] i_operand_a, i_operand_b, 
    input logic [3:0] i_alu_op, 
    output logic [31:0] o_alu_data
);

    logic common_signed; 
    logic [31:0] arimethic_signed_shift; 
    logic [32:0] subtrac_result; 


    assign common_signed = (i_operand_a[31] == i_operand_b[31]); 
    assign subtrac_result = i_operand_a + ~i_operand_b + 1; 
    assign arimethic_signed_shift  = (i_operand_a[31]) ? 32'hFFFFFFFF : 32'd0; 

    always_comb begin
        case (i_alu_op)
        //ADD
        4'd0: begin
            o_alu_data = i_operand_a + i_operand_b; 
        end
        //SUB
        4'd1: begin
            o_alu_data = subtrac_result; 
        end
        //SLT
        4'd2: begin
            o_alu_data = (common_signed) ? {31'd0,subtrac_result[31]} : {31'd0,i_operand_a[31]}; 
        end
        //SLTU
        4'd3: begin
            o_alu_data = {31'd0,subtrac_result[32]}; 
        end
        //XOR
        4'd4: begin
            o_alu_data = i_operand_a ^ i_operand_b;
        end
        //OR
        4'd5: begin
            o_alu_data = i_operand_a | i_operand_b; 
        end
        //AND
        4'd6: begin
            o_alu_data = i_operand_a & i_operand_b; 
        end
        //SLL
        4'd7: begin
            case (i_operand_b[4:0])
            5'd0 : o_alu_data = i_operand_a; 
            5'd1 : o_alu_data = {i_operand_a[30:0],1'd0};
            5'd2 : o_alu_data = {i_operand_a[29:0],2'd0};
            5'd3 : o_alu_data = {i_operand_a[28:0],3'd0};
            5'd4 : o_alu_data = {i_operand_a[27:0],4'd0};
            5'd5 : o_alu_data = {i_operand_a[26:0],5'd0};
            5'd6 : o_alu_data = {i_operand_a[25:0],6'd0};
            5'd7 : o_alu_data = {i_operand_a[24:0],7'd0};
            5'd8 : o_alu_data = {i_operand_a[23:0],8'd0};
            5'd9 : o_alu_data = {i_operand_a[22:0],9'd0};
            5'd10: o_alu_data = {i_operand_a[21:0],10'd0};
            5'd11: o_alu_data = {i_operand_a[20:0],11'd0};
            5'd12: o_alu_data = {i_operand_a[19:0],12'd0};
            5'd13: o_alu_data = {i_operand_a[18:0],13'd0};
            5'd14: o_alu_data = {i_operand_a[17:0],14'd0};
            5'd15: o_alu_data = {i_operand_a[16:0],15'd0};
            5'd16: o_alu_data = {i_operand_a[15:0],16'd0};
            5'd17: o_alu_data = {i_operand_a[14:0],17'd0};
            5'd18: o_alu_data = {i_operand_a[13:0],18'd0};
            5'd19: o_alu_data = {i_operand_a[12:0],19'd0};
            5'd20: o_alu_data = {i_operand_a[11:0],20'd0};
            5'd21: o_alu_data = {i_operand_a[10:0],21'd0};
            5'd22: o_alu_data = {i_operand_a[9:0],22'd0};
            5'd23: o_alu_data = {i_operand_a[8:0],23'd0};
            5'd24: o_alu_data = {i_operand_a[7:0],24'd0};
            5'd25: o_alu_data = {i_operand_a[6:0],25'd0};
            5'd26: o_alu_data = {i_operand_a[5:0],26'd0};
            5'd27: o_alu_data = {i_operand_a[4:0],27'd0};
            5'd28: o_alu_data = {i_operand_a[3:0],28'd0};
            5'd29: o_alu_data = {i_operand_a[2:0],29'd0};
            5'd30: o_alu_data = {i_operand_a[1:0],30'd0};
            5'd31: o_alu_data = {i_operand_a[0]};
                default: o_alu_data = 32'd0; 
            endcase 
        end
        //STL
        4'd8: begin
            case (i_operand_b[4:0])
            5'd0 : o_alu_data = i_operand_a; 
            5'd1 : o_alu_data = {1'd0,i_operand_a[31:1]};
            5'd2 : o_alu_data = {2'd0,i_operand_a[31:2]};
            5'd3 : o_alu_data = {3'd0,i_operand_a[31:3]};
            5'd4 : o_alu_data = {4'd0,i_operand_a[31:4]};
            5'd5 : o_alu_data = {5'd0,i_operand_a[31:5]};
            5'd6 : o_alu_data = {6'd0,i_operand_a[31:6]};
            5'd7 : o_alu_data = {7'd0,i_operand_a[31:7]};
            5'd8 : o_alu_data = {8'd0,i_operand_a[31:8]};
            5'd9 : o_alu_data = {9'd0,i_operand_a[31:9]};
            5'd10: o_alu_data = {10'd0,i_operand_a[31:10]};
            5'd11: o_alu_data = {11'd0,i_operand_a[31:11]};
            5'd12: o_alu_data = {12'd0,i_operand_a[31:12]};
            5'd13: o_alu_data = {13'd0,i_operand_a[31:13]};
            5'd14: o_alu_data = {14'd0,i_operand_a[31:14]};
            5'd15: o_alu_data = {15'd0,i_operand_a[31:15]};
            5'd16: o_alu_data = {16'd0,i_operand_a[31:16]};
            5'd17: o_alu_data = {17'd0,i_operand_a[31:17]};
            5'd18: o_alu_data = {18'd0,i_operand_a[31:18]};
            5'd19: o_alu_data = {19'd0,i_operand_a[31:19]};
            5'd20: o_alu_data = {20'd0,i_operand_a[31:20]};
            5'd21: o_alu_data = {21'd0,i_operand_a[31:21]};
            5'd22: o_alu_data = {22'd0,i_operand_a[31:22]};
            5'd23: o_alu_data = {23'd0,i_operand_a[31:23]};
            5'd24: o_alu_data = {24'd0,i_operand_a[31:24]};
            5'd25: o_alu_data = {25'd0,i_operand_a[31:25]};
            5'd26: o_alu_data = {26'd0,i_operand_a[31:26]};
            5'd27: o_alu_data = {27'd0,i_operand_a[31:27]};
            5'd28: o_alu_data = {28'd0,i_operand_a[31:28]};
            5'd29: o_alu_data = {29'd0,i_operand_a[31:29]};
            5'd30: o_alu_data = {30'd0,i_operand_a[31:30]};
            5'd31: o_alu_data = {31'd0,i_operand_a[31]};
                default: o_alu_data = 0;
            endcase 
        end
        //SRA
        4'd9: begin
            case (i_operand_b[4:0])
            5'd0 : o_alu_data = i_operand_a; 
            5'd1 : o_alu_data = {arimethic_signed_shift[0],i_operand_a[31:1]};
            5'd2 : o_alu_data = {arimethic_signed_shift[1:0],i_operand_a[31:2]};
            5'd3 : o_alu_data = {arimethic_signed_shift[2:0],i_operand_a[31:3]};
            5'd4 : o_alu_data = {arimethic_signed_shift[3:0],i_operand_a[31:4]};
            5'd5 : o_alu_data = {arimethic_signed_shift[4:0],i_operand_a[31:5]};
            5'd6 : o_alu_data = {arimethic_signed_shift[5:0],i_operand_a[31:6]};
            5'd7 : o_alu_data = {arimethic_signed_shift[6:0],i_operand_a[31:7]};
            5'd8 : o_alu_data = {arimethic_signed_shift[7:0],i_operand_a[31:8]};
            5'd9 : o_alu_data = {arimethic_signed_shift[8:0],i_operand_a[31:9]};
            5'd10: o_alu_data = {arimethic_signed_shift[9:0],i_operand_a[31:10]};
            5'd11: o_alu_data = {arimethic_signed_shift[10:0],i_operand_a[31:11]};
            5'd12: o_alu_data = {arimethic_signed_shift[11:0],i_operand_a[31:12]};
            5'd13: o_alu_data = {arimethic_signed_shift[12:0],i_operand_a[31:13]};
            5'd14: o_alu_data = {arimethic_signed_shift[13:0],i_operand_a[31:14]};
            5'd15: o_alu_data = {arimethic_signed_shift[14:0],i_operand_a[31:15]};
            5'd16: o_alu_data = {arimethic_signed_shift[15:0],i_operand_a[31:16]};
            5'd17: o_alu_data = {arimethic_signed_shift[16:0],i_operand_a[31:17]};
            5'd18: o_alu_data = {arimethic_signed_shift[17:0],i_operand_a[31:18]};
            5'd19: o_alu_data = {arimethic_signed_shift[18:0],i_operand_a[31:19]};
            5'd20: o_alu_data = {arimethic_signed_shift[19:0],i_operand_a[31:20]};
            5'd21: o_alu_data = {arimethic_signed_shift[20:0],i_operand_a[31:21]};
            5'd22: o_alu_data = {arimethic_signed_shift[21:0],i_operand_a[31:22]};
            5'd23: o_alu_data = {arimethic_signed_shift[22:0],i_operand_a[31:23]};
            5'd24: o_alu_data = {arimethic_signed_shift[23:0],i_operand_a[31:24]};
            5'd25: o_alu_data = {arimethic_signed_shift[24:0],i_operand_a[31:25]};
            5'd26: o_alu_data = {arimethic_signed_shift[25:0],i_operand_a[31:26]};
            5'd27: o_alu_data = {arimethic_signed_shift[26:0],i_operand_a[31:27]};
            5'd28: o_alu_data = {arimethic_signed_shift[27:0],i_operand_a[31:28]};
            5'd29: o_alu_data = {arimethic_signed_shift[28:0],i_operand_a[31:29]};
            5'd30: o_alu_data = {arimethic_signed_shift[29:0],i_operand_a[31:30]};
            5'd31: o_alu_data = {arimethic_signed_shift[30:0],i_operand_a[31]};
                default: o_alu_data = 0; 
            endcase
        end
            default: o_alu_data = 32'd0; 
        endcase
    end
endmodule 