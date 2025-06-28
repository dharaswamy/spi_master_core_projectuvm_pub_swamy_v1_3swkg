class spi_slave_seq_item extends uvm_sequence_item;

  
  rand bit [127:0] miso_data; //data
 
  bit [127:0] mosi_data;  //data1
  bit  miso_pad_i;
  bit mosi_pad_o;
  bit [7:0] ss_pad_o;
  bit sclk_pad_o;
  
  bit rx_neg,lsb;
  bit [8:0] slv_char_len;
//  constraint miso_pad_i_const{soft miso_pad_i.size()==128;}
  
  //default constructor
  function new(string name="spi_slave_seq_item");
    super.new(name);
   endfunction:new
  
  //factory registration
  `uvm_object_utils_begin(spi_slave_seq_item)
  `uvm_field_int(miso_pad_i,UVM_ALL_ON)
  `uvm_field_int(mosi_pad_o,UVM_ALL_ON)
  `uvm_field_int(miso_data,UVM_ALL_ON)
  `uvm_field_int(mosi_data,UVM_ALL_ON)
  `uvm_field_int(rx_neg,UVM_ALL_ON)
  `uvm_field_int(lsb,UVM_ALL_ON)
  `uvm_field_int(slv_char_len,UVM_ALL_ON)
  `uvm_object_utils_end
  
  
  virtual function  string display();
    $sformat(display,"\n mosi_data=%b \n miso_data=%b \n lsb=%b rx_neg=%b slv_char_len=%0d ",mosi_data,miso_data,lsb,rx_neg,slv_char_len);
  endfunction:display
  
  
  
endclass:spi_slave_seq_item