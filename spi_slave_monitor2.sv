`define MNTR_IF_S io_vintf.s_monitor_mdp


class spi_slave_monitor extends uvm_monitor;
  
 int unsigned temp_ss_pad_o;
 // logic temp_port_id;
 bit tx_neg;
 bit rx_neg;
 bit lsb;
  bit b;
  bit a;
 static bit [127:0] data,data1;
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
  
// if(!uvm_config_db#(virtual wishbone_intf)::get(this,"","wish_vintf",this.wish_vintf))
// `uvm_fatal("FATAL:NO_io_intf",$sformatf("config_db get method failed in slave monitor"));

endfunction:build_phase
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  //  `uvm_info(get_full_name(),$sformatf("\n MONITOR GOT THE LSB=%B, TX_NEG=%B,RX_NEG=%B",lsb,tx_neg,rx_neg),UVM_NONE);
    forever begin:forever_begin
      wait(`MNTR_IF_S.ss_pad_o == 8'b1111_1111);
  //  @(posedge io_vintf.sclk_pad_o);  
     // wait(io_vintf.ss_pad_o == temp_ss_pad_o);
     // `uvm_info(get_full_name(),$sformatf("\n \" <<<<<<SLAVE MONITOR GOT THE LSB=%B, TX_NEG=%B,RX_NEG=%B >>>>>>>\"",lsb,tx_neg,rx_neg),UVM_NONE);
    //  wait(io_vintf.ss_pad_o == 8'b1111_1110 ||io_vintf.ss_pad_o == 8'b1111_1101||io_vintf.ss_pad_o == 8'b1111_1011|| io_vintf.ss_pad_o == 8'b1111_0111 || io_vintf.ss_pad_o == 8'b1110_1111 || io_vintf.ss_pad_o == 8'b1101_1111 || io_vintf.ss_pad_o == 8'b1011_1111 || io_vintf.ss_pad_o == 8'b0111_1111);
      if(temp_ss_pad_o == 8'hfe) begin
        @(negedge `MNTR_IF_S.ss_pad_o[0]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1110; this is the slave one selection.
      end
      else if(temp_ss_pad_o == 8'hfd) begin
        @(negedge `MNTR_IF_S.ss_pad_o[1]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1101; this is the slave two selection.
      end
      
      else if(temp_ss_pad_o == 8'hfb) begin
        @(negedge `MNTR_IF_S.ss_pad_o[2]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_1011; this is the slave three selection.
      end
      
      else if(temp_ss_pad_o == 8'hf7) begin
        @(negedge `MNTR_IF_S.ss_pad_o[3]);//wating for the event of io_vintf.ss_pad_o == 8'b1111_0111; this is the slave four selection.
      end
      
      else if(temp_ss_pad_o == 8'hef) begin
        @(negedge `MNTR_IF_S.ss_pad_o[4]);//wating for the event of io_vintf.ss_pad_o == 8'b1110_1111; this is the slave five selection.
      end
      
      else if(temp_ss_pad_o == 8'hdf) begin
        @(negedge `MNTR_IF_S.ss_pad_o[5]);//wating for the event of io_vintf.ss_pad_o == 8'b1101_1111; this is the slave six selection.
      end
      else if(temp_ss_pad_o == 8'hbf) begin
        @(negedge `MNTR_IF_S.ss_pad_o[6]);//wating for the event of io_vintf.ss_pad_o == 8'b1011_1111; this is the slave seven selection.
      end
      else if(temp_ss_pad_o == 8'h7f) begin
        @(negedge `MNTR_IF_S.ss_pad_o[7]);//wating for the event of io_vintf.ss_pad_o == 8'b0111_1111; this is the slave eight selection.
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
     // >>>>>>>>>>>>>>>START HERE
  if(tx_neg ==0 && rx_neg == 0) begin:M1
   
    @(posedge io_vintf.s_monitor_mdp.sclk_pad_o); 
    b=`MNTR_IF_S.miso_pad_i;
        end
      begin
    @(negedge io_vintf.s_monitor_mdp.sclk_pad_o); 
   // @(`MNTR_IF_SN);
   a=`MNTR_IF_SN.mosi_pad_o;
   //b=io_vintf.miso_pad_i;
      
  trans_collected.sclk_pad_o=1'b1;
      if(lsb ==0 ) begin
   data ={data[126:0],a};
  data1 = {data1[126:0],b};
  end
  
  else begin
    data={a,data[127:1]};
    data1={b,data1[127:1]};
 end
end:M1
           
         
if(tx_neg ==0 && rx_neg == 1) begin //transmission is happend at mosi at posedge and miso at negedge but we collected at posedge ok.
  
  fork
    
    begin
 // @(posedge io_vintf.s_monitor_mdp.sclk_pad_o);
 // @(negedge io_vintf.s_monitor_mdp.sclk_pad_o);
  a=`MNTR_IF_SN.mosi_pad_o;
      // b=io_vintf.miso_pad_i;
    end
    
  begin
  // @(posedge io_vintf.s_monitor_mdp.sclk_pad_o);
  //@(negedge io_vintf.s_monitor_mdp.sclk_pad_o);
  b=`MNTR_IF_SN.miso_pad_i;
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
end


if(tx_neg ==1 && rx_neg == 0) begin
  fork 
    begin
    @(`MNTR_IF_SP);
  //@(posedge io_vintf.s_monitor_mdp.sclk_pad_o);
      // @(negedge io_vintf.sclk_pad_o); //previous
  b=`MNTR_IF_SP.miso_pad_i;
    end
    
    begin
        @(`MNTR_IF_SP);
     // @(posedge io_vintf.s_monitor_mdp.sclk_pad_o);
      a=`MNTR_IF_SP.mosi_pad_o;
      
    end
  join
   trans_collected.sclk_pad_o=1'b1;
  if(lsb ==0 ) begin
    data ={data[126:0],a};
    data1={data1[126:0],b};
  end
  else begin
    data={a,data[127:1]};
    data1={b,data1[127:1]};
  end
 end
         
if(tx_neg ==1 && rx_neg == 1) begin
  $display("when tx and rx ==1 is started ",$time);
  fork
 begin
  @(`MNTR_IF_SP);
  // @(posedge io_vintf.s_monitor_mdp.sclk_pad_o);
  a=`MNTR_IF_SP.mosi_pad_o;
  $display("value of a=%b",a);
  end
    
  begin
 //@(posedge io_vintf.sclk_pad_o);
  //@(negedge io_vintf.s_monitor_mdp.sclk_pad_o); //previous
    @(`MNTR_IF_SN);
   b=`MNTR_IF_SN.miso_pad_i;
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
  
   end
      
    
    end:forever_begin
     end:thread1
   join_none
   
   begin
     wait(io_vintf.s_monitor_mdp.ss_pad_o == 8'b1111_1111);
     disable fork;
     trans_collected.ss_pad_o=8'hff;
     //`uvm_info(get_name(),$sformatf("\n DATA=%B,\n DATA1=%B ",data,data1),UVM_NONE); //for analysis purpose
     trans_collected.mosi_data=data;
     trans_collected.miso_data=data1;
     item_collected_port.write(trans_collected);
    end
   
   
  endtask:recieve
  
  
endclass:spi_slave_monitor
  
 /////////////////////////////////////////////////////////////////////
       ////////////////////////////////////////////////////////////////////
        /* if(neg == 0) begin:neg_0
      @(posedge io_vintf.sclk_pad_o);
        a=io_vintf.mosi_pad_o;
        if(lsb == 0) begin:lsb_0
        data={data[126:0],a};
        end:lsb_0
        else begin:lsb_1
        data={a,data[127:1]};
        end:lsb_1
        
       @(negedge io_vintf.sclk_pad_o); //mosi will collect at posedge clk and miso also but we collect at negedge
       b=io_vintf.miso_pad_i;
       if(lsb == 0) begin:lsb_0
        data1={data1[126:0],b};
        end:lsb_0
        else begin:lsb_1
        data1={b,data1[127:1]};
         end:lsb_1
        end:neg_0
      
      
      else begin:neg_1
        @(posedge io_vintf.sclk_pad_o);
        b=io_vintf.miso_pad_i;
        if(lsb == 0) begin:lsb_0
          data1={data1[126:0],b};
        end:lsb_0
        else begin:lsb_1
        data1={b,data1[127:1]};
        end:lsb_1
        
       @(negedge io_vintf.sclk_pad_o); //mosi will collect at posedge clk and miso also but we collect at negedge
       a=io_vintf.mosi_pad_o;
       if(lsb == 0) begin:lsb_0
         data={data[126:0],a};
        end:lsb_0
        else begin:lsb_1
          data={a,data[127:1]};
         end:lsb_1
        end:neg_0
      
      end:neg_1 */
      
       
       
/*task run_phase(uvm_phase phase);

forever  begin:forever_begin
wait((io_vintf.ss_pad_o==temp_ss_pad_o) && io_vintf.sclk_pad_o);
  
fork 
  
begin:thread1
for(int i=0;i<10000;i++)begin:for_loop
@(posedge wish_vintf.wb_clk_i);
if(wish_vintf.wb_int_o==1) begin
  `uvm_info("FROM SLAVE MONITOR wb_intf_o",$sformatf(" SLAVE MONITOR VLAUE OF WB_INTF_O=%0B",wish_vintf.wb_int_o),UVM_NONE);
break;  end
end:for_loop
end:thread1

  
begin:thread2
for(int i=0;i<128;i++)begin
@(posedge io_vintf.sclk_pad_o); 
trans_collected.mosi_pad_o=new[trans_collected.mosi_pad_o.size+1](trans_collected.mosi_pad_o);
trans_collected.mosi_pad_o[trans_collected.mosi_pad_o.size()-1]=io_vintf.mosi_pad_o;
end
end:thread2 

 
join_any
disable fork;
  
  if(temp_ss_pad_o==254) begin
    temp_port_id=0;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
   
  if(temp_ss_pad_o==253) begin
    temp_port_id=1;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
   
  if(temp_ss_pad_o==251) begin
    temp_port_id=2;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
   
  if(temp_ss_pad_o==247) begin
    temp_port_id=3;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
   
  if(temp_ss_pad_o==239) begin
    temp_port_id=4;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
  
   
  if(temp_ss_pad_o==223) begin
    temp_port_id=5;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
   
  if(temp_ss_pad_o==191) begin
    temp_port_id=6;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
   
  if(temp_ss_pad_o==127) begin
    temp_port_id=7;
    `uvm_info("TEMP_PORT_ID_SPI_SLAVE",$sformatf("TEMP_SS_PAD=%0D,TEMP_PORT_ID=%0D",temp_ss_pad_o,temp_port_id),UVM_NONE);
  end
  
  
  

foreach(trans_collected.mosi_pad_o[i]) 
`uvm_info("SLAVE MONITOR ",$sformatf("array vlaues MOSI_PAD_O[%0D]=%0B",i,trans_collected.mosi_pad_o[i]),UVM_NONE);
  $display("start of slave monitor befor info %0t ",$time);
  
  `uvm_info("SLAVE MONITOR",$sformatf("\n slave monitor value ss_pad_o=%b  and mosi_pad_o=%0p ",trans_collected.ss_pad_o,trans_collected.mosi_pad_o),UVM_NONE);
  $display("start of slave monitor at after info %0t ",$time); 
  
  //sending the transaction to the scb 
  item_collected_port.write(trans_collected);
  
end:forever_begin

     
endtask:run_phase
 
       
      
  
  
endclass:spi_slave_monitor*/



 /*task run_phase(uvm_phase phase);
         forever begin
         wait(io_vintf.ss_pad_o==40);
         trans_collected.ss_pad_o=io_vintf.ss_pad_o;
         for(int i=0;i<128:i++) begin
           //if(wish_vintf.wb_int_o==1) begin
             //break;
           //end
          // else begin
         @(posedge io_vintf.sclk_pad_o);
          trans_collected.mosi_pad_o[i]=io_vintf.mosi_pad_o;
           end
         end
         `uvm_info("slave_monitor",$sformatf("\n slave monitor values ss_pad_o=%b  and mosi_pad_o=%b ",trans_collected.ss_pad_o,trans_collected.mosi_pad_o),UVM_NONE);
         end
       endtask:run_phase */
  