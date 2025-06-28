class spi_master_seq_item extends uvm_sequence_item;
 
//randomization fields
  rand bit [4:0] adr_i;
  rand bit [31:0] dat_i;
  rand bit we_i;//if wr_en==1 is write operation ,if wr_en==0 read operation
  rand bit [3:0] sel_i;
  rand bit stb_i;
  rand bit cyc_i;
  rand bit [6:0] char_len;
  rand bit lsb;
  rand bit tx_neg;
  rand bit rx_neg;
  rand bit [15:0] div;
  rand bit [7:0] ss;
  bit go_busy;
  bit ass;
  bit ie;
 // rand bit [31:0] ctrl;
  //rand bit [31:0] divider;
  
  bit [31:0] dat_o;
  bit ack_o;
  bit err_o;
  bit int_o;
 
  constraint sel_i_const{soft sel_i=='hf;}
  constraint stb_i_const{soft stb_i==1;}
  constraint cyc_i_const{soft cyc_i==1;}
  constraint wr_en_const{soft we_i==1;}  
  
  //constraint char_len_const{soft char_len inside{31,49,90,125,0};}
  constraint char_len_const{soft char_len inside{0,1,4,8,12,16,20,24,32,40,64,78,96,100,116,124,127};}
  //constraint char_len_const{soft char_len inside{0,1,127};}
  
  //constriant for the divider value
  constraint div_reg_value{div < 100 ; }
  
  function new(string name="spi_master_seq_item");
  super.new(name);             
  endfunction:new
  
  
  `uvm_object_utils_begin(spi_master_seq_item)
  `uvm_field_int(adr_i,UVM_ALL_ON)
  `uvm_field_int(dat_i,UVM_ALL_ON)
  `uvm_field_int(we_i,UVM_ALL_ON)
  `uvm_field_int(sel_i,UVM_ALL_ON)
  `uvm_field_int(stb_i,UVM_ALL_ON)
  `uvm_field_int(cyc_i,UVM_ALL_ON)
  //`uvm_field_int(ctrl,UVM_ALL_ON)
  //`uvm_field_int(divider,UVM_ALL_ON)
  `uvm_object_utils_end
  
  virtual function string display();
    $sformat(display," \n stb_i=%0b cyc_i=%0b sel_i=%0b  \n adr_i(h)=%0h  adr_i(d)=%0d we_i=%0d \n dat_i(h)=%0h dat_i(d)=%0d \n dat_i([31:28]=%b dat_i([27:24]=%b  dat_i([23:20]=%b  dat_i[19:16]=%b  dat_i([15:12]=%b  dat_i[11:8]=%b  dat_i[7:4]=%b  dat_i[3:0]=%b \n dat_o(h)=%0h dat_o(d)=%0d dat_o(b)=%b \n ------------------------------------------------------------------------------------------------------------------------------------ ",stb_i,cyc_i,sel_i,adr_i,adr_i,we_i,dat_i,dat_i,dat_i[31:28], dat_i[27:24],dat_i[23:20],dat_i[19:16],dat_i[15:12],dat_i[11:8],dat_i[7:4],dat_i[3:0],dat_o,dat_o,dat_o);
  endfunction:display
  
      
endclass:spi_master_seq_item






