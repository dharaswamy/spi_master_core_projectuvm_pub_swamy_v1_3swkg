`define DRIVE_IF wish_vintf.m_driver_mdp.m_driver_cb


class spi_master_driver extends uvm_driver#(spi_master_seq_item);

  int unsigned int_o_count=1;
//factory registration
`uvm_component_utils(spi_master_driver)

//wishbone_interface virtual handle declaration
virtual wishbone_intf wish_vintf;
  
//default constructor
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction:new

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db#(virtual wishbone_intf)::get(this,"","wish_vintf",this.wish_vintf))
   `uvm_fatal("FATAL:NO_wish_intf",$sformatf("config_db get method failed in master driver"));
endfunction:build_phase
  
  virtual task pre_reset_phase(uvm_phase phase);
    `uvm_info("PRE_RESET","PRE_RESET IS STARTED FROM THE SEQUENCE BASE",UVM_NONE);
  endtask:pre_reset_phase
  
 
  
  
  task rst();
    @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
    wait(wish_vintf.m_driver_mdp.wb_rst_i); 
    `uvm_info("RESET","RESET IS STARTED FROM THE MASTER DRIVER",UVM_NONE);
     `DRIVE_IF.wb_stb_i<=0;
    `DRIVE_IF.wb_cyc_i<=0;
    `DRIVE_IF.wb_sel_i<=0;
    `DRIVE_IF.wb_dat_i<=0;
   `DRIVE_IF.wb_adr_i<=0;
    `DRIVE_IF.wb_we_i<=0;
    wait(!wish_vintf.m_driver_mdp.wb_rst_i);
    `uvm_info("RESET","RESET IS COMPLETED FROM THE MASTER DRIVER",UVM_NONE);
     `DRIVE_IF.wb_we_i<=1'bx;
    //`uvm_info("RESET_VALUES",$sformatf("MASTER RESET INPUT VALUES stb=%0b cyc=%0b sel=%0b addr(deci)=%0d we_i=%0b data_i=%0h ",`DRIVE_IF.wb_stb_i, `DRIVE_IF.wb_cyc_i,`DRIVE_IF.wb_sel_i,`DRIVE_IF.wb_adr_i,`DRIVE_IF.wb_we_i,`DRIVE_IF.wb_dat_i),UVM_ALL_ON);
  endtask:rst
  
  
  
//for getting the seq_items from sequence
virtual task run_phase(uvm_phase phase);
//REQ req; //req is parameterized type for requests
//RSP rsp_item; //RSP is parameterized type for responses
 rst();
  repeat(10)
  @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
  
 forever begin

seq_item_port.get_next_item(req);
drive();
   `uvm_info(get_name,$sformatf("DRIVER DRIVED STIMULUS TO DUT \n%0s",req.display),UVM_NONE);
   
   if(req.adr_i == 5'h10 && req.dat_i[8] == 1'b1 && req.dat_i[12] == 1'b1) begin:adr_ctrl
     
  
   @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
   wait(`DRIVE_IF.wb_int_o);
  req.int_o=1'b1; 
     $display("_____________req.int_o=%0b_________________",req.int_o);
  $cast(rsp, req.clone()); // Create a response transaction by cloning req
   //rsp.int_o=1'b1;
 $display("------------------rsp.int_o=%0b-----------",rsp.int_o);   
 rsp.set_id_info(req); // Set the rsp_item sequence id to match req

$display("------------------rsp.int_o=%0b-----------",rsp.int_o); 
seq_item_port.item_done(req);
 seq_item_port.put(rsp); // Handshake back to the sequence via its get_response() call
     `uvm_info(get_name(),$sformatf("\n DRIVER SENT THE RESPONSE \" int_o=%0B\" BACK TO THE SEQUECEC",`DRIVE_IF.wb_int_o),UVM_NONE);
`uvm_info(get_name(),$sformatf("\n INTERRUPT IS RECEIVED \" wb_int_o \" NO OF INTERRUPTS RECEIVED INT_O_COUNT=%0D ",int_o_count),UVM_NONE);
     int_o_count++;
  end:adr_ctrl
 else seq_item_port.item_done(req);  
end
endtask:run_phase

//drive task for drive the stimulus to the dut through the interface
virtual task drive();
  
/*@(posedge wish_vintf.m_driver_mdp.wb_clk_i);

`DRIVE_IF.wb_adr_i <= req.adr_i;
`DRIVE_IF.wb_cyc_i <=req.cyc_i;
`DRIVE_IF.wb_stb_i <=req.stb_i;
`DRIVE_IF.wb_we_i  <=req.we_i;
`DRIVE_IF.wb_sel_i <=req.sel_i;  
`DRIVE_IF.wb_dat_i <=req.dat_i;*/
 
  
   //for write operation
 if(req.we_i == 1 ) begin:write
   @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
`DRIVE_IF.wb_we_i  <=req.we_i;
`DRIVE_IF.wb_adr_i <= req.adr_i;
`DRIVE_IF.wb_cyc_i <=req.cyc_i;
`DRIVE_IF.wb_stb_i <=req.stb_i;
`DRIVE_IF.wb_sel_i <=req.sel_i;  
`DRIVE_IF.wb_dat_i <=req.dat_i;
end:write
  
  
   //for read operation
if(req.we_i == 0) begin:read 
  @(posedge wish_vintf.m_driver_mdp.wb_clk_i);  
`DRIVE_IF.wb_we_i  <=req.we_i;
`DRIVE_IF.wb_adr_i <= req.adr_i;
`DRIVE_IF.wb_cyc_i <=req.cyc_i;
`DRIVE_IF.wb_stb_i <=req.stb_i;
`DRIVE_IF.wb_sel_i <=req.sel_i;  
`DRIVE_IF.wb_dat_i <=req.dat_i; 
 @(posedge wish_vintf.m_driver_mdp.wb_clk_i);  
   `DRIVE_IF.wb_we_i  <= 1'bx;
 @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
 // @(negedge wish_vintf.m_driver_mdp.wb_clk_i);
 
end:read
 
repeat(1)
@(posedge wish_vintf.m_driver_mdp.wb_clk_i);
`DRIVE_IF.wb_we_i  <= 1'bx;
`DRIVE_IF.wb_cyc_i <= 1'b0;
`DRIVE_IF.wb_stb_i <= 1'b0;  
//`DRIVE_IF.wb_sel_i <= 4'b0000;  
  
  //repeat(1) 

  //if(req.adr_i == 5'h10) begin:B1
  //  if(req.dat_i[8]== 1'b1 ) begin:B2
// @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
//wait(`DRIVE_IF.wb_int_o);
//`uvm_info(get_name(),$sformatf("\n INTERRUPT IS RECEIVED \" wb_int_o \" NO OF INTERRUPTS RECEIVED INT_O_COUNT=%0D ",int_o_count),UVM_NONE);
//int_o_count++;
     
//req.int_o=1'b1;
//rsp =new req; 
//rsp.set_id_info(req);
//seq_item_port. put_response(rsp);
//end:B2
//end:B1 
  
endtask:drive
  
endclass:spi_master_driver



/*class spi_master_driver extends uvm_driver#(spi_master_seq_item);

//factory registration
`uvm_component_utils(spi_master_driver)

//wishbone_interface virtual handle declaration
virtual wishbone_intf wish_vintf;
  
//default constructor
function new(string name,uvm_component parent);
super.new(name,parent);
endfunction:new

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  if(!uvm_config_db#(virtual wishbone_intf)::get(this,"","wish_vintf",this.wish_vintf))
   `uvm_fatal("FATAL:NO_wish_intf",$sformatf("config_db get method failed in master driver"));
endfunction:build_phase
  
  virtual task pre_reset_phase(uvm_phase phase);
   `uvm_info("PRE_RESET","PRE_RESET IS STARTED FROM THE SEQUENCE BASE",UVM_NONE);
  endtask:pre_reset_phase
  
  
   
  
  
  
//for getting the seq_items from sequence
virtual task run_phase(uvm_phase phase);
  //reset();
   wait(!wish_vintf.m_driver_mdp.wb_rst_i);
forever begin
  
seq_item_port.get_next_item(req);
`uvm_info("spi_master_driver",$sformatf("MASTER DRIVER GOT VALUES \n %0s",req.sprint()),UVM_NONE);
drive();
seq_item_port.item_done(req);
end
endtask:run_phase

virtual task drive();
  @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
//for write operation
if(req.we_i==1) begin
`DRIVE_IF.wb_adr_i <= req.adr_i;
`DRIVE_IF.wb_cyc_i <=req.cyc_i;
`DRIVE_IF.wb_stb_i <=req.stb_i;
`DRIVE_IF.wb_we_i  <=req.we_i;
`DRIVE_IF.wb_sel_i <=req.sel_i;
`DRIVE_IF.wb_dat_i <=req.dat_i;
 //  @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
 // `DRIVE_IF.wb_adr_i <= req.adr_i;
//`DRIVE_IF.wb_cyc_i <=0;
//`DRIVE_IF.wb_stb_i <=0;
//`DRIVE_IF.wb_we_i  <=req.we_i;
//`DRIVE_IF.wb_sel_i <=4'b1111;
//`DRIVE_IF.wb_dat_i <=req.dat_i;
end

endtask:drive
  
  
endclass:spi_master_driver */



  /*virtual task reset();
    @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
    wait(wish_vintf.m_driver_mdp.wb_rst_i);
    `uvm_info("RESET","RESET IS STARTED AND SEE THE RESET BEHAVIOUR VALUES",UVM_NONE);
      @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      wait(!wish_vintf.m_driver_mdp.wb_rst_i);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
    `DRIVE_IF.wb_adr_i<='h0;
    `DRIVE_IF.wb_we_i<=0;
     `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
    `uvm_info("RESET VALUES",$sformatf("TX0=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='h4;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("TX1=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='h8;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("TX2=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='hc;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("TX3=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='h10;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("CTRL=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='h14;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("DIVIDER=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
      `DRIVE_IF.wb_adr_i<='h18;
    `DRIVE_IF.wb_we_i<=0;
    `DRIVE_IF.wb_stb_i<=1;
      `DRIVE_IF.wb_cyc_i<=1;
       `DRIVE_IF.wb_sel_i<=4'b1111;
    `uvm_info("RESET VALUES",$sformatf("SS=%b",`DRIVE_IF.wb_dat_o),UVM_NONE);
  
     @(posedge wish_vintf.m_driver_mdp.wb_clk_i);
    `uvm_info("RESET STATUS","RESET IS COMPLETED",UVM_NONE);
  endtask:reset
  
  "see the all registers reset behaviour
1.Data receive register each register 
Reset Value: 0x00000000
2.Data transfor reginster each register
Reset Value: 0x00000000
3.Control and status register [CTRL]
Reset Value: 0x00000000
4.Divider register [DIVIDER]
Reset Value: 0x0000ffff
5.Slave select register [SS]
Reset Value: 0x00000000"*/



/*task driver();
  @posedgeclk
  vif.wdbb_adr<=req.addr;
  vif.wb_dat_i<=req.data
  vit.we_i<=req.wr_en;
  vif.stb_i<=req.stb_i;
  vig.cyc_i<=req.cyc_i;
  vif.
endtask*/


