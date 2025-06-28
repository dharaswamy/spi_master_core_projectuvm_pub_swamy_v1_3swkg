class slave_fc_subscriber extends uvm_subscriber#(spi_slave_seq_item);
 
//factory registration
`uvm_component_utils(slave_fc_subscriber)
  
  uvm_analysis_imp#(spi_slave_seq_item,slave_fc_subscriber) slv_item_collected;
  
spi_slave_seq_item  slv_pkt;
  
//temporary variable.
//int slave_char_len;
  
//coverage model for the spi slave
covergroup  slave_cgp();
option.per_instance=1;
  ss_pad_o_covp:coverpoint slv_pkt.ss_pad_o{bins vd_bins_ss_pad_o[]={ 8'b1111_1110,
                                                                      8'b1111_1101,
                                                                      8'b1111_1011,
                                                                      8'b1111_0111,
                                                                      8'b1110_1111,
                                                                      8'b1101_1111,
                                                                      8'b1011_1111,
                                                                     8'b0111_1111};}
slv_rx_neg_covp:coverpoint slv_pkt.rx_neg;
slv_lsb_covp:coverpoint slv_pkt.lsb;
//cross cover the rx_neg,lsb,ss_pad_o
slv_ss_pad_lsb_rx_neg_cross:cross ss_pad_o_covp,slv_rx_neg_covp,slv_lsb_covp;
  
slv_char_len_covp:coverpoint slv_pkt.slv_char_len;
miso_data_covp: coverpoint slv_pkt.miso_data;
mosi_data_covp:coverpoint slv_pkt.mosi_data;

endgroup:slave_cgp
  
  
//default constructor.
function new(string name,uvm_component parent);
super.new(name,parent);
slv_item_collected =new("item_slv_collected",this);
  slave_cgp=new();
endfunction:new
  
//write function for collecting the samples from the slave monitor.
  
virtual function void write(spi_slave_seq_item t);
slv_pkt=t;
`uvm_info(get_name(),$sformatf(" %0s ",slv_pkt.sprint()),UVM_NONE);
 endfunction:write
  
  
endclass:slave_fc_subscriber