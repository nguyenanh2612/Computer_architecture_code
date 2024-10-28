module de2_wrapper (
    input wire CLOCK_50,
    input wire [17:0] SW,         // 18 switches on DE2 kit
    output wire [17:0] LEDR,      // 18 red LEDs
    output wire [8:0] LEDG       // 9 green LEDs
);

    // Internal signals
    logic i_clk;
    logic i_rst_n;
    logic [31:0] i_io_sw;
    logic o_insn_vld;
    logic [31:0] o_io_ledr, o_io_ledg, o_pc_debug;

    // Clock and reset mapping
    assign i_clk = CLOCK_50;
    assign i_rst_n = SW[17];  

    // Map switches (18-bit) to 32-bit input
    assign i_io_sw = {14'b0, SW};

    // Instantiate the single-cycle processor
    single_cycle u_single_cycle (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_io_sw(i_io_sw),
        .o_insn_vld(o_insn_vld),
        .o_io_ledr(o_io_ledr),
        .o_io_ledg(o_io_ledg),
        .o_pc_debug(o_pc_debug)
    );

    // Map outputs to DE2 LEDs
    assign LEDR = o_io_ledr[17:0];
    assign LEDG = o_io_ledg[8:0];

endmodule
