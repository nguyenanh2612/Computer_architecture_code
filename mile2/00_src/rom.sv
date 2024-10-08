module rom (
    input logic [31:0] ins_addr_i, 
    output logic [31:0] instruction_o
);
    reg [31:0] instruction [0:2047] ; 
    initial begin
        $readmemh("instruction.hex",instruction);
    end 
    
	 assign instruction_o = instruction[ins_addr_i >> 2]; 

endmodule 