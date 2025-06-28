
interface  wishbone_intf(input logic wb_clk_i,wb_rst_i);
  
  //input signals of DUT 
  logic [4:0] wb_adr_i;
  logic [31:0] wb_dat_i;
  logic [3:0] wb_sel_i;
  logic  wb_we_i;
  logic wb_stb_i;
  logic wb_cyc_i;
  
  
  logic [31:0] wb_dat_o;
  logic wb_ack_o;
  logic wb_err_o;
  logic wb_int_o;


  //master driver clocking block
 clocking m_driver_cb @(posedge wb_clk_i);
   default input #1 output #0;
    output wb_adr_i;
    output wb_dat_i;
    output wb_sel_i;
    output wb_we_i;
    output wb_stb_i;
    output wb_cyc_i; 
    input wb_dat_o;
    input wb_ack_o;
    input wb_err_o;
    input wb_int_o;
  endclocking:m_driver_cb
  
  
  //spi_master_monitor clocking block
  clocking m_mntr_cb @(negedge wb_clk_i);
  default input #1 output #0;
  input wb_adr_i;
  input wb_dat_i;
  input wb_sel_i;
  input wb_we_i;
  input wb_stb_i;
  input wb_cyc_i;
  input wb_dat_o;
  input wb_ack_o;
  input wb_err_o;
  input wb_int_o;
endclocking:m_mntr_cb
  
//spi_master driver modport
modport m_driver_mdp(clocking m_driver_cb,input wb_clk_i,wb_rst_i);

//spi_master_monitor modport  
modport m_mntr_mdp(clocking m_mntr_cb,input wb_clk_i,wb_rst_i);
 
  
  
endinterface:wishbone_intf