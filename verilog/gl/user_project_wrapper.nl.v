// This is the unpowered netlist.
module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;


 FFTSPIInterconnectRTL fft_spi (.adapter_parity(io_out[7]),
    .clk(wb_clk_i),
    .master_cs(io_out[21]),
    .master_miso(io_in[22]),
    .master_mosi(io_out[23]),
    .master_sclk(io_out[24]),
    .minion_cs(io_in[9]),
    .minion_cs_2(io_in[13]),
    .minion_cs_3(io_in[17]),
    .minion_miso(io_out[12]),
    .minion_miso_2(io_out[16]),
    .minion_miso_3(io_out[20]),
    .minion_mosi(io_in[10]),
    .minion_mosi_2(io_in[14]),
    .minion_mosi_3(io_in[18]),
    .minion_parity(io_out[8]),
    .minion_sclk(io_in[11]),
    .minion_sclk_2(io_in[15]),
    .minion_sclk_3(io_in[19]),
    .reset(wb_rst_i),
    .io_oeb({_NC1,
    _NC2,
    _NC3,
    _NC4,
    _NC5,
    _NC6,
    _NC7,
    _NC8,
    _NC9,
    _NC10,
    _NC11,
    _NC12,
    _NC13,
    _NC14,
    _NC15,
    _NC16,
    _NC17,
    _NC18,
    _NC19}));
endmodule

