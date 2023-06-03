
// VT_INPUT_DELAY, VTB_OUTPUT_ASSERT_DELAY are timestamps relative to the rising edge.
`define VTB_INPUT_DELAY 1
`define VTB_OUTPUT_ASSERT_DELAY 3

// CYCLE_TIME and INTRA_CYCLE_TIME are duration of time.
`define CYCLE_TIME 4
`define INTRA_CYCLE_TIME (`VTB_OUTPUT_ASSERT_DELAY-`VTB_INPUT_DELAY)

`timescale 1ns/1ns

`define T(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17) \
        t(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,`__LINE__)

// Tick one extra cycle upon an error.
`define VTB_TEST_FAIL(lineno, out, ref, port_name) \
    $display("- Timestamp      : %0d (default unit: ns)", $time); \
    $display("- Cycle number   : %0d (variable: cycle_count)", cycle_count); \
    $display("- line number    : line %0d in FFTSPIInterconnectRTL_test_loopback_16_tb.v.cases", lineno); \
    $display("- port name      : %s", port_name); \
    $display("- expected value : 0x%x", ref); \
    $display("- actual value   : 0x%x", out); \
    $display(""); \
    #(`CYCLE_TIME-`INTRA_CYCLE_TIME); \
    cycle_count += 1; \
    #`CYCLE_TIME; \
    cycle_count += 1; \
    $fatal;

`define CHECK(lineno, out, ref, port_name) \
  if ((|(out ^ out)) == 1'b0) ; \
  else begin \
    $display(""); \
    $display("The test bench received a value containing X/Z's! Please note"); \
    $display("that the VTB is pessmistic about X's and you should make sure"); \
    $display("all output ports of your DUT does not produce X's after reset."); \
    `VTB_TEST_FAIL(lineno, out, ref, port_name) \
  end \
  if (out != ref) begin \
    $display(""); \
    $display("The test bench received an incorrect value!"); \
    `VTB_TEST_FAIL(lineno, out, ref, port_name) \
  end

module FFTSPIInterconnectRTL_tb;
  // convention
  logic clk;
  logic reset;
  integer cycle_count;

  logic [0:0] adapter_parity ;
  logic [0:0] minion_parity ;
  logic [0:0] minion_cs ;
  logic [0:0] minion_cs_2 ;
  logic [0:0] minion_cs_3 ;
  logic [0:0] minion_miso ;
  logic [0:0] minion_miso_2 ;
  logic [0:0] minion_miso_3 ;
  logic [0:0] minion_mosi ;
  logic [0:0] minion_mosi_2 ;
  logic [0:0] minion_mosi_3 ;
  logic [0:0] master_cs ;
  logic [0:0] master_miso ;
  logic [0:0] master_mosi ;
  logic [0:0] master_sclk ;
  logic [0:0] minion_sclk ;
  logic [0:0] minion_sclk_2 ;
  logic [0:0] minion_sclk_3 ;

  task t(
    input logic [0:0] ref_adapter_parity,
    input logic [0:0] ref_minion_parity,
    input logic [0:0] inp_minion_cs,
    input logic [0:0] inp_minion_cs_2,
    input logic [0:0] inp_minion_cs_3,
    input logic [0:0] ref_minion_miso,
    input logic [0:0] ref_minion_miso_2,
    input logic [0:0] ref_minion_miso_3,
    input logic [0:0] inp_minion_mosi,
    input logic [0:0] inp_minion_mosi_2,
    input logic [0:0] inp_minion_mosi_3,
    input logic [0:0] ref_master_cs,
    input logic [0:0] inp_master_miso,
    input logic [0:0] ref_master_mosi,
    input logic [0:0] ref_master_sclk,
    input logic [0:0] inp_minion_sclk,
    input logic [0:0] inp_minion_sclk_2,
    input logic [0:0] inp_minion_sclk_3,
    integer lineno
  );
  begin
    minion_cs = inp_minion_cs;
    minion_cs_2 = inp_minion_cs_2;
    minion_cs_3 = inp_minion_cs_3;
    minion_mosi = inp_minion_mosi;
    minion_mosi_2 = inp_minion_mosi_2;
    minion_mosi_3 = inp_minion_mosi_3;
    master_miso = inp_master_miso;
    minion_sclk = inp_minion_sclk;
    minion_sclk_2 = inp_minion_sclk_2;
    minion_sclk_3 = inp_minion_sclk_3;
    #`INTRA_CYCLE_TIME;
    `CHECK(lineno, adapter_parity, ref_adapter_parity, "adapter_parity (adapter_parity in Verilog)");
    `CHECK(lineno, minion_parity, ref_minion_parity, "minion_parity (minion_parity in Verilog)");
    `CHECK(lineno, minion_miso, ref_minion_miso, "spi_min.miso (minion_miso in Verilog)");
    `CHECK(lineno, minion_miso_2, ref_minion_miso_2, "spi_min.miso_2 (minion_miso_2 in Verilog)");
    `CHECK(lineno, minion_miso_3, ref_minion_miso_3, "spi_min.miso_3 (minion_miso_3 in Verilog)");
    `CHECK(lineno, master_cs, ref_master_cs, "spi_min.ms_cs (master_cs in Verilog)");
    `CHECK(lineno, master_mosi, ref_master_mosi, "spi_min.ms_mosi (master_mosi in Verilog)");
    `CHECK(lineno, master_sclk, ref_master_sclk, "spi_min.ms_sclk (master_sclk in Verilog)");
    #(`CYCLE_TIME-`INTRA_CYCLE_TIME);
    cycle_count += 1;
  end
  endtask

  // use 25% clock cycle, so #1 for setup #2 for sim #1 for hold
  always #(`CYCLE_TIME/2) clk = ~clk;

  // DUT name
  // By default we use the translated name of the Verilog component. But you can change
  // that by defining the VTB_TOP_MODULE_NAME macro through the simulator command line
  // options (e.g., for VCS you can do +define+VTB_TOP_MODULE_NAME=YourTopModuleName).
`ifdef VTB_TOP_MODULE_NAME
  `VTB_TOP_MODULE_NAME DUT
`else
  FFTSPIInterconnectRTL DUT
`endif
  (
    .clk(clk),
    .reset(reset),
    .adapter_parity(adapter_parity),
    .minion_parity(minion_parity),
    .minion_cs(minion_cs),
    .minion_cs_2(minion_cs_2),
    .minion_cs_3(minion_cs_3),
    .minion_miso(minion_miso),
    .minion_miso_2(minion_miso_2),
    .minion_miso_3(minion_miso_3),
    .minion_mosi(minion_mosi),
    .minion_mosi_2(minion_mosi_2),
    .minion_mosi_3(minion_mosi_3),
    .master_cs(master_cs),
    .master_miso(master_miso),
    .master_mosi(master_mosi),
    .master_sclk(master_sclk),
    .minion_sclk(minion_sclk),
    .minion_sclk_2(minion_sclk_2),
    .minion_sclk_3(minion_sclk_3)
  );

  initial begin
    assert(0 <= `VTB_INPUT_DELAY)
      else $fatal("\n=====\n\nVTB_INPUT_DELAY should >= 0\n\n=====\n");

    assert(`VTB_INPUT_DELAY < `VTB_OUTPUT_ASSERT_DELAY)
      else $fatal("\n=====\n\nVTB_OUTPUT_ASSERT_DELAY should be larger than VTB_INPUT_DELAY\n\n=====\n");

    assert(`VTB_OUTPUT_ASSERT_DELAY <= `CYCLE_TIME)
      else $fatal("\n=====\n\nVTB_OUTPUT_ASSERT_DELAY should be smaller than or equal to CYCLE_TIME\n\n=====\n");

    cycle_count = 0;
    clk   = 1'b0; // NEED TO DO THIS TO HAVE FALLING EDGE AT TIME 0
    reset = 1'b1; // TODO reset active low/high
    #(`CYCLE_TIME/2);

    // Now we are talking
    #`VTB_INPUT_DELAY;
    #`CYCLE_TIME;
    cycle_count = 1;
    #`CYCLE_TIME;
    cycle_count = 2;
    // 2 cycles plus input delay
    reset = 1'b0;

    `include "FFTSPIInterconnectRTL_test_loopback_16_tb.v.cases"

    $display("");
    $display("  [ passed ]");
    $display("");

    // Tick one extra cycle for better waveform
    #`CYCLE_TIME;
    cycle_count += 1;
    $finish;
  end
endmodule
