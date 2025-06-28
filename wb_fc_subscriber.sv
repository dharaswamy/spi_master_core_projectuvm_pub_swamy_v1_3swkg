class wb_fc_subscriber extends uvm_subscriber#(spi_master_seq_item);

  //factory registration
  `uvm_component_utils(wb_fc_subscriber)
  
  //uvm analysis port declaration
  uvm_analysis_imp#(spi_master_seq_item,wb_fc_subscriber) fc_collected;
  
  //transaction class handle declaration
  spi_master_seq_item wb_pkt;
  
//coverage model for the spi master.
covergroup        wb_cgp;
option.per_instance=1;
cvp_we_i:coverpoint wb_pkt.we_i {bins b_write ={1'b1};bins bin_read ={1'b0};}
cvp_adr_i:coverpoint wb_pkt.adr_i{bins adr_tx0={5'h00}; 
                                  bins adr_tx1={5'h04};
                                  bins adr_tx2={5'h08};
                                  bins adr_tx3={5'h0c}; 
                                  bins adr_ctrl={5'h10}; 
                                  bins adr_div={5'h14}; 
                                  bins adr_ss={5'h18};
                                     }
  cvp_stb:coverpoint wb_pkt.stb_i{bins stb_l0 ={1'b0};bins stb_h1={1'b1}; }
  cvp_cyc:coverpoint wb_pkt.cyc_i{bins cyc_l0 ={1'b0};bins cyc_h1 ={1'b1};}
  cvp_sel:coverpoint wb_pkt.sel_i{bins sel_h[] ={[0:15]};}
  cvp_data_in:coverpoint wb_pkt.dat_i;
  cvp_data_out:coverpoint wb_pkt.dat_o;
  cvp_ack:coverpoint  wb_pkt.ack_o;
  cvp_interrupt:coverpoint wb_pkt.int_o;
  cvp_error:coverpoint wb_pkt.err_o;
  
  //data,error,ack,int_o,dat_o,rx_0,rx_1,rx_2,rx_3

  //covering read to  rx_1,rx_2,rx_3   wb_pkt.adr_i,wb_pkt.we_i
cxp_rx_regs:cross wb_pkt.adr_i,wb_pkt.we_i{
                                        //covering reading of rx_reg0(recieve register0 of addr =8'h00 with wr_i =1'b0)
                                         bins bin_rx_reg0 = binsof(wb_pkt.adr_i) intersect{0} && binsof(wb_pkt.we_i)intersect{0};
                                        //covering reading of rx_reg1(recieve register1 with addr =8'h04)
                                         bins bin_rx_reg1 = binsof(wb_pkt.adr_i) intersect{4}  && binsof(wb_pkt.we_i)intersect{0};
                                       //covering reading of rx_reg2(recieve register2 of addr =8'h08 with wr_i =1'b0 wr_i =1'b0)
                                        bins bin_rx_reg2 = binsof(wb_pkt.adr_i) intersect{8}  && binsof(wb_pkt.we_i)intersect{0};
                                       //covering reading of rx_reg3(recieve register3 with addr =8'h0c with wr_i =1'b0)
                                       bins bin_rx_reg3 = binsof(wb_pkt.adr_i) intersect{12}  &&binsof(wb_pkt.we_i)intersect{0};
                                         }
 

//coverint writes to tx_0,tx_1,tx_2,tx_3
  cxp_tx_regs:cross wb_pkt.adr_i,wb_pkt.we_i{
    bins bin_tx_reg0 = binsof(wb_pkt.adr_i) intersect{0} && binsof(wb_pkt.we_i) intersect{1};
    bins bin_tx_reg1 = binsof(wb_pkt.adr_i) intersect{4} && binsof(wb_pkt.we_i) intersect{1};
    bins bin_tx_reg2 = binsof(wb_pkt.adr_i) intersect{8} && binsof(wb_pkt.we_i) intersect{1};
    bins bin_tx_reg3 = binsof(wb_pkt.adr_i) intersect{12} && binsof(wb_pkt.we_i) intersect{1};
  }
                                             
endgroup:wb_cgp
  
covergroup wb_ctrl;
option.per_instance=1;
cvp_lsb:coverpoint  wb_pkt.lsb{bins b_lsb[]={0,1};}
cvp_tx_neg:coverpoint wb_pkt.tx_neg{bins b_tx_neg[]={0,1};}
cvp_rx_neg:coverpoint wb_pkt.rx_neg{bins b_rx_neg[]={0,1};}
cvp_char_len:coverpoint wb_pkt.char_len{bins v_len[] ={[0:$]};}//
cvp_ass:coverpoint wb_pkt.ass{bins b_ass ={1}; bins b_ass_l ={0};}
cvp_ie:coverpoint wb_pkt.ie{bins b_ie[] ={[0:1]};}
cvp_go_busy:coverpoint wb_pkt.go_busy{bins b_busy[]={1};}
cxp_ctrl_reg:cross cvp_lsb,cvp_tx_neg,cvp_rx_neg;//sir told remove the char_len from this cxp_ctrl_reg cross.


endgroup:wb_ctrl

  covergroup wb_div;
    option.per_instance=1;
cvp_div_reg:coverpoint wb_pkt.div{bins b_div_reg[] ={[16'h0000:16'h00ff]};}  

  endgroup:wb_div
  
  covergroup wb_ss;
    
option.per_instance=1;
cvp_ss_reg:coverpoint wb_pkt.ss{bins vb_ss_reg[]={8'b0000_0001,
                                                  8'b0000_0010,
                                                  8'b0000_0100,
                                                  8'b0000_1000,
                                                  8'b0001_0000,
                                                  8'b0010_0000,
                                                  8'b0100_0000,
                                                  8'b1000_0000};}
endgroup:wb_ss
  
  //default constructo.
function new(string name,uvm_component parent);
super.new(name,parent);
  wb_cgp=new();
  wb_ctrl=new();
  wb_div=new();
  wb_ss=new();
  endfunction:new
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fc_collected = new("fc_collected",this);
  endfunction:build_phase
  
  virtual function void write(spi_master_seq_item t);
    wb_pkt=t;
  `uvm_info(get_full_name,$sformatf("\n %0s",wb_pkt.sprint()),UVM_DEBUG);
    
    if(wb_pkt.adr_i == 5'h10 && wb_pkt.we_i ==1'b1 && wb_pkt.stb_i ==1'b1 && wb_pkt.cyc_i == 1'b1 && wb_pkt.sel_i ==4'hf && (wb_pkt.dat_i[8]==1'b1))begin:b1
   wb_pkt.char_len=wb_pkt.dat_i[6:0];
    wb_pkt.go_busy=wb_pkt.dat_i[8];
    wb_pkt.rx_neg=wb_pkt.dat_i[9];
    wb_pkt.tx_neg=wb_pkt.dat_i[10];
    wb_pkt.lsb=wb_pkt.dat_i[11]; 
    wb_pkt.ie=wb_pkt.dat_i[12];
    wb_pkt.ass=wb_pkt.dat_i[13];
      wb_ctrl.sample();
    end:b1
    
    if((wb_pkt.adr_i==5'h14) && (wb_pkt.we_i==1'b1) && (wb_pkt.stb_i==1'b1) && (wb_pkt.cyc_i==1'b1) && (wb_pkt.sel_i ==4'hf) )begin:b2
    wb_pkt.div=wb_pkt.dat_i;
      wb_div.sample();
    end:b2
    
    if(wb_pkt.adr_i == 5'h18 && wb_pkt.we_i ==1'b1 && wb_pkt.stb_i ==1'b1 && wb_pkt.cyc_i == 1'b1 && wb_pkt.sel_i ==4'hf)begin:b3
      wb_pkt.ss=wb_pkt.dat_i;
      wb_ss.sample();
    end:b3
    
    
   wb_cgp.sample();
  // wb_cgp1.sample();
  endfunction:write

  
  
endclass:wb_fc_subscriber


 

// cadence tool command for coverage report:-coverage all