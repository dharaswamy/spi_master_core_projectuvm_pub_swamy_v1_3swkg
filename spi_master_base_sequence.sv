class spi_master_base_sequence extends uvm_sequence#(spi_master_seq_item);
  
  //factory registration
  `uvm_object_utils(spi_master_base_sequence);
  
  //static bit ctrl_temp;
  
 // virtual wishbone_intf wish_vintf;
  
  //default construction
  function new(string name="spi_master_base_sequence");
    super.new(name);
  endfunction:new
  

  //body task
  virtual task body();
    `uvm_do_with(req,{req.adr_i=='h0;})
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=h0  %0S",req.display),UVM_NONE);
    `uvm_do_with(req,{req.adr_i=='h4;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=h4  %0S",req.display),UVM_NONE);
    `uvm_do_with(req,{req.adr_i=='h8;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=h8 %0S",req.display),UVM_NONE);
    `uvm_do_with(req,{req.adr_i=='hc;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=hc %0S",req.display),UVM_NONE);
    //  configure control registers with go_Busy==0; `uvm_do_with(req,{});
   //`uvm_do_with(req,{req.adr_i=='h10;req.dat_i[8]==0;req.dat_i[10:9]==2'b00;req.dat_i[11]==1'b1;});
   // `uvm_info("spi_master_base_seq",$sformatf("\n RANDOMIZATION WITH ADDR(hexa)=h10 with GO_BUSY==0 \n %0S",req.sprint()),UVM_NONE);
    //ctrl_temp=req.dat_i;
    // configure ss register `uvm_do_with(req,{req.addr=='h18,we==1};) 
    `uvm_do_with(req,{req.adr_i=='h14;req.dat_i==4;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=h14  %0S",req.display),UVM_NONE);
    //configure ss reginster
   // `uvm_do_with(req,{req.adr_i=='h18;req.dat_i inside{1,2,4,8,16,32,64,128};});
    `uvm_do_with(req,{req.adr_i=='h18;req.dat_i==1;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=hc  %0S",req.display),UVM_NONE);
    //configure ctrl register with go_busy==1
    `uvm_do_with(req,{req.adr_i=='h10;req.dat_i[8]==1;req.dat_i[10:9]==2'b00;req.dat_i[11]==1'b1;req.dat_i[6:0]==5;req.dat_i[12]==1'b1;req.dat_i[13]==1;});
    `uvm_info("spi_master_base_seq",$sformatf("RANDOMIZATION WITH ADDR(hexa)=h10  %0S",req.display),UVM_NONE);
    
    
    endtask:body
  
endclass:spi_master_base_sequence


///////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

//Sequence:For configuring the tx registers

class transfor_sequ extends uvm_sequence #(spi_master_seq_item);

  `uvm_object_utils(transfor_sequ)
  
  //default constructor
  function new(string name="transfor_sequ");
    super.new(name);
endfunction:new
  
             virtual  task body();
               `uvm_info(get_full_name(),"\n >>>>>>TX CONFIGARATION IS STARTED<<<<<<  [transfor_seq]",UVM_NONE);
            
               `uvm_do_with(req,{req.adr_i=='h0;req.dat_i == 32'h5357_e547;})
              //`uvm_info(get_full_name(),$sformatf(" writting the TX0 Register \n %0S",req.display),UVM_DEBUG);
             `uvm_info("get_full_name",$sformatf(" writting the TX1 Register \n  %0S",req.display),UVM_DEBUG);
             
             `uvm_do_with(req,{req.adr_i=='h4;});
             // `uvm_info(get_full_name(),$sformatf(" writting the TX2 Register \n %0S",req.display),UVM_NONE);
             `uvm_do_with(req,{req.adr_i=='h8;});
              // `uvm_info(get_full_name(),$sformatf(" writting the TX3 Register  \n %0S",req.display),UVM_NONE);
             `uvm_do_with(req,{req.adr_i=='hc;});
               `uvm_info(get_full_name()," \n TX REGISTERS CONFIGARATION IS COMPLETED",UVM_NONE);
             endtask:body
  
endclass:transfor_sequ
////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
                       
class divider_sequ extends uvm_sequence#(spi_master_seq_item);

  `uvm_object_utils(divider_sequ)
  
  //static bit [7:0] div_freq=1;
  function new(string name="divider_sequ");
    super.new(name);
  endfunction:new
  
virtual  task body();
  
  `uvm_info(get_full_name()," \n DIVIDER REGISTER CONFIGARATION IS STARTED ",UVM_NONE);
 // `uvm_do_with(req,{req.adr_i=='h14;req.dat_i== div ; div ==div_freq;});  
  `uvm_do_with(req,{req.adr_i == 'h14;req.dat_i == div;})
  `uvm_info(get_full_name()," \n DIVIDER REGISTER CONFIGARATION IS COMPLETED " ,UVM_NONE);
//   if(div_freq==255) begin
//    div_freq = 1; 
//   end
//   div_freq++;
  
endtask:body
            
endclass:divider_sequ
///////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

class slave_select_sequ extends uvm_sequence#(spi_master_seq_item);
  `uvm_object_utils(slave_select_sequ);
  
  function new(string name="slave_select_sequ");
    super.new(name);
  endfunction:new
  
 

  virtual task body();
    static bit [7:0]ss_reg=8'b0000_0001;
   // static bit [7:0]ss_reg=8'b0000_1000;
   req=spi_master_seq_item::type_id::create("req");
    start_item(req);
    `uvm_info(get_name(),"\n SS(slave select ) REGISTER CONFIGARATION IS STARTED ",UVM_NONE);
    req.randomize() with{adr_i==5'h18;ss==ss_reg;dat_i==ss;};
    finish_item(req);
   `uvm_info(get_name(),"\nSS(slave select) REGISTER CONFIGARATION IS COMPLETED " ,UVM_NONE);
   //ss_reg=ss_reg<<1;//left shifting by 1 bit
  endtask:body
  
endclass:slave_select_sequ

            
            
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
class ctrl_sequ extends uvm_sequence#(spi_master_seq_item);

  bit tx_neg_s;
  bit rx_neg_s;
  bit lsb_s;
  bit a;
  bit b;
  
   divider_sequ  div_sequ;//SEQUNCE FOR THE CONFIGURING THE  DIVIDER REGISTER
   slave_select_sequ ss_sequ;
  
  spi_master_seq_item trans;
  `uvm_object_utils_begin(ctrl_sequ)
  `uvm_field_int(tx_neg_s,UVM_ALL_ON +UVM_BIN)
  `uvm_field_int(rx_neg_s,UVM_ALL_ON +UVM_BIN)
  `uvm_field_int(lsb_s,UVM_ALL_ON +UVM_BIN)
  `uvm_object_utils_end
  
  function new(string name="ctrl_sequ");
    super.new(name);
  endfunction:new
  
  //pre_start task for get the configdb
virtual task pre_start();
super.pre_start();
 // if(!uvm_config_db#(bit)::get(null,"","neg",this.neg))begin
  if(!uvm_config_db#(bit)::get(null,"get_full_name()","tx_neg",tx_neg_s)) begin
    `uvm_fatal(get_full_name()," first set the  CONFIG DB \" tx_neg \"  and then access");
end
  
  if(!uvm_config_db#(bit)::get(null,"get_full_name()","rx_neg",rx_neg_s)) begin
    `uvm_fatal(get_full_name()," first set the  CONFIG DB \" rx_neg \"  and then access");
end
  
 // if(!uvm_config_db#(bit)::get(null,"","lsb",this.lsb)) begin
  if(!uvm_config_db#(bit)::get(null,"get_full_name()","lsb",lsb_s)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" lsb \"  and then access");
end
    
endtask:pre_start
  
  
  
virtual  task body();
  bit [31:0] temp_ctrl;
//REQ req_item; //REQ is parameterized type for requests
//RSP rsp_item; //RSP is parameterized type for responses
  `uvm_info(get_full_name(),"\n CTRL(contor) REGISTER CONFIGARATION IS STARTD WITH GO_BUSY=0  ",UVM_NONE);
  req = spi_master_seq_item::type_id::create("req");
  //  wait_for_grant();
  start_item(req);
  
  req.randomize() with{req.lsb == lsb_s;req.adr_i=='h10;req.dat_i[13] == 1'b1; req.dat_i[12] == 1'b1; req.dat_i[11] == req.lsb; req.dat_i[10] == tx_neg_s; req.dat_i[9] == rx_neg_s; req.dat_i[8] == 1'b0 ;req.dat_i[6:0] == req.char_len;}; 
temp_ctrl=req.dat_i;
finish_item(req);
`uvm_info(get_full_name(),$sformatf("\n CTRL(contor) REGISTER CONFIGARATION IS COMPLETED WITH GO_BUSY=0 lsb=%b tx_n=%b,rx_n=%b ",lsb_s,tx_neg_s,rx_neg_s) ,UVM_NONE);
  
  `uvm_do(div_sequ)
  `uvm_do(ss_sequ);
`uvm_info(get_full_name(),"\n CTRL(contor) REGISTER CONFIGARATION IS STARTED WITH GO_BUSY=1 ",UVM_NONE);
//req = spi_master_seq_item::type_id::create("req");
  start_item(req);
req.randomize() with{lsb == temp_ctrl[11];adr_i=='h10;dat_i[13] == temp_ctrl[13]; dat_i[12] == temp_ctrl[12]; dat_i[11] == lsb; dat_i[10] == temp_ctrl[10]; dat_i[9] == temp_ctrl[9]; dat_i[8] == 1'b1 ;dat_i[7] == temp_ctrl[7];dat_i[6:0] == temp_ctrl[6:0];dat_i[31:14]==temp_ctrl[31:14];}; 
  finish_item(req);
`uvm_info(get_full_name(),$sformatf("\n CTRL(contor) REGISTER CONFIGARATION IS COMPLETED WITH GO_BUSY=1 lsb=%b tx_n=%b,rx_n=%b ",lsb_s,tx_neg_s,rx_neg_s) ,UVM_NONE);
 //waiting for the int_o signal for the reading of rx_reg registers.
  $display("$$$$$$$$$$$$$$$$$$$$$ -------------before_response----------$$$$$$$$$$$$$$");
  get_response(rsp);
  $display("rsp.int_o =%0b ",rsp.int_o);
  $display("$$$$$$$$$$$$$$$$$$$-------------after_response------------$$$$$$$$$$$$$$");
  if(rsp.int_o==1) begin
    $display("$$$$$$$$$$$$$$$$$$$-------------after_response1------------$$$$$$$$$$$$$$");
`uvm_info(get_name(),$sformatf("\n <<<<<<SEQUENCE GOT THE INTERRUPT RESPONSE FROM THE DRIVER \" wb_int_o=%b \" NEXT READ RX(RECIEVEE REGISTERS)>>>>>",rsp.int_o),UVM_NONE);  
  //read the all registers.
      #20; 
    `uvm_do_with(req,{req.we_i==0;req.adr_i==0;});
     `uvm_do_with(req,{req.we_i ==0 ;req.adr_i==5'h4;});
     `uvm_do_with(req,{req.we_i ==0 ;req.adr_i==5'h8;});
     `uvm_do_with(req,{req.we_i ==0 ;req.adr_i==5'hc;});
       end
  
endtask:body          

endclass:ctrl_sequ       
////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

class wb_base_sequence extends uvm_sequence#(spi_master_seq_item);
  int repeat_count_wb_seq=1;
  
`uvm_object_utils_begin(wb_base_sequence)
  `uvm_field_int(repeat_count_wb_seq ,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name="wb_base_sequence");
    super.new(name);
  endfunction:new
   
   transfor_sequ tx_sequ; //sequence for the configuring the transmit register
   // divider_sequ  div_sequ;//SEQUNCE FOR THE CONFIGURING THE  DIVIDER REGISTER 
   ctrl_sequ  sequ_ctrl;
  
virtual task pre_start();
super.pre_start();
  if(!uvm_config_db#(int)::get(null,"get_full_name()","repeat_count",repeat_count_wb_seq)) begin
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" repeat_count \"  and then access");
end
endtask:pre_start
  
virtual task body();
`uvm_info(get_name(),$sformatf(" \">>>>>WB_SEQ repeat_count_wb_seq=%0d<<<<\"",repeat_count_wb_seq),UVM_NONE);
repeat(repeat_count_wb_seq) begin
// static bit [7:0]ss_reg=8'b0000_0001;
`uvm_do(tx_sequ)
//`uvm_do(div_sequ)
//`uvm_info("WB_BASE_SEQUENCE","\n SS(slave select ) REGISTER CONFIGARATION IS STARTED ",UVM_NONE);
//`uvm_do_with(req,{req.adr_i==5'h18;req.dat_i == ss; ss==ss_reg;})
//`uvm_info("WB_BASE_SEQUENCE","\nSS(slave select) REGISTER CONFIGARATION IS COMPLETED " ,UVM_NONE);
`uvm_do(sequ_ctrl)
      
      // `uvm_do_with(req,{req.adr_i=='h10;req.dat_i[8]==1'b1;req.dat_i[10:9]==2'b00;req.dat_i[11]==1'b1;req.dat_i[6:0]==5;req.dat_i[12]==1'b1;req.dat_i[13]==1'b1;});
     
   //  ss_reg= ss_reg<<1;//left shifting by 1 bit
       
     #20;  // get_response(rsp);
      
     end
   endtask:body
  
 endclass:wb_base_sequence
            