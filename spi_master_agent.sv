
typedef uvm_sequencer #(spi_master_seq_item) spi_master_sequencer;

class spi_master_agent extends uvm_agent;
  
  //factory registration
  `uvm_component_utils(spi_master_agent) 
  
  //handle declartion for the sequencer 
  spi_master_sequencer master_sqr;
  //handle declaration for the driver
  spi_master_driver master_driv;
  
  //handle declaration for the monitor
  spi_master_monitor master_mntr;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
   endfunction:new
  
  //build_phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
//creating the master driver
master_driv=spi_master_driver::type_id::create("master_driv",this);
//creating the master_monitor
master_mntr=spi_master_monitor::type_id::create("master_mntr",this);
//creating the master sequencer
  master_sqr=spi_master_sequencer::type_id::create("master_sqr",this);
endfunction:build_phase
  
//connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    master_driv.seq_item_port.connect(master_sqr.seq_item_export);
  endfunction:connect_phase
  
endclass:spi_master_agent