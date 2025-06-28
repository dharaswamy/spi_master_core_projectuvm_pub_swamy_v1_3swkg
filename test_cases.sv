
//test case:lsb=0,tx_neg=0 and rx_neg=0.
class  test_lsb0_txg0_rxg0 extends base_test;
  
 // bit tx_neg=1'b0;
 // bit rx_neg=1'b1;
  //bit lsb_t=1'b0;
  
 // uvm_factory factory;
  //uvm_coreservice_t cs = uvm_coreservice_t::get();
  

  //factory registration
  `uvm_component_utils(test_lsb0_txg0_rxg0)
 //`uvm_field_int(tx_neg,UVM_ALL_ON)
 // `uvm_field_int(rx_neg,UVM_ALL_ON)
 // `uvm_field_int(lsb_t,UVM_ALL_ON)
 // `uvm_component_utils_end
  
  //base sequence class handle declaration
 // spi_master_base_sequence master_b_seq;
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
  // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  //handle declaration for the environment
  //spi_environment spi_env;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b0);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b0);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b0);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
    
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
   
   // slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
    foreach(slave_b_seq[i]) 
    slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 /* virtual function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  this.print();
  factory = cs.get_factory();
 factory.print();
  endfunction:end_of_elaboration_phase
  
  //start_of_simulation_phase function
 virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  `uvm_info("TRACE",$sformatf("%m"),UVM_HIGH);
  uvm_top.print_topology();
    
   
      spi_env.slave_agent0.slave_driv.temp_ss_pad_o=254; 
      spi_env.slave_agent0.slave_mntr.temp_ss_pad_o=254; 
      
     spi_env.slave_agent1.slave_driv.temp_ss_pad_o=253; 
      spi_env.slave_agent1.slave_mntr.temp_ss_pad_o=253; 
      
      spi_env.slave_agent2.slave_driv.temp_ss_pad_o=251; 
      spi_env.slave_agent2.slave_mntr.temp_ss_pad_o=251; 
      
     
      
      spi_env.slave_agent3.slave_driv.temp_ss_pad_o=247; 
      spi_env.slave_agent3.slave_mntr.temp_ss_pad_o=247; 
      
      spi_env.slave_agent4.slave_driv.temp_ss_pad_o=239; 
      spi_env.slave_agent4.slave_mntr.temp_ss_pad_o=239; 
      
      spi_env.slave_agent5.slave_driv.temp_ss_pad_o=223; 
      spi_env.slave_agent5.slave_mntr.temp_ss_pad_o=223; 
      
      spi_env.slave_agent6.slave_driv.temp_ss_pad_o=191; 
      spi_env.slave_agent6.slave_mntr.temp_ss_pad_o=191; 
      
      spi_env.slave_agent7.slave_driv.temp_ss_pad_o=127; 
      spi_env.slave_agent7.slave_mntr.temp_ss_pad_o=127;

    endfunction:start_of_simulation_phase */
  
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
     //slave_b_seq.start(spi_env.slave_agent0.slave_sqr);
     slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
     //one sequence object can start on only one sequencer.
     //but different objects start can different sequencers.
     
   join_any
     #100000;
   phase.drop_objection(this);
    phase.phase_done.set_drain_time(this,20000);
  endtask:run_phase 

  
endclass:test_lsb0_txg0_rxg0

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////






//=============================================================================================
//==============test_case: lsb=0 tx_neg=0 ,rx_neg=1============================================
//=============================================================================================

class test_lsb0_txg0_rxg1  extends base_test;
  
 

  //factory registration
  `uvm_component_utils(test_lsb0_txg0_rxg1)

  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
 //spi_slave_base_sequence slave_b_seq;
  
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
 
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     uvm_config_db#(bit)::set(null,"*","lsb",1'b0);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b0);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b1);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
    //slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
    // slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
      foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
    
//slave_b_seq.start(spi_env.slave_agent0.slave_sqr);
     slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
     //one sequence object can start on only one sequencer.
     //but different objects start can different sequencers.
     
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb0_txg0_rxg1

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//=============================================================================================
//=============================testcase:lsb=0 tx_neg=1 rx_neg=0================================
//=============================================================================================

class  test_lsb0_txg1_rxg0  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb0_txg1_rxg0)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
 //spi_slave_base_sequence slave_b_seq;
  
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b0);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b1);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b0);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
    //slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
    // slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
     
     slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
     join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb0_txg1_rxg0
/////////////////////////////////////////////
///////////////////////////////////////////////

//testcase:lsb=0 tx_neg=1 rx_neg=1

class  test_lsb0_txg1_rxg1  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb0_txg1_rxg1)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
// spi_slave_base_sequence slave_b_seq;
  
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b0);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b1);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b1);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
   // slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
     //slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
     
      slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb0_txg1_rxg1
/////////////////////////////////////////////
///////////////////////////////////////////////


//testcase:lsb=1 tx_neg=0 rx_neg=0
class  test_lsb1_txg0_rxg0  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb1_txg0_rxg0)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
// spi_slave_base_sequence slave_b_seq;
  
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b1);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b0);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b0);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0010);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
    //slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
     //slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
      slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb1_txg0_rxg0
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

//testcase:lsb=1 tx_neg=0 rx_neg=1
class  test_lsb1_txg0_rxg1  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb1_txg0_rxg1)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
// spi_slave_base_sequence slave_b_seq;
  
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b1);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b0);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b1);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
    //slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
    // slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
      slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb1_txg0_rxg1
/////////////////////////////////////////////
///////////////////////////////////////////////

//testcase:lsb=1 tx_neg=1 rx_neg=0
class  test_lsb1_txg1_rxg0  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb1_txg1_rxg0)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
 //spi_slave_base_sequence slave_b_seq;
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b1);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b1);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b0);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
   // slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
     //slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
      
      slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb1_txg1_rxg0
/////////////////////////////////////////////
///////////////////////////////////////////////

//testcase:lsb=1 tx_neg=1 rx_neg=1
class  test_lsb1_txg1_rxg1  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb1_txg1_rxg1)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
 //spi_slave_base_sequence slave_b_seq;
   // spi_slave_base_sequence slave_b_seq;
  spi_slave_base_sequence slave_b_seq[`NO_SLAVES];
  
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b1);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b1);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b1);
    uvm_config_db#(int)::set(null,"*","repeat_count",32'h0000_0001);
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
    //slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
     foreach(slave_b_seq[i]) 
      slave_b_seq[i]=spi_slave_base_sequence::type_id::create($sformatf("slave_b_seq[%0d]",i),this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
     //slave_b_seq.start(spi_env.slave_agent[0].slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
     slave_b_seq[0].start(spi_env.slave_agent[0].slave_sqr);
     slave_b_seq[1].start(spi_env.slave_agent[1].slave_sqr);
     slave_b_seq[2].start(spi_env.slave_agent[2].slave_sqr);
     slave_b_seq[3].start(spi_env.slave_agent[3].slave_sqr);
     slave_b_seq[4].start(spi_env.slave_agent[4].slave_sqr);
     slave_b_seq[5].start(spi_env.slave_agent[5].slave_sqr);
     slave_b_seq[6].start(spi_env.slave_agent[6].slave_sqr);
     slave_b_seq[7].start(spi_env.slave_agent[7].slave_sqr); 
       
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb1_txg1_rxg1 
////////////////////////////////////////////////////////////////////////////////////////////

