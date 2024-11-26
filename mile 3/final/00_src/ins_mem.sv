module ins_mem ( 
    input logic [31:0] i_address, 
    output logic [31:0] o_data
);

    /*Registers store the data */
    logic [31:0] ins [2047:0]; 
    
    initial begin
        $readmemh("D:/241/Comp_Ar/mile 3/pipeline/02_test/mem.dump",ins); 
    end
	 
	assign o_data = ins[i_address]; 
endmodule 