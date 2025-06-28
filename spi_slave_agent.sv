typedef uvm_sequencer #(spi_slave_seq_item) spi_slave_sequencer;

class spi_slave_agent extends uvm_agent;
  //factoru registration
  `uvm_component_utils(spi_slave_agent)
  
   //handle declartion for the sequencer 
  spi_slave_sequencer slave_sqr;
  //spi slave driver
  spi_slave_driver slave_driv;
  //spi slave monitor handle declaration
  spi_slave_monitor  slave_mntr;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    slave_sqr=spi_slave_sequencer::type_id::create("slave_sqr",this);
    slave_driv=spi_slave_driver::type_id::create("slave_driv",this);
    slave_mntr=spi_slave_monitor::type_id::create("slave_mntr",this);
  endfunction:build_phase
  
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    slave_driv.seq_item_port.connect(slave_sqr.seq_item_export);
  endfunction:connect_phase
  
  
endclass:spi_slave_agent