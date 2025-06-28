class spi_slave_base_sequence extends uvm_sequence#(spi_slave_seq_item);
  
  int repeat_count_sl_seq=1;
  
  `uvm_object_utils_begin(spi_slave_base_sequence)
  `uvm_field_int(repeat_count_sl_seq,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //default constructor
  function new(string name="spi_slave_base_sequence");
    super.new(name);
  endfunction:new
  
  
  virtual task pre_start();
super.pre_start();
    if(!uvm_config_db#(int)::get(null,"get_full_name()","repeat_count",repeat_count_sl_seq)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" repeat_count \"  and then access");
end
endtask:pre_start
  
  
  virtual task body();
    `uvm_info(get_name(),$sformatf("SL_SEQ repeat_count_sl_seq=%0d",repeat_count_sl_seq),UVM_NONE);
    repeat(repeat_count_sl_seq) begin
      `uvm_do(req)
      `uvm_info("get_name()",$sformatf("SLAVE SEQUENCE RANDOMIZED VALUES \n %S",req.display() ),UVM_NONE);
    end
    endtask:body
  
  
endclass:spi_slave_base_sequence