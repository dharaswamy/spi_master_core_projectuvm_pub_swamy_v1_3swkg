 

class base_test extends uvm_test;
  
  `uvm_component_utils(base_test)
  
  uvm_factory factory = uvm_factory::get();
  uvm_coreservice_t cs = uvm_coreservice_t::get();
  
  //wb_base sequence handle declaration
   // wb_base_sequence wb_sequ;
  
   //spi slave base class handle declaration
  //spi_slave_base_sequence slave_b_seq;
  
   //handle declaration for the environment
  spi_environment spi_env;

  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    
  endfunction:new
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     //uvm_config_db#(bit)::set(null,"*","tx_neg",tx_neg_t1);
    // uvm_config_db#(bit)::set(null,"*","rx_neg",rx_neg_t1);
    // uvm_config_db#(bit)::set(null,"*","lsb",lsb_t1);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
   // wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
   // slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq");
    spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  this.print();
  //factory = cs.get_factory();
 factory.print();
  endfunction:end_of_elaboration_phase
  
  
  
  //start_of_simulation_phase function
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH);
  uvm_top.print_topology();
    
   
    spi_env.slave_agent[0].slave_driv.temp_ss_pad_o=254; 
    spi_env.slave_agent[0].slave_mntr.temp_ss_pad_o=254; 
      
    spi_env.slave_agent[1].slave_driv.temp_ss_pad_o=253; 
    spi_env.slave_agent[1].slave_mntr.temp_ss_pad_o=253; 
      
    spi_env.slave_agent[2].slave_driv.temp_ss_pad_o=251; 
    spi_env.slave_agent[2].slave_mntr.temp_ss_pad_o=251; 
      
     
      
    spi_env.slave_agent[3].slave_driv.temp_ss_pad_o=247; 
    spi_env.slave_agent[3].slave_mntr.temp_ss_pad_o=247; 
      
    spi_env.slave_agent[4].slave_driv.temp_ss_pad_o=239; 
    spi_env.slave_agent[4].slave_mntr.temp_ss_pad_o=239; 
      
    spi_env.slave_agent[5].slave_driv.temp_ss_pad_o=223; 
    spi_env.slave_agent[5].slave_mntr.temp_ss_pad_o=223; 
      
    spi_env.slave_agent[6].slave_driv.temp_ss_pad_o=191; 
    spi_env.slave_agent[6].slave_mntr.temp_ss_pad_o=191; 
      
    spi_env.slave_agent[7].slave_driv.temp_ss_pad_o=127; 
    spi_env.slave_agent[7].slave_mntr.temp_ss_pad_o=127;

    endfunction:start_of_simulation_phase
  
  
  
 /* virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
     wb_sequ.start(spi_env.master_agent.master_sqr);
     slave_b_seq.start(spi_env.slave_agent0.slave_sqr);
    join_any
    #10000;
    phase.drop_objection(this);
  endtask:run_phase*/
  
  
  //ss_pad_o [7:0] =0000_0011 
  
endclass:base_test








// NAME OF SLAVE	"VALUE OF THE SS_PAD_O 
// FOR ACTIVE LOW"	"VALUE OF THE SS_PAD_O 
//        FOR ACTIVE HIGH"
// SLAVE0	1111_1110=254=8'hfe	0000_0001=1
// SLAVE1	1111_1101=253==8'hfd	0000_0010=2
// SLAVE2	1111_1011=251=8'hfb	0000_0100=4
// SLAVE3	1111_0111=247=8'hf7	0000_1000=8
// SLAVE4	1110_1111=239=8'hef	0001_0000=16
// SLAVE5	1101_1111=223=8'hdf	0010_0000=32
// SLAVE6	1011_1111=191=8'hbf	0100_0000=64
// SLAVE7	0111_1111=127=8'h7f	1000_0000=128