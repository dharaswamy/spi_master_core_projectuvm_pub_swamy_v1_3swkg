interface io_intf();

//input to the spi master core and these is output of the slave devices 
logic miso_pad_i;
//outputs of spi master core, these are inputs to the slave devices
  
logic [7:0] ss_pad_o;//these is for the slave selection.
logic sclk_pad_o;//synchronous clk to all slaves
logic mosi_pad_o;
  
  

  
  modport s_driv_mdp(input sclk_pad_o,input ss_pad_o,input mosi_pad_o,output miso_pad_i);
  modport s_mntr_mdp(input sclk_pad_o,input ss_pad_o,input mosi_pad_o,input miso_pad_i);
      

      
endinterface:io_intf