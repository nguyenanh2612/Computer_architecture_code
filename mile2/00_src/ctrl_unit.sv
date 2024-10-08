module ctrl_unit (
    input logic clk_i, 
    input logic [31:0] instr, 
    input logic br_less, 
    input logic br_equal, 

    output logic [3:0] alu_op, 
    output logic br_sel,  
    output logic br_unsigned, 
    output logic rd_wren, 
    output logic mem_wren, 
    output logic op_a_sel, op_b_sel, 
    output logic [1:0] wb_sel 
);
    logic [6:0] opcode_d, fucntion7_d; 
    logic [2:0] fucntion3_d;

    assign opcode_d = instr[6:0]; 
    assign fucntion7_d = instr[31:25]; 
    assign fucntion3_d = instr[14:12]; 

    always_comb begin
        case (opcode_d)
        //R-type
        7'b0110011: begin
            op_a_sel = 0; 
            op_b_sel = 0; 
            mem_wren = 0; 
            wb_sel = 2'd0; 
            rd_wren = 1;
            case (fucntion3_d)
            // ADD + SUB
            3'd0: begin 
                alu_op = (fucntion7_d == 0) ? 4'd0 : 4'd1;
            end
            //SLL
            3'd1: begin 
                alu_op = 4'd7;
            end
            //SLT
            3'd2: begin
                alu_op = 4'd2; 
            end
            //SLTU
            3'd3: begin
                alu_op = 4'd3; 
            end
            //XOR
            3'd4: begin
                alu_op = 4'd4; 
            end
            //SRL + SRA
            3'd5: begin
                alu_op = (fucntion7_d == 0) ? 4'd8 : 4'd9;
            end
            //OR
            3'd6: begin
                alu_op = 4'd5; 
            end
            //AND
            3'd7: begin
                alu_op = 4'd10; 
            end
                default: begin
                    alu_op = 4'd11; 
                end
            endcase
        end 
        //I-Type
        7'b0010011: begin
            op_a_sel = 0; 
            op_b_sel = 1; 
            mem_wren = 0; 
            wb_sel = 2'd0; 
            rd_wren = 1;
           case (fucntion3_d)
            // ADDI
            3'd0: begin 
                alu_op = 4'd0;
            end
            //SLLI
            3'd1: begin 
                alu_op = 4'd7;
            end
            //SLTI
            3'd2: begin
                alu_op = 4'd2; 
            end
            //SLTIU
            3'd3: begin
                alu_op = 4'd3; 
            end
            //XORI
            3'd4: begin
                alu_op = 4'd4; 
            end
            //SRLI + SRAI
            3'd5: begin
                alu_op = (fucntion7_d[31:27] == 0) ? 4'd8 : 4'd9;
            end
            //ORI
            3'd6: begin
                alu_op = 4'd5; 
            end
            //ANDI
            3'd7: begin
                alu_op = 4'd10; 
            end
                default: begin
                    alu_op = 4'd11; 
                end
            endcase
        end
        //BR-Type
        
        //NOP 
        default: begin
            op_a_sel = 0; 
            op_b_sel = 0; 
            mem_wren = 0; 
            wb_sel = 2'd0; 
            rd_wren = 0;
            alu_op = 4'd11;
        end
        endcase
    end
endmodule