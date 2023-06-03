// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`define CYCLE_TIME 25
`define INTRA_CYCLE_TIME(`VTB_OUTPUT_ASSERT_DELAY - `VTB_INPUT_DELAY)
`define T(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17) \
        t(a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,`__LINE__)

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

  logic reset;
  integer cycle_count;

  reg clock = 1'b0;
  always #12.5 clock = ~clock;

  


  reg clk = 1'b0;

  always #5 clk = ~clk;

  wire        VDD3V3;
  wire        VDD1V8;
  wire        VSS;
  reg         RSTB;
  reg         CSB;

  wire        gpio;
  wire [37:0] mprj_io;

  wire        flash_csb;
  wire        flash_clk;
  wire        flash_io0;
  wire        flash_io1;


  caravel uut
  (
    .vddio     (VDD3V3),
    .vddio_2   (VDD3V3),
    .vssio     (VSS),
    .vssio_2   (VSS),
    .vdda      (VDD3V3),
    .vssa      (VSS),
    .vccd      (VDD1V8),
    .vssd      (VSS),
    .vdda1     (VDD3V3),
    .vdda1_2   (VDD3V3),
    .vdda2     (VDD3V3),
    .vssa1     (VSS),
    .vssa1_2   (VSS),
    .vssa2     (VSS),
    .vccd1     (VDD1V8),
    .vccd2     (VDD1V8),
    .vssd1     (VSS),
    .vssd2     (VSS),
    .clock     (clock),
    .gpio      (gpio),
    .mprj_io   (mprj_io),
    .flash_csb (flash_csb),
    .flash_clk (flash_clk),
    .flash_io0 (flash_io0),
    .flash_io1 (flash_io1),
    .resetb    (RSTB)
  );

  spiflash
  #(
    .FILENAME ("loopback_16.hex")
  )
  spiflash
  (
    .csb (flash_csb),
    .clk (flash_clk),
    .io0 (flash_io0),
    .io1 (flash_io1),
    .io2 (),
    .io3 ()
  );

  // convention


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

  assign adapter_parity = mprj_io[5]; 
  assign minion_parity  = mprj_io[6];
  assign mprj_io[7]  = minion_cs; 
  assign mprj_io[8]  = minion_mosi;
  assign mprj_io[9]  = minion_sclk; 
  assign minion_miso = mprj_io[10];
  assign mprj_io[11] = minion_cs_2; 
  assign mprj_io[12] = minion_mosi_2;
  assign mprj_io[13] = minion_sclk_2; 
  assign minion_miso_2 = mprj_io[14];
  assign mprj_io[15] = minion_cs_3; 
  assign mprj_io[16] = minion_mosi_3;
  assign mprj_io[17] = minion_sclk_3; 
  assign minion_miso_3 = mprj_io[18];
  assign master_cs = mprj_io[19]; 
  assign mprj_io[20] = master_miso;
  assign master_mosi = mprj_io[21]; 
  assign master_sclk = mprj_io[22];

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
