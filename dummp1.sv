

//dut register names.

 reg       [`SPI_DIVIDER_LEN-1:0] divider;          // Divider register
  reg       [`SPI_CTRL_BIT_NB-1:0] ctrl;             // Control and status register
  reg             [`SPI_SS_NB-1:0] ss;               // Slave select register
  wire         [`SPI_MAX_CHAR-1:0] rx;               // Rx register

















//testcase:lsb=1 tx_neg=1 rx_neg=1
class  test_lsb1_txg1_rxg1  extends base_test;
  

  //factory registration
  `uvm_component_utils(test_lsb1_txg1_rxg1)
 
  
  //wb_base sequence handle declaration
  wb_base_sequence wb_sequ;
  
  //spi slave base class handle declaration
 spi_slave_base_sequence slave_b_seq;
  
  
  
  
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(bit)::set(null,"*","lsb",1'b1);
    uvm_config_db#(bit)::set(null,"*","tx_neg",1'b1);
    uvm_config_db#(bit)::set(null,"*","rx_neg",1'b1);
   
   // master_b_seq=spi_master_base_sequence::type_id::create("master_b_seq",this);
    wb_sequ=wb_base_sequence::type_id::create("wb_sequ");
    slave_b_seq=spi_slave_base_sequence::type_id::create("slave_b_seq",this);
   // spi_env=spi_environment::type_id::create("spi_env",this);
    
  endfunction:build_phase
  
 
  virtual task run_phase(uvm_phase phase);
   phase.raise_objection(this);
   
   fork
   // master_b_seq.start(spi_env.master_agent.master_sqr);
    wb_sequ.start(spi_env.master_agent.master_sqr);
       
      slave_b_seq.start(spi_env.slave_agent0.slave_sqr);
     /* slave_b_seq.start(spi_env.slave_agent1.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent2.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent3.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent4.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent5.slave_sqr);
      slave_b_seq.start(spi_env.slave_agent6.slave_sqr);
    slave_b_seq.start(spi_env.slave_agent7.slave_sqr);*/
      
      
     
    join_any
     #10000;
   phase.drop_objection(this);
    
  endtask:run_phase 

  
endclass:test_lsb1_txg1_rxg1
/////////////////////////////////////////////
///////////////////////////////////////////////



fork
  
  1;
  2;
  3;
join_none

fork 
begin
 500; 
end
  
  begin
  50
  disable fork
  end
  
join_any







