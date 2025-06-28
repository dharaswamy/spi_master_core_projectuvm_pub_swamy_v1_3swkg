interface io_intf();

//input to the spi master core and these is output of the slave devices 
logic miso_pad_i;
//outputs of spi master core, these are inputs to the slave devices
  
logic [7:0] ss_pad_o;//these is for the slave selection.
logic sclk_pad_o;//synchronous clk to all slaves
logic mosi_pad_o;
  
  
  clocking s_driv_cb@(sclk_pad_o);
   default input #1 output #0;
    output miso_pad_i;
    input mosi_pad_o;
   endclocking:s_driv_cb
  
  
  clocking s_mntr_cb@(posedge sclk_pad_o);
   default input #1 output #0;
    input miso_pad_i;
    input mosi_pad_o;
   endclocking:s_mntr_cb
  
  
  
modport s_driver_mdp(clocking s_driv_cb,input sclk_pad_o,input ss_pad_o);
modport s_monitor_mdp(clocking s_mntr_cb,input sclk_pad_o,input ss_pad_o);
      

      
endinterface:io_intf