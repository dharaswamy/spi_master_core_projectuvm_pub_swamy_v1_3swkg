
class spi_slave_monitor extends uvm_monitor;
  
 int unsigned temp_ss_pad_o;
 // logic temp_port_id;
 bit tx_neg;
 bit rx_neg;
 bit lsb;
  bit b;
  bit a;
 static bit [127:0] data,data1;
  int unsigned no_bits_sent;
 //factory registration
  `uvm_component_utils_begin(spi_slave_monitor)
  `uvm_field_int(tx_neg,UVM_ALL_ON)
  `uvm_field_int(lsb,UVM_ALL_ON)
  `uvm_field_int(rx_neg,UVM_ALL_ON)
  `uvm_field_int(b,UVM_ALL_ON)
  `uvm_field_int(a,UVM_ALL_ON)
  `uvm_field_int(data,UVM_ALL_ON)
  `uvm_field_int(data1,UVM_ALL_ON)
  `uvm_component_utils_end
  
  //wish_bone interface declaration
 // virtual wishbone_intf wish_vintf;
  
  //io_intf interface declaration
  virtual io_intf io_vintf;
  
  //spi_slave_seq_item handle declaration
  spi_slave_seq_item trans_collected;
  
  //anlysis port
  uvm_analysis_port #(spi_slave_seq_item) item_collected_port;

  //default constructor 
function new(string name,uvm_component parent);
    super.new(name,parent);
  item_collected_port=new("item_collected",this);
  trans_collected=new();
endfunction:new
  
  
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  
 if(!uvm_config_db#(bit)::get(null,"get_full_name()","tx_neg",tx_neg)) begin
   `uvm_fatal(get_full_name()," first set the  CONFIG DB \" tx_neg \"  and then access");
end
  
  if(!uvm_config_db#(bit)::get(null,"get_full_name()","rx_neg",rx_neg)) begin
    `uvm_fatal(get_full_name()," first set the  CONFIG DB \" rx_neg \"  and then access");
end
 
  if(!uvm_config_db#(bit)::get(null,"get_full_name()","lsb",lsb)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" lsb \"  and then access");
 end
  
if(!uvm_config_db#(virtual io_intf)::get(this,"","io_vintf",this.io_vintf))
 `uvm_fatal("FATAL:NO_wish_intf",$sformatf("config_db get method failed in slave monitor"));
  

endfunction:build_phase
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  //  `uvm_info(get_full_name(),$sformatf("\n MONITOR GOT THE LSB=%B, TX_NEG=%B,RX_NEG=%B",lsb,tx_neg,rx_neg),UVM_NONE);
    forever begin:forever_begin
      wait(io_vintf.s_mntr_mdp.ss_pad_o == 8'b1111_1111);
      if(temp_ss_pad_o == 8'hfe) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[0]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1110; this is the slave one selection.
      end
      else if(temp_ss_pad_o == 8'hfd) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[1]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1101; this is the slave two selection.
      end
      
      else if(temp_ss_pad_o == 8'hfb) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[2]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1011; this is the slave three selection.
      end
      
      else if(temp_ss_pad_o == 8'hf7) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[3]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_0111; this is the slave four selection.
      end
      
      else if(temp_ss_pad_o == 8'hef) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[4]);//wating for the event of io_vintf.ss_pad_o == 8'b1110_1111; this is the slave five selection.
      end
      
      else if(temp_ss_pad_o == 8'hdf) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[5]);//wating for the event of io_vintf.ss_pad_o == 8'b1101_1111; this is the slave six selection.
      end
      else if(temp_ss_pad_o == 8'hbf) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[6]);//wating for the event of io_vintf.ss_pad_o == 8'b1011_1111; this is the slave seven selection.
      end
      else if(temp_ss_pad_o == 8'h7f) begin
        @(negedge io_vintf.s_mntr_mdp.ss_pad_o[7]);//wating for the event of io_vintf.ss_pad_o == 8'b0111_1111; this is the slave eight selection.
      end
      $display("slave monitor start time=%0t",$time);
      recieve();
  `uvm_info(get_name(),$sformatf("SLAVE MONITOR \n %0s", trans_collected.display()),UVM_NONE);
    end:forever_begin
    
  endtask:run_phase
 
  
 virtual task recieve();
  
   
   fork
     begin:thread1
    forever begin:forever_begin
      
  if(tx_neg ==0 && rx_neg == 0) begin:M1
     trans_collected.rx_neg=this.rx_neg;
     trans_collected.lsb = this.lsb;
     
    fork  
      begin
    @(posedge io_vintf.s_mntr_mdp.sclk_pad_o); 
    b=io_vintf.s_mntr_mdp.miso_pad_i;
        end
      begin
    @(negedge io_vintf.s_mntr_mdp.sclk_pad_o); 
   //$display("slave monitor value of the io_vintf.mosi=%b mntr_if_sn_mosi=%b",io_vintf.mosi_pad_o,`MNTR_IF_SN.mosi_pad_o);
   a=io_vintf.s_mntr_mdp.mosi_pad_o;
   //b=io_vintf.miso_pad_i;
      end
    join
 
      if(lsb ==0 ) begin
   data ={data[126:0],a};
  data1 = {data1[126:0],b};
  end
  
  else begin
    data={a,data[127:1]};
    data1={b,data1[127:1]};
 end
  no_bits_sent++;
end:M1
           
         
if(tx_neg ==0 && rx_neg == 1) begin //transmission is happend at mosi at posedge and miso at negedge but we collected at posedge ok.
 trans_collected.rx_neg=this.rx_neg;
 trans_collected.lsb=this.lsb;
 // @(posedge io_vintf.s_mntr_mdp.sclk_pad_o);
  @(negedge io_vintf.s_mntr_mdp.sclk_pad_o);
      
  a=io_vintf.s_mntr_mdp.mosi_pad_o;
  b=io_vintf.s_mntr_mdp.miso_pad_i;
  
 if(lsb ==0 ) begin
   data ={data[126:0],a};
    data1={data1[126:0],b};
 end
  else begin
  data={a,data[127:1]};
  data1={b,data1[127:1]};
   end
  no_bits_sent++;
end


if(tx_neg ==1 && rx_neg == 0) begin
  trans_collected.rx_neg=this.rx_neg;
  trans_collected.lsb=this.lsb;
  
  @(posedge io_vintf.s_mntr_mdp.sclk_pad_o);
 // @(negedge io_vintf.sclk_pad_o); //previous
  b=io_vintf.s_mntr_mdp.miso_pad_i;
  a=io_vintf.s_mntr_mdp.mosi_pad_o;
 
 
   trans_collected.sclk_pad_o=1'b1;
  if(lsb ==0 ) begin
    data ={data[126:0],a};
    data1={data1[126:0],b};
  end
  else begin
    data={a,data[127:1]};
    data1={b,data1[127:1]};
  end
  no_bits_sent++;
 end
         
if(tx_neg ==1 && rx_neg == 1) begin
 // $display("when tx and rx ==1 is started  ",$time);
   trans_collected.rx_neg=this.rx_neg;
   trans_collected.lsb=this.lsb;
  fork
 begin
 
   @(posedge io_vintf.s_mntr_mdp.sclk_pad_o);
  a=io_vintf.s_mntr_mdp.mosi_pad_o;
  end
    
  begin
 //@(posedge io_vintf.sclk_pad_o);
  @(negedge io_vintf.s_mntr_mdp.sclk_pad_o); 
  b=io_vintf.s_mntr_mdp.miso_pad_i;
  end
  join
  
  if(lsb ==0 ) begin
    data ={data[126:0],a};
    data1={data1[126:0],b};
  end
  else begin
    data={a,data[127:1]};
    data1={b,data1[127:1]};
   end
  no_bits_sent++;
   end
      
    
    end:forever_begin
     end:thread1
   join_none
   
   begin
     wait(io_vintf.s_mntr_mdp.ss_pad_o == 8'b1111_1111);
     disable fork;
     trans_collected.slv_char_len = no_bits_sent;
     trans_collected.ss_pad_o=8'hff;
     //`uvm_info(get_name(),$sformatf("\n DATA=%B,\n DATA1=%B ",data,data1),UVM_NONE); //for analysis purpose
     trans_collected.mosi_data=data;
     trans_collected.miso_data=data1;
     item_collected_port.write(trans_collected);
    end
   
   
  endtask:recieve
  
  
endclass:spi_slave_monitor
       
       
   //bit rx_neg,lsb;
  //bit slv_char_len;
 