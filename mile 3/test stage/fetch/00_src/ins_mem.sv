module ins_mem ( 
    input logic [31:0] i_address, 
    output logic [31:0] o_data
);

    /*Registers store the data */
    logic [31:0] ins [2047:0]; 
    
    initial begin
        $readmemh("../02_test/mem.dump",ins); 
    end
	 
	assign o_data = ins[i_address]; 
endmodule 