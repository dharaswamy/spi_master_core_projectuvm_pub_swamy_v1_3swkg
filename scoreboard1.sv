
`uvm_analysis_imp_decl(_m_mntr)
`uvm_analysis_imp_decl(_s_mntr)

class scoreboard extends uvm_scoreboard;
 
  bit [127:0] tx_reg;
  bit [127:0] rx_reg;
  bit [31:0] ctrl_reg;
  bit [31:0] div_reg;
  bit [31:0] ss_reg;
  bit [7:0] char_len,char_len1,t_char_len;
  int  j;
  bit [7:0] ss_pad_o;
  bit sclk_pad_o;
  
  
//factory registration
`uvm_component_utils(scoreboard)
 
  //Declare and Create TLM Analysis port, ( to receive transaction pkt from Monitor),
  
  uvm_analysis_imp_m_mntr #(spi_master_seq_item,scoreboard) m_mntr2scb;
  uvm_analysis_imp_s_mntr #(spi_slave_seq_item,scoreboard) s_mntr2scb;
  
  //master transaction class queue
  spi_master_seq_item   m_trans_qu[$];
  //slave transaction class queqe
  spi_slave_seq_item    s_trans_qu[$];

  
  //default constructor
  function new(string name,uvm_component parent);
    super.new(name,parent);  
    m_mntr2scb=new("m_mntr2scb",this);//we are creating or allocating the memory for the implemention ports
    s_mntr2scb=new("s_mntr2scb",this);//we are creating or allocating the memory for the implemention ports
    tx_reg=128'h0000_0000_0000_0000_0000_0000_0000_0000;
    rx_reg=128'h0000_0000_0000_0000_0000_0000_0000_0000;
    ctrl_reg=32'h0000_0000;
    div_reg=32'h0000_0000;
    ss_reg=32'h0000_0000;
  endfunction:new
  
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction:build_phase
  
//write method for the master monitor. 
virtual function void write_m_mntr(spi_master_seq_item m_trans);
 spi_master_seq_item    m_pkt;
`uvm_info(get_full_name(),$sformatf(" SCOREBOARD just printing the retreive values from master_monitor \n %0s", m_trans.display()),UVM_NONE);
 m_pkt=m_trans;
  write_read(m_pkt);
  endfunction
  
  //write method for the slave monitor.
  //in this write method i am comparing the mosi with tx_reg data.and miso is stored in rx_reg.
  virtual function void write_s_mntr(spi_slave_seq_item s_trans);
  `uvm_info(get_full_name(),$sformatf(" SCOREBOARD just printing the retreive values from slave_monitor %0s", s_trans.display()),UVM_NONE);
 rx_reg[127:0] = s_trans.miso_data;
   ctrl_logic(s_trans);
  endfunction
  
  

  
virtual function void write_read(spi_master_seq_item  m_pkt);
//for write operation
if(m_pkt.we_i == 1'b1 && m_pkt.sel_i == 4'b1111 && m_pkt.stb_i==1'b1 && m_pkt.cyc_i ==1'b1) begin:write
case (m_pkt.adr_i)
0:begin tx_reg[31:0]=m_pkt.dat_i;
  `uvm_info(get_full_name,$sformatf("\n WRITE IN TO THE TX0  %0d",tx_reg[31:0]),UVM_DEBUG);
end 
4:tx_reg[63:32]=m_pkt.dat_i;
8: tx_reg[95:64]=m_pkt.dat_i; 
12: tx_reg[127:96]=m_pkt.dat_i;
16:begin
ctrl_reg=m_pkt.dat_i; 
char_len=ctrl_reg[6:0];
end
20:div_reg=m_pkt.dat_i;  
24:ss_reg=m_pkt.dat_i; 
default:`uvm_info("SCOREBORAD"," INVALID ADDER (WRITE) ",UVM_NONE)
endcase
end:write   
         
  //for read operation
if(m_pkt.we_i == 1'b0 && m_pkt.stb_i==1'b1 && m_pkt.cyc_i ==1'b1) begin:read
  
case (m_pkt.adr_i)
0: begin:begin_0
//tx_reg[31:0] = m_pkt.dat_o;
if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctrl_miso
tx_reg[31:0] = m_pkt.dat_o;
if(char_len >32) 
t_char_len=32;
else t_char_len=char_len;
//if the lsb is zero 
if(ctrl_reg[11]== 1'b0) begin:lsb0_scb0 //msb transfor
for(int i=1;i<t_char_len;i++) begin:for1
if(m_pkt.dat_o[i] == rx_reg[i]) begin
`uvm_info(get_full_name(),$sformatf("\nLSB=0 MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[i],i,m_pkt.dat_o[i]),UVM_NONE);
end
else  `uvm_error(get_full_name(),$sformatf("\n LSB=0 \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[i],i,m_pkt.dat_o[i])); 
end:for1
end:lsb0_scb0  
  
//past here
 if(ctrl_reg[11]== 1'b1) begin:lsb1_scb0 //lsb transfor 
for(int i=1;i<t_char_len;i++) begin:for2
if(m_pkt.dat_o[i]== rx_reg[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[128-char_len+i],i,m_pkt.dat_o[i]),UVM_NONE);
end
else
`uvm_error(get_full_name(),$sformatf("\n \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[128-char_len+i],i,m_pkt.dat_o[i]));
end:for2
end:lsb1_scb0  
end:begin_ctrl_miso
end:begin_0

  //paste here
4: begin:begin_1
//tx_reg[63:32] = m_pkt.dat_o;
if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctrl_miso1
tx_reg[63:32] = m_pkt.dat_o;
if(char_len >32) begin:char_gr
t_char_len=char_len-32;
if(t_char_len>32)
t_char_len=32;
  
//if the lsb is zero 
if(ctrl_reg[11]== 1'b0) begin:lsb0_scb2 //msb transfor
for(int i=32;i<t_char_len+32;i++) begin:for3
if(m_pkt.dat_o[i-32] == rx_reg[i]) begin
`uvm_info(get_full_name(),$sformatf("\nLSB=0 MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[i],i-32,m_pkt.dat_o[i-32]),UVM_NONE);
end
else  `uvm_error(get_full_name(),$sformatf("\n LSB=0 \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[i],i-32,m_pkt.dat_o[i-32])); 
end:for3
end:lsb0_scb2
  
if(ctrl_reg[11]== 1'b1) begin:lsb1_scb2 //lsb transfor 
for(int i=32;i<t_char_len+32;i++) begin:for4
if(m_pkt.dat_o[i-32]== rx_reg[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[128-char_len+i],i-32,m_pkt.dat_o[i-32]),UVM_NONE);
end
else
`uvm_error(get_full_name(),$sformatf("\n \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[128-char_len+i],i-32,m_pkt.dat_o[i-32]));
end:for4
end:lsb1_scb2
end:char_gr
  
end:begin_ctrl_miso1

end:begin_1
               
               
8: begin:begin_2
//m_pkt.dat_o[95:64] = m_pkt.dat_o;
if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctrl_miso2
tx_reg[95:64] = m_pkt.dat_o;
if(char_len >64) begin:char_gr2
t_char_len=char_len-64;
    if(t_char_len>32)
      t_char_len=32;
//if the lsb is zero 
if(ctrl_reg[11]== 1'b0) begin:lsb0_scb3 //msb transfor
for(int i=64;i<t_char_len+64;i++) begin:for5
  if(m_pkt.dat_o[i-64] == rx_reg[i]) begin
`uvm_info(get_full_name(),$sformatf("\nLSB=0 MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[i],i-64,m_pkt.dat_o[i-64]),UVM_NONE);
end
else  `uvm_error(get_full_name(),$sformatf("\n LSB=0 \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[i],i-64,m_pkt.dat_o[i-64])); 
end:for5
end:lsb0_scb3
  
if(ctrl_reg[11]== 1'b1) begin:lsb1_scb3 //lsb transfor 
  for(int i=64;i<t_char_len+64;i++) begin:for6
    if(m_pkt.dat_o[i-64]== rx_reg[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[128-char_len+i],i-64,m_pkt.dat_o[i-64]),UVM_NONE);
end
else
`uvm_error(get_full_name(),$sformatf("\n \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[128-char_len+i],i-64,m_pkt.dat_o[i-64]));
end:for6
end:lsb1_scb3
  
end:char_gr2
end:begin_ctrl_miso2                  
end:begin_2
     
               
12: begin:begin_3
  
//m_pkt.dat_o[127:96] = m_pkt.dat_o;
  
if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctrl_miso3
tx_reg[127:96] = m_pkt.dat_o;  
if(char_len >96) begin:char_gr3
t_char_len=char_len-96;

//if the lsb is zero 
if(ctrl_reg[11]== 1'b0) begin:lsb0_scb4 //msb transfor
for(int i=96;i<t_char_len+96;i++) begin:for6
 if(m_pkt.dat_o[i-96] == rx_reg[i]) begin
`uvm_info(get_full_name(),$sformatf("\nLSB=0 MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[i],i-96,m_pkt.dat_o[i-96]),UVM_NONE);
end
else  `uvm_error(get_full_name(),$sformatf("\n LSB=0 \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[i],i-96,m_pkt.dat_o[i-96])); 
end:for6
end:lsb0_scb4
  
if(ctrl_reg[11]== 1'b1) begin:lsb1_scb4 //lsb transfor 
  for(int i=96;i<t_char_len+96;i++) begin:for7
    if(m_pkt.dat_o[i-96]== rx_reg[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n MISO TEST PASSED I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%0b  ",i,i,rx_reg[128-char_len+i],i-96,m_pkt.dat_o[i-96]),UVM_NONE);
end
else
`uvm_error(get_full_name(),$sformatf("\n \" MISO TEST FAILED \" I=%0d EXPECTED VALUE MISO_DATA[%0D]=%B ACTUAL VALUE m_pkt.dat_o[%0d]=%b  ",i,i,rx_reg[128-char_len+i],i-96,m_pkt.dat_o[i-96]));
end:for7
end:lsb1_scb4

end:char_gr3
end:begin_ctrl_miso3
end:begin_3

  
default:`uvm_info("SCOREBORAD","  INVALID ADDER  (READ) ",UVM_NONE)
endcase 
end:read
endfunction:write_read 
                  
                  
function void  ctrl_logic(spi_slave_seq_item  s_pkt);                
                 
if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctlr
  
//if the lsb is zero 
  if(ctrl_reg[11]== 1'b0) begin:lsb0_scb_mosi //msb transfor
  if(ctrl_reg[6:0] == 7'b0000_000 ) begin
char_len1 = 128;
end
else begin
char_len1=ctrl_reg[6:0];
end
`uvm_info(get_full_name(),$sformatf("SCOREBOARD LSB=%B, CHAR_LEN=%D",ctrl_reg[11],ctrl_reg[6:0]),UVM_NONE); 
  //fork
    begin:mosi_comp_0
      for(int i=0;i<char_len1-1;i++) begin:for1_mosi
  if(tx_reg[i] == s_pkt.mosi_data[i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%0b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[i]),UVM_NONE);
  end
else  `uvm_error(get_full_name(),$sformatf("\n \"TEST FAILED \" I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[i]));
end:for1_mosi
end:mosi_comp_0
end:lsb0_scb_mosi
          
//if lsb bit is one or high                   
  if(ctrl_reg[11]== 1'b1) begin:lsb1_scb_mosi //lsb transfor
    if(ctrl_reg[6:0] == 7'b0000_000 ) begin
char_len1 = 128;
end
else begin
char_len1=ctrl_reg[6:0];
end
    `uvm_info(get_full_name(),$sformatf("SCOREBOARD LSB=%B, CHAR_LEN=%D",ctrl_reg[11],ctrl_reg[6:0]),UVM_NONE); 
  //fork
    
 begin:mosi_comp_1
   for(int i=1;i<char_len1;i++) begin:for3_mosi
     if(tx_reg[i]== s_pkt.mosi_data[128-char_len1+i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%0b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[128-char_len1+i]),UVM_NONE)
  end
 else
`uvm_error(get_full_name(),$sformatf("\n \" TEST FAILED \" I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[128-char_len1+i]))
end:for3_mosi
end:mosi_comp_1
   

end:lsb1_scb_mosi
                                
end:begin_ctlr
endfunction:ctrl_logic
 
endclass:scoreboard
  