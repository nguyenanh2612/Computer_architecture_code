module regfile (
    input logic clk_i,                  // Clock input
    input logic rst_ni,                 // Active-low reset
    input logic [4:0] rs1_addr,         // Address for source register 1
    input logic [4:0] rs2_addr,         // Address for source register 2
    input logic [4:0] rd_addr,          // Address for destination register
    input logic [31:0] rd_data,         // Data to be written to rd
    input logic rd_wren,                // Write enable for rd
    output logic [31:0] rs1_data,       // Output data from rs1
    output logic [31:0] rs2_data        // Output data from rs2
);

    logic [31:0] register [31:0];        // 32 registers, each 32 bits wide
    integer i; 

    // Asynchronous read for rs1 and rs2
    assign rs1_data = register[rs1_addr];
    assign rs2_data = register[rs2_addr];

    // Synchronous write to rd
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            // Reset the register file
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'b0;
            end
        end else if (rd_wren && rd_addr != 5'b0) begin
            // Write to the register on the positive edge of the clock
            register[rd_addr] <= rd_data;
        end
    end

    // Periodically write register file data to register.data for persistence
    initial begin
        $writememh("register.data", register);  // Save register file data in register.data
    end

endmodule
