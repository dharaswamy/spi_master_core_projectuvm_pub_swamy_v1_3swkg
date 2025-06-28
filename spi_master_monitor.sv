`define MNTR_IF vintf.m_mntr_mdp.m_mntr_cb
class spi_master_monitor extends uvm_monitor;
//factory registration
`uvm_component_utils(spi_master_monitor)

//virtual interface handle declaration
virtual wishbone_intf vintf;

// Declare analysis port
uvm_analysis_port#(spi_master_seq_item) item_collected_port;

//Declare seq_item handle, Used as a place holder for sampled signal activity,
spi_master_seq_item trans_collected;
  
//default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
    item_collected_port=new("item_collected_port",this);
    trans_collected=new();
  endfunction:new
  
function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db#(virtual wishbone_intf)::get(this," ","wish_vintf",vintf))
  `uvm_fatal("FATAL CONFIG DB","SPI MASTER MONITOR NOT GOT THE CONFIG DB");
  endfunction:build_phase

  //run_phase of monitor class
virtual task run_phase(uvm_phase phase);
  
//`uvm_info("run_monitor",$sformatf(" BEFORE WAIT %0t",$time),UVM_NONE);  
wait(!vintf.m_mntr_mdp.wb_rst_i);
//`uvm_info("run_monitor",$sformatf("AFTER WAIT %0t",$time),UVM_NONE);  
  repeat(10)
@(posedge vintf.m_mntr_mdp.wb_clk_i);

forever begin:forever_begin
  
//@(posedge vintf.m_mntr_mdp.wb_clk_i);
@(negedge vintf.m_mntr_mdp.wb_clk_i); 
wait((`MNTR_IF.wb_we_i) || (!`MNTR_IF.wb_we_i));

//for write operation 
  if(`MNTR_IF.wb_we_i) begin:write
   trans_collected.adr_i=`MNTR_IF.wb_adr_i;
   trans_collected.stb_i=`MNTR_IF.wb_stb_i;
   trans_collected.cyc_i=`MNTR_IF.wb_cyc_i;
   trans_collected.sel_i=`MNTR_IF.wb_sel_i;
   trans_collected.we_i=`MNTR_IF.wb_we_i;
   trans_collected.dat_i=`MNTR_IF.wb_dat_i;
   item_collected_port.write(trans_collected);
  `uvm_info(get_type_name(),$sformatf("MASTER MONITOR COLLECTED VALUES IN WRITE MODE \n %0s",trans_collected.display),UVM_NONE);
  end:write
      
//for the read operation
 if(!`MNTR_IF.wb_we_i) begin:read
trans_collected.adr_i=`MNTR_IF.wb_adr_i;
trans_collected.stb_i=`MNTR_IF.wb_stb_i;
trans_collected.cyc_i=`MNTR_IF.wb_cyc_i;
trans_collected.sel_i=`MNTR_IF.wb_sel_i;
trans_collected.we_i=`MNTR_IF.wb_we_i; 
@(posedge vintf.m_mntr_mdp.wb_clk_i);
@(posedge vintf.m_mntr_mdp.wb_clk_i);
trans_collected.dat_o=`MNTR_IF.wb_dat_o;
item_collected_port.write(trans_collected);
`uvm_info(get_type_name(),$sformatf("MASTER MONITOR COLLECTED VALUES IN READ MODE \n %0s",trans_collected.display),UVM_NONE);
end:read
  
wait(`MNTR_IF.wb_ack_o);
end:forever_begin
  
endtask:run_phase

  
endclass:spi_master_monitor