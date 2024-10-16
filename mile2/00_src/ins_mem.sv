module ins_mem ( 
    input logic [31:0] i_address, 
    output logic [31:0] o_data
);

    /*Registers store the data */
    logic [31:0] ins [0:2047]; 
    
    initial begin
        $readmemh("instruction.txt",ins); 
    end
	 
	assign o_data = ins[i_address]; 
endmodule