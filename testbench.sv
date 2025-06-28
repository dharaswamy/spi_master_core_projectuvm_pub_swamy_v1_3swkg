
// Eda link : https://edaplayground.com/x/ebiL ( This eda link small updates with eda link : https://edaplayground.com/x/es_N -> this eda also put as a published but not save in my git ) 

// // ( swamy ) please copy the code but don't change/modify the code here.
 

`timescale 1ns / 10ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "tb_defines.sv"
`include "spi_assertion_module.sv"
//`include "spi_io_interface.sv"
//`include "spi_io_interface2.sv"
`include "spi_io_interface3.sv"
`include "spi_wishbone_interface.sv"
`include "spi_master_seq_item.sv"
`include "spi_master_base_sequence.sv"
`include "spi_master_driver.sv"
`include "spi_master_monitor.sv"
`include "spi_master_agent.sv"
`include "spi_slave_seq_item.sv"
`include "spi_slave_base_sequence.sv"
//`include "spi_slave_driver.sv"
//`include "spi_slave_driver1.sv"
`include "spi_slave_driver3.sv"
//`include "spi_slave_monitor.sv"
//`include "spi_slave_monitor1.sv"
`include "spi_slave_monitor3.sv"
`include "spi_slave_agent.sv"
//`include "scoreboard.sv"
`include "scoreboard1.sv"
`include "wb_fc_subscriber.sv"
`include "slave_fc_subscriber.sv"
`include "spi_environment.sv"
`include "base_test.sv"
`include "test_cases.sv"
//`include "tx_0_rx_0.sv"

module tb_top_spi_project;

bit clk;
bit rst;//spi is active high synchronous reset.

//clock signal  generation
initial begin
clk=1'b0;
forever #5 clk=~clk;
end

//reset generation
initial begin
 rst=1'b1;
#30 rst=1'b0;
end 
  
// initial begin
//   #436 rst=1'b1;
//   #20 rst=1'b0;
// end

//wishbone interface instantiation
wishbone_intf wish_vintf(clk,rst); 
//io interface instantiation
 io_intf io_vintf();
  
spi_top  spi_top1(
  // Wishbone signals
                  .wb_clk_i(clk), 
                  .wb_rst_i(rst), 
                  .wb_adr_i(wish_vintf.wb_adr_i), 
                  .wb_dat_i(wish_vintf.wb_dat_i), 
                  .wb_dat_o(wish_vintf.wb_dat_o), 
                  .wb_sel_i(wish_vintf.wb_sel_i),
                  .wb_we_i(wish_vintf.wb_we_i), 
                  .wb_stb_i(wish_vintf.wb_stb_i), 
                  .wb_cyc_i(wish_vintf.wb_cyc_i), 
                  .wb_ack_o(wish_vintf.wb_ack_o),
                  .wb_err_o(wish_vintf.wb_err_o),   
                  .wb_int_o(wish_vintf.wb_int_o),
                   // SPI signals
                 .ss_pad_o(io_vintf.ss_pad_o), 
                 .sclk_pad_o(io_vintf.sclk_pad_o), 
                 .mosi_pad_o(io_vintf.mosi_pad_o), 
                 .miso_pad_i(io_vintf.miso_pad_i) );
  
 // bind spi_top1  spi_assertion_module spi_assrt(.*);
//
bind spi_top1  spi_assertion_module spi_assrt(//spi master signals
                                       .wb_clk_i(wb_clk_i),
                                       .wb_rst_i(wb_rst_i),
                                       .wb_adr_i(wb_adr_i), 
                                       .wb_dat_i(wb_dat_i),
                                       .wb_dat_o(wb_dat_o), 
                                       .wb_sel_i(wb_sel_i),
                                       .wb_we_i(wb_we_i), 
                                       .wb_stb_i(wb_we_i), 
                                       .wb_cyc_i(wb_cyc_i), 
                                       .wb_ack_o(wb_ack_o), 
                                       .wb_err_o(wb_err_o),
                                       .wb_int_o(wb_int_o),
                                      // SPI slave  signals
                                       .ss_pad_o(ss_pad_o),
                                       .sclk_pad_o(sclk_pad_o),
                                       .mosi_pad_o(mosi_pad_o),
                                       .miso_pad_i(miso_pad_i));

  
  
initial begin
  
uvm_config_db#(virtual wishbone_intf)::set(null,"*","wish_vintf",wish_vintf);
uvm_config_db#(virtual io_intf)::set(null,"*","io_vintf",io_vintf); 
  
  run_test("test_lsb0_txg0_rxg0");
 end
  
 
    // uvm_config_db#(virtual io_intf)::set(null,"*","io_vintf",io_vintf);
 
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  //#100000 $finish;
end
  
  
endmodule:tb_top_spi_project