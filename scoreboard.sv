`uvm_analysis_imp_decl(_m_mntr)
`uvm_analysis_imp_decl(_s_mntr)

class scoreboard extends uvm_scoreboard;
 
  bit [127:0] tx_reg;
  bit [127:0] rx_reg;
  bit [31:0] ctrl_reg;
  bit [31:0] div_reg;
  bit [31:0] ss_reg;
  bit [7:0] char_len;
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
  
  virtual function void write_m_mntr(spi_master_seq_item m_trans);
    //`uvm_info(get_full_name(),$sformatf(" SCOREBOARD just printing the retreive values from master_monitor %0s", m_trans.display()),UVM_NONE);
   m_trans_qu.push_back(m_trans);
  endfunction
  
  
  virtual function void write_s_mntr(spi_slave_seq_item s_trans);
  /// `uvm_info(get_full_name(),$sformatf(" SCOREBOARD just printing the retreive values from slave_monitor %0s", s_trans.display()),UVM_NONE);
   s_trans_qu.push_back(s_trans);
  endfunction
  
  
   virtual  task run_phase(uvm_phase phase);
    spi_master_seq_item    m_pkt;
    spi_slave_seq_item     s_pkt;
   
    forever begin:begin_forever
      
    wait( m_trans_qu.size() > 0  || s_trans_qu.size() > 0 );
      
      // fork 
          
         // begin:thread1
      if(m_trans_qu.size() > 0) begin:B1
        m_pkt = m_trans_qu.pop_front();
       // fork
        write_read(m_pkt,s_pkt);
        if((ss_pad_o == 8'hff) && (m_pkt.adr_i == 5'hc)) begin
      //  if(s_pkt.sclk_pad_o == 1'b1 && && m_pkt.we_i ==1'b0 && m_pkt.adr_i == 5'hc) begin
        ctrl_logic_miso(m_pkt,s_pkt);
        ss_pad_o= 8'h00;
        end
         // begin
        
            //if(m_trans_qu.size() > 0) begin
          // if(ss_pad_o == 8'hff && m_pkt.adr_i == 12) begin
           // `uvm_info("SCORE_BOARD",$sformatf("ss_pad_o=%h",ss_pad_o),UVM_NONE);
           // ctrl_logic_miso(m_pkt,s_pkt);
           // end
        // end
         // end
        //join_any
       end:B1
         // end:thread1
      
        // begin:thread2
        if(s_trans_qu.size() > 0 ) begin:B2
        s_pkt = s_trans_qu.pop_front();
          ss_pad_o=s_pkt.ss_pad_o;
          `uvm_info("SCORE_BOARD",$sformatf("ss_pad_o=%h",s_pkt.ss_pad_o),UVM_NONE);
          if(s_pkt.sclk_pad_o == 1'b1 ) begin
            sclk_pad_o = s_pkt.sclk_pad_o;
          ctrl_logic(m_pkt,s_pkt);
          // sclk_pad_o =1'b0;
          end
         end:B2
       // end:thread2
          
    /* begin:thread3
        if(   m_trans_qu.size() > 0 ) begin:B3
    // `uvm_info("SCORE_BOARD",$sformatf("ss_pad_o=%h",s_pkt.ss_pad_o),UVM_NONE);
      if(ss_pad_o == 8'hff) begin
      ctrl_logic_miso(m_pkt,s_pkt);
        end
      end:B3
      end:thread3*/
      
        //join
    end:begin_forever
    endtask:run_phase
               
  
  virtual task write_read(spi_master_seq_item  m_pkt,spi_slave_seq_item  s_pkt);
   
   //for write operation
   if(m_pkt.we_i == 1'b1 && m_pkt.sel_i == 4'b1111 && m_pkt.stb_i==1'b1 && m_pkt.cyc_i ==1'b1) begin:write
      case (m_pkt.adr_i)
      0:begin tx_reg[31:0]=m_pkt.dat_i;
      //`uvm_info(get_full_name,$sformatf("\n TX0  %0d",tx0),UVM_NONE);
         end 
        4:tx_reg[63:32]=m_pkt.dat_i;
        8: tx_reg[95:64]=m_pkt.dat_i; 
        12: tx_reg[127:96]=m_pkt.dat_i;
        16:ctrl_reg=m_pkt.dat_i;  
        20:div_reg=m_pkt.dat_i;  
        24:ss_reg=m_pkt.dat_i; 
        default:`uvm_info("SCOREBORAD"," INVALID ADDER (WRITE) ",UVM_NONE)
      endcase
      end:write   
         
  //for read operation
if(m_pkt.we_i == 1'b0) begin:read
case (m_pkt.adr_i)
 0: begin:begin_0
 rx_reg[31:0] = m_pkt.dat_o;
if(sclk_pad_o == 1'b1) begin
if( rx_reg[31:0] == m_pkt.dat_o)
  `uvm_info(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[31:0]=%h == m_pkt.dat_o=%h",rx_reg[31:0],m_pkt.dat_o),UVM_NONE)
 else 
   `uvm_error(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[31:0]=%h != m_pkt.dat_o=%h",rx_reg[31:0],m_pkt.dat_o))
end
           
else begin:else_begin0
           
if( tx_reg[31:0] == m_pkt.dat_o)
  `uvm_info(get_full_name(),$sformatf(" READ COMPARE: tx_reg[31:0]=%h == m_pkt.dat_o=%h",tx_reg[31:0],m_pkt.dat_o),UVM_NONE)
else 
  `uvm_error(get_full_name(),$sformatf(" READ COMPARE: tx_reg[31:0]=%h != m_pkt.dat_o=%h",tx_reg[31:0],m_pkt.dat_o)) 
 end:else_begin0
               
end
               
         4: begin
           rx_reg[63:32] = m_pkt.dat_o;
           
           if(sclk_pad_o == 1'b1) begin
            if( tx_reg[63:32] == m_pkt.dat_o)
              `uvm_info(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[63:32]=%h == m_pkt.dat_o=%h",rx_reg[63:32],m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[63:32]=%h != m_pkt.dat_o=%h",rx_reg[63:32],m_pkt.dat_o))  
           end
           
           else begin:else_begin1
           
           if( tx_reg[63:32] == m_pkt.dat_o)
             `uvm_info(get_full_name(),$sformatf(" READ COMPARE: tx_reg[63:32]=%h == m_pkt.dat_o=%h",tx_reg[63:32],m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE: tx_reg[63:32]=%h != m_pkt.dat_o=%h",tx_reg[63:32],m_pkt.dat_o)) 
          end:else_begin1
               end
               
               
               8: begin
                 rx_reg[95:64] = m_pkt.dat_o;
                  
           if(sclk_pad_o == 1'b1) begin
             if( rx_reg[95:64] == m_pkt.dat_o)
               `uvm_info(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[95:64]=%h == m_pkt.dat_o=%h",rx_reg[95:64],m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE AFTER TRANSACTION: rx_reg[95:64]=%h != m_pkt.dat_o=%h",rx_reg[95:64],m_pkt.dat_o))  
           end
                 else begin:else_begin2
                if( tx_reg[95:64] == m_pkt.dat_o)
                  `uvm_info(get_full_name(),$sformatf(" READ COMPARE: tx_reg[95:64]=%h == m_pkt.dat_o=%h",tx_reg[95:64],m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE: tx_reg[95:64]=%h != m_pkt.dat_o=%h",tx_reg[95:64],m_pkt.dat_o))  
           end:else_begin2
               end
     
               
    12: begin
      rx_reg[127:96] = m_pkt.dat_o;
      if(sclk_pad_o == 1'b1) begin
        sclk_pad_o =1'b0;
        if( rx_reg[127:96] == m_pkt.dat_o)
          `uvm_info(get_full_name(),$sformatf(" READ AFTER TRANSACTION: rx_reg[127:96]=%h == m_pkt.dat_o=%h",rx_reg[127:96],m_pkt.dat_o),UVM_NONE)
   else 
     `uvm_error(get_full_name(),$sformatf(" READ AFTER TRANSACTION : rx_reg[127:96]=%h != m_pkt.dat_o=%h",rx_reg[127:96],m_pkt.dat_o))
      end
      
      else begin:else_begin3
     if( tx_reg[127:96] == m_pkt.dat_o)
       `uvm_info(get_full_name(),$sformatf(" READ COMPARE: tx_reg[127:96]=%h == m_pkt.dat_o=%h",tx_reg[127:96],m_pkt.dat_o),UVM_NONE)
   else 
     `uvm_error(get_full_name(),$sformatf(" READ COMPARE: tx_reg[127:96]=%h != m_pkt.dat_o=%h",tx_reg[127:96],m_pkt.dat_o)) 
     end:else_begin3
     
     end
               16: begin
                 
                 if( ctrl_reg == m_pkt.dat_o)
                   `uvm_info(get_full_name(),$sformatf(" READ COMPARE: ctrl_reg=%0d == m_pkt.dat_o=%0d",ctrl_reg,m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE: ctrl=%0d != m_pkt.dat_o=%0d",ctrl_reg,m_pkt.dat_o)) 
           end
               20: begin
                 if( div_reg == m_pkt.dat_o)
                   `uvm_info(get_full_name(),$sformatf(" READ COMPARE: div_reg=%0d == m_pkt.dat_o=%0d",div_reg,m_pkt.dat_o),UVM_NONE)
             else 
               `uvm_error(get_full_name(),$sformatf(" READ COMPARE: div_reg=%0d != m_pkt.dat_o=%0d",div_reg,m_pkt.dat_o)) 
           end
               24: begin
               if( ss_reg == m_pkt.dat_o)
                 `uvm_info(get_full_name(),$sformatf(" READ COMPARE: ss_reg=%0d == m_pkt.dat_o=%0d",ss_reg,m_pkt.dat_o),UVM_NONE)
               else 
                 `uvm_error(get_full_name(),$sformatf(" READ COMPARE: ss_reg=%0d != m_pkt.dat_o=%0d",ss_reg,m_pkt.dat_o)) 
           end
               default:`uvm_info("SCOREBORAD","  INVALID ADDER  (READ) ",UVM_NONE)
        endcase 
      end:read
           
    
           
 endtask:write_read 
                 
                 
                 
                 
           
         
  
      
               
task ctrl_logic(spi_master_seq_item  m_pkt,spi_slave_seq_item  s_pkt);
                 
if(m_pkt.dat_i[8]==1'b1 &&  m_pkt.dat_i[13] == 1'b1) begin:begin_ctlr
  
//if the lsb is zero 
  if(m_pkt.dat_i[11]== 1'b0) begin:lsb0_scb //msb transfor
if(m_pkt.dat_i[6:0] == 7'b0000_000 ) begin
char_len = 128;
end
else begin
char_len=m_pkt.dat_i[6:0];
end
`uvm_info(get_full_name(),$sformatf("SCOREBOARD LSB=%B, CHAR_LEN=%D",m_pkt.dat_i[11],m_pkt.dat_i[6:0]),UVM_NONE); 
  //fork
    begin:mosi_comp_0
      for(int i=0;i<char_len-1;i++) begin:for1
  if(tx_reg[i] == s_pkt.mosi_data[i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%0b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[i]),UVM_NONE);
  end
else  `uvm_error(get_full_name(),$sformatf("\n \"TEST FAILED \" I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[i]));
end:for1
 end:mosi_comp_0
    /*begin:miso_comp_0
    for(int i=0;i<char_len;i++) begin:for2
      if(rx_reg[i] == s_pkt.miso_data[i]) begin
        `uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE RX_REG[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%0b  ",i,i,tx_reg[i],i,s_pkt.miso_data[i]),UVM_NONE);
  end
      else  `uvm_error(get_full_name(),$sformatf("\n \"TEST FAILED \" I=%0d EXPECTED VALUE RX_REG[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%b  ",i,i,rx_reg[i],i,s_pkt.miso_data[i]));
end:for2
end:miso_comp_0*/
  //join
end:lsb0_scb
          
//if lsb bit is one or high                   
if(m_pkt.dat_i[11]== 1'b1) begin:lsb1_scb //lsb transfor
if(m_pkt.dat_i[6:0] == 7'b0000_000 ) begin
char_len = 128;
end
else begin
char_len=m_pkt.dat_i[6:0];
end
`uvm_info(get_full_name(),$sformatf("SCOREBOARD LSB=%B, CHAR_LEN=%D",m_pkt.dat_i[11],m_pkt.dat_i[6:0]),UVM_NONE); 
  //fork
    
 begin:mosi_comp_1
 for(int i=1;i<char_len;i++) begin:for3
  if(tx_reg[i]== s_pkt.mosi_data[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%0b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[128-char_len+i]),UVM_NONE)
  end
 else
`uvm_error(get_full_name(),$sformatf("\n \" TEST FAILED \" I=%0d EXPECTED VALUE TX_REG[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%b  ",i,i,tx_reg[i],i,s_pkt.mosi_data[128-char_len+i]))
end:for3
end:mosi_comp_1
   
/*begin:miso_comp_1
for(int i=0;i<char_len;i++) begin:for4
if(rx_reg[i]== s_pkt.miso_data[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE rx_reg[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%0b  ",i,i,rx_reg[i],i,s_pkt.miso_data[128-char_len+i]),UVM_NONE)
end
else
`uvm_error(get_full_name(),$sformatf("\n \" TEST FAILED \" I=%0d EXPECTED VALUE rx_reg[%0D]=%B ACTUAL VALUE MOSI_DATA[%0d]=%b  ",i,i,rx_reg[i],i,s_pkt.miso_data[128-char_len+i]))
end:for4
end:miso_comp_1  */
  
   //join
end:lsb1_scb
                                
end:begin_ctlr
endtask:ctrl_logic
  
 
//task for the comparing logic for the miso with recieve registers
virtual task  ctrl_logic_miso(spi_master_seq_item  m_pkt,spi_slave_seq_item  s_pkt);
 
  if(ctrl_reg[8]==1'b1 &&  ctrl_reg[13] == 1'b1) begin:begin_ctrl_miso
  
//if the lsb is zero 
if(ctrl_reg[11]== 1'b0) begin:lsb0_scb //lsb transfor
if(ctrl_reg[6:0] == 7'b0000_000 ) begin
char_len = 128;
end
else begin
char_len=ctrl_reg[6:0];
end
  `uvm_info(get_full_name(),$sformatf("SCOREBOARD MISO LSB=%B, CHAR_LEN=%D",ctrl_reg[11],ctrl_reg[6:0]),UVM_NONE); 
 
begin:miso_comp_0
  for(int i=1;i<char_len;i++) begin:for2
    if(rx_reg[i] == s_pkt.miso_data[i-1]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE RX_REG[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%0b  ",i,i,rx_reg[i],i-1,s_pkt.miso_data[i-1]),UVM_NONE);
  end
else  `uvm_error(get_full_name(),$sformatf("\n \"TEST FAILED \" I=%0d EXPECTED VALUE RX_REG[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%b  ",i,i,rx_reg[i],i-1,s_pkt.miso_data[i-1]));
end:for2
end:miso_comp_0
 
end:lsb0_scb
          
//if lsb bit is one or high                   
if( ctrl_reg[11]== 1'b1) begin:lsb1_scb //lsb transfor
if(ctrl_reg[6:0] == 7'b0000_000 ) begin
char_len = 128;
end
else begin
char_len=ctrl_reg[6:0];
end
`uvm_info(get_full_name(),$sformatf("SCOREBOARD LSB=%B, CHAR_LEN=%D",ctrl_reg[11],ctrl_reg[6:0]),UVM_NONE); 
  
begin:miso_comp_1
for(int i=0;i<char_len;i++) begin:for4
if(rx_reg[i]== s_pkt.miso_data[128-char_len+i]) begin
`uvm_info(get_full_name(),$sformatf("\n TEST PASSED I=%0d EXPECTED VALUE rx_reg[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%0b  ",i,i,rx_reg[i],i,s_pkt.miso_data[128-char_len+i]),UVM_NONE)
end
else
`uvm_error(get_full_name(),$sformatf("\n \" TEST FAILED \" I=%0d EXPECTED VALUE rx_reg[%0D]=%B ACTUAL VALUE MISO_DATA[%0d]=%b  ",i,i,rx_reg[i],i,s_pkt.miso_data[128-char_len+i]))
end:for4
end:miso_comp_1
end:lsb1_scb
  
end:begin_ctrl_miso
  
endtask:ctrl_logic_miso

         
  
endclass:scoreboard