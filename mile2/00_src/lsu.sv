 module lsu (
    input  logic        clk_i,     // Clock signal
    input  logic        rst_ni,    // Active-low reset signal
    input  logic [31:0] addr,      // 32-b00000it address for read/write
    input  logic [31:0] st_data,   // 32-b00000it store data
    input  logic        st_en,     // Store enable (1: write, 0: read)
    input  logic [31:0] sw,        // 32-b00000it input from switches
    
    output logic [31:0] ld_data,   // 32-b00000it loaded data
    output logic [31:0] io_lcd,    // 32-b00000it data to drive LCD
    output logic [31:0] io_ledg,   // 32-b00000it data to drive green LEDs
    output logic [31:0] io_ledr,   // 32-b00000it data to drive red LEDs
    output logic [31:0] io_hex0,   // 32-b00000it data to drive 7-segment LEDs
    output logic [31:0] io_hex1,
    output logic [31:0] io_hex2,
    output logic [31:0] io_hex3,
    output logic [31:0] io_hex4,
    output logic [31:0] io_hex5,
    output logic [31:0] io_hex6,
    output logic [31:0] io_hex7
);

    
    logic [31:0] data_memory [0:1023]; 

    always_ff @( posedge clk_i or negedge rst_ni ) begin
        if (~rst_ni) begin
            data_memory <= '{default:32'd0};
        end else if (st_en) begin
            case (addr[11:8])
            4'd9: begin
                if (addr <= 32'h00000FFF) begin
                    data_memory[addr >> 2] <= sw; 
                end
                else begin
                    data_memory[addr >> 2] <= 32'd0; 
                end
            end
                default: begin
                    if (addr <= 32'h00000FFF) begin
                        data_memory[addr >> 2] <= st_data;
                    end
                    else begin
                    data_memory[addr >> 2] <= 32'd0; 
                    end
                end
            endcase
        end
    end

    always_comb begin
        ld_data = 32'd0;
        io_lcd  = 32'd0;
        io_ledg = 32'd0;
        io_ledr = 32'd0;
        io_hex0 = 32'd0;
        io_hex1 = 32'd0;
        io_hex2 = 32'd0;
        io_hex3 = 32'd0;
        io_hex4 = 32'd0;
        io_hex5 = 32'd0;
        io_hex6 = 32'd0;
        io_hex7 = 32'd0;
        
        if (~st_en) begin
            io_lcd  = data_memory[32'h000008A0 >> 2];
            io_ledg = data_memory[32'h00000890 >> 2];
            io_ledr = data_memory[32'h00000880 >> 2];
            io_hex7 = data_memory[32'h00000870 >> 2];
            io_hex6 = data_memory[32'h00000860 >> 2];
            io_hex5 = data_memory[32'h00000850 >> 2];
            io_hex4 = data_memory[32'h00000840 >> 2];
            io_hex3 = data_memory[32'h00000830 >> 2];
            io_hex2 = data_memory[32'h00000820 >> 2];
            io_hex1 = data_memory[32'h00000810 >> 2];
            io_hex0 = data_memory[32'h00000800 >> 2];
                if (addr <= 32'h00000FFF) begin
                    ld_data = data_memory[addr >> 2];
                end
            end
        end

    
endmodule 
