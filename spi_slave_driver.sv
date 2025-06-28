


class spi_slave_driver extends uvm_driver#(spi_slave_seq_item);
  
  int unsigned temp_ss_pad_o;
  bit tx_neg;
  bit rx_neg;
  bit lsb;
  bit [127:0]  data;
  bit b;
  
 //component factory registration
  `uvm_component_utils_begin(spi_slave_driver)
  `uvm_field_int(tx_neg,UVM_ALL_ON)
  `uvm_field_int(rx_neg,UVM_ALL_ON)
  `uvm_field_int(lsb,UVM_ALL_ON)
  `uvm_field_int(data,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  `uvm_component_utils_end
  
  //slave transaction class handle declaration
  spi_slave_seq_item sl_item;
  
    //wish_bone interface declaration
 // virtual wishbone_intf wish_vintf;
  
  //io_intf interface declaration
  virtual io_intf io_vintf;
  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);
    endfunction:new
  
    
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
 
if(!uvm_config_db#(bit)::get(null,"get_full_name()","tx_neg",tx_neg)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" tx_neg \"  and then access");
end
  
if(!uvm_config_db#(bit)::get(null,"get_full_name()","rx_neg",rx_neg)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \"rx_neg \"  and then access");
end

if(!uvm_config_db#(bit)::get(null,"get_full_name()","lsb",lsb)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" lsb \"  and then access");
 end
  
if(!uvm_config_db#(virtual io_intf)::get(this,"","io_vintf",this.io_vintf))
`uvm_fatal("FATAL:NO_wish_intf",$sformatf("config_db get method failed in slave driver"));
  
endfunction:build_phase
  
  

virtual task  run_phase(uvm_phase phase);
   
   
    forever begin:forever_begin
    //  wait(io_vintf.ss_pad_o==temp_ss_pad_o);
      
    if(temp_ss_pad_o == 8'hfe) begin
      @(negedge io_vintf.s_driver_mdp.ss_pad_o[0]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1110:this is the slave one selection. 
      end
  else if(temp_ss_pad_o == 8'hfd) begin
       
    @(negedge io_vintf.s_driver_mdp.ss_pad_o[1]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1101; this is the slave two selection.
      end
      
      else if(temp_ss_pad_o == 8'hfb) begin
       
       
        @(negedge io_vintf.s_driver_mdp.ss_pad_o[2]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1011; this is the slave three selection.
      end
      
      else if(temp_ss_pad_o == 8'hf7) begin
        
      
        @(negedge io_vintf.s_driver_mdp.ss_pad_o[3]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_0111; this is the slave four selection.
      end
      
      else if(temp_ss_pad_o == 8'hef) begin
        
      
        @(negedge io_vintf.s_driver_mdp.ss_pad_o[4]);//wating for the event of io_vintf.ss_pad_o == 8'b1110_1111; this is the slave five selection.
      end
      
      else if(temp_ss_pad_o == 8'hdf) begin
       
        
        @(negedge io_vintf.s_driver_mdp.ss_pad_o[5]);//wating for the event of io_vintf.ss_pad_o == 8'b1101_1111; this is the slave six selection.
      end
      else if(temp_ss_pad_o == 8'hbf) begin
     
        @(negedge io_vintf.s_driver_mdp.ss_pad_o[6]);//wating for the event of io_vintf.ss_pad_o == 8'b1011_1111; this is the slave seven selection.
      end
      else if(temp_ss_pad_o == 8'h7f) begin
      @(negedge io_vintf.s_driver_mdp.ss_pad_o[7]);//wating for the event of io_vintf.ss_pad_o == 8'b0111_1111; this is the slave eight selection.
       end
      
      //i need one condition for if ss_pad_o is ==ff 
      
`uvm_info(get_full_name(),$sformatf("\n \">>>>>DRIVER GOT THE LSB=%B, TX_NEG=%B,RX_NEG=%B<<<<<<< \" ",lsb,tx_neg,rx_neg),UVM_NONE);
      req=spi_slave_seq_item::type_id::create("req");
      seq_item_port.get_next_item(req);
      `uvm_info(get_name(),$sformatf("SLAVE DRIVER GOT REQ \n %0s",req.display),UVM_NONE);
      sl_item= new req;
      data= sl_item.miso_data;
      `uvm_info(get_name(),$sformatf(" \n DATA VALUE %b",data),UVM_NONE);
      drive();
      
      //sl_item.miso_data=data;
     seq_item_port.item_done(req);
   //  `uvm_info(get_name(),$sformatf("SLAVE DRIVER DRIVED THE STIMULS TO DUT \n %0s",req.display),UVM_NONE);

   end:forever_begin
    
  endtask:run_phase
  
  
virtual task drive();
  $display("---------------spi slave driver start time:%0t-------------",$time);
fork
//thread1 is continuously drive the miso to dut through the io_interface.
begin:thread1
forever begin:forever_begin
 //      
if(tx_neg ==0 && rx_neg == 0) begin:B1
 if(lsb ==0 ) begin:lsb_0
   b=data[127];
   data ={data[126:0],b};
   end:lsb_0
  else begin:lsb_1
   b=data[0];
   data={b,data[127:1]};
 end:lsb_1

  @(posedge io_vintf.s_driver_mdp.sclk_pad_o);
  @(negedge io_vintf.s_driver_mdp.sclk_pad_o);
io_vintf.s_driver_mdp.s_driv_cb.miso_pad_i <= b;
end:B1

//

if(tx_neg == 0 && rx_neg == 1) begin:B2

if(lsb ==0 ) begin:a1
 b=data[127];
data ={data[126:0],b};
end:a1
  
else begin:a2
 b=data[0];
 data={b,data[127:1]};
end:a2
  
@(posedge io_vintf.s_driver_mdp.sclk_pad_o);
io_vintf.s_driver_mdp.s_driv_cb.miso_pad_i <= b;
end:B2

//
if(tx_neg ==1 && rx_neg == 0) begin:B3
  if(lsb ==0 ) begin:c1
    b=data[127];
    data ={data[126:0],b};
    end:c1
  else begin:c2
     b=data[0];
   data={b,data[127:1]};
   end:c2
  @(posedge io_vintf.s_driver_mdp.sclk_pad_o);
  @(negedge io_vintf.s_driver_mdp.sclk_pad_o);
io_vintf.s_driver_mdp.s_driv_cb.miso_pad_i <= b;
  
end:B3

   if(tx_neg ==1 && rx_neg == 1) begin:B4
 
 // b=io_vintf.mosi_pad_o;
  if(lsb ==0 ) begin:e1
    b=data[127];
    data ={data[126:0],b};
   end:e1
  else begin:e2
     b=data[0];
   data={b,data[127:1]};
   end:e2

@(posedge io_vintf.s_driver_mdp.sclk_pad_o);
io_vintf.s_driver_mdp.s_driv_cb.miso_pad_i <= b;
end:B4
end:forever_begin
end:thread1
      
//this thread wait upto the ss_pad_o = 8'hff  then disable the fork
 begin:thread2
 // @(posedge io_vintf.sclk_pad_o);
   wait((io_vintf.s_driver_mdp.ss_pad_o === 8'b1111_1111)); 
 // req.miso_data=data;
sl_item.miso_data=data;
`uvm_info(get_name(),$sformatf("SLAVE DRIVER after copy DRIVED THE STIMULS TO DUT \n %b",sl_item.miso_data),UVM_NONE);
disable fork;
end:thread2
   
join
           
endtask:drive       
      
    
endclass:spi_slave_driver
        
        
        
