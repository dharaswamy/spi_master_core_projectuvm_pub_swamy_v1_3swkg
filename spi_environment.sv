
class spi_environment extends uvm_env;
 
  //factory registration
  `uvm_component_utils(spi_environment)
  
  //spi master agent handle declaration
  spi_master_agent master_agent;
  //spi slave agent handle declaration
  spi_slave_agent slave_agent[`NO_SLAVES]; //NO_SLAVES IS `define value from tb_defines
 // spi_slave_agent slave_agent0;
  /*spi_slave_agent slave_agent1;
  spi_slave_agent slave_agent2;
  spi_slave_agent slave_agent3;
  spi_slave_agent slave_agent4;
  spi_slave_agent slave_agent5;
  spi_slave_agent slave_agent6;
  spi_slave_agent slave_agent7;*/
  
  

  
  //scoreboard handle declartion
  scoreboard  scb;
  
//function coverage master / wishbone class declaration.
wb_fc_subscriber wb_fc;
  
//function coverage slave class declaration.
  slave_fc_subscriber slv_fc;
  
//----------------------------------------------------------
 //reg model implementation 
//declare your register block name
// wb_reg_model regmodel;//recommanded name.
 //declare handle for the user defind adapter
//  wb_adapter wb_adptr;
//----------------------------------------------------------  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //for register abstraction layer model ,we create the regmodel and the adapter.
    //reg_model = wb_reg_model::type_id::create("reg_model",this);
    //wb_adptr = wb_adapter::type_id::create("wb_adptr",get_full_name());
    
    master_agent=spi_master_agent::type_id::create("master_agent",this);
   
    //slave_agent0=spi_slave_agent::type_id::create("slave_agent0",this);
    foreach(slave_agent[i])
      slave_agent[i] = spi_slave_agent::type_id::create($sformatf("slave_agent[%0d]",i),this);
    scb=scoreboard::type_id::create("scb",this);
    wb_fc=wb_fc_subscriber::type_id::create("wb_fc",this);
    slv_fc=slave_fc_subscriber::type_id::create("slv_fc",this);
    /*slave_agent1=spi_slave_agent::type_id::create("slave_agent1",this);
    slave_agent2=spi_slave_agent::type_id::create("slave_agent2",this);
    slave_agent3=spi_slave_agent::type_id::create("slave_agent3",this);
    slave_agent4=spi_slave_agent::type_id::create("slave_agent4",this);
    slave_agent5=spi_slave_agent::type_id::create("slave_agent5",this);
    slave_agent6=spi_slave_agent::type_id::create("slave_agent6",this);
    slave_agent7=spi_slave_agent::type_id::create("slave_agent7",this); */
    
  endfunction:build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //for ral model
    // regmodel.default_map.set_sequencer(.sequencer(master_agent.master_seqr),.adapter(wb_adptr) );
    //regmodel.default_map.set_base_addr(0);//for spi peripheral have base addr = 0 //every protocol have the base addr (explore).
    //regmodel.add_hdl_path("tb_top_spi_project. spi_top1");// why are giving ".add_hdl_path" for "back door acess ".// top.<dut_name>
    master_agent.master_mntr.item_collected_port.connect(scb.m_mntr2scb);
    master_agent.master_mntr.item_collected_port.connect(wb_fc.fc_collected);
    foreach(slave_agent[i]) begin
      slave_agent[i].slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
      slave_agent[i].slave_mntr.item_collected_port.connect(slv_fc.slv_item_collected);
    end
      // slave_agent0.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
        /* slave_agent1.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent2.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent3.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent4.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent5.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent6.slave_mntr.item_collected_port.connect(scb.s_mntr2scb);
       slave_agent7.slave_mntr.item_collected_port.connect(scb.s_mntr2scb); */
  endfunction:connect_phase
  
  
  
endclass:spi_environment