

module spi_assertion_module(//spi master signals
                     input logic wb_clk_i,
                     input logic wb_rst_i,
                     input logic [4:0] wb_adr_i, 
                     input logic [31:0] wb_dat_i,
                     input logic [31:0] wb_dat_o, 
                     input logic [3:0] wb_sel_i,
                     input logic wb_we_i, 
                     input logic wb_stb_i, 
                     input logic wb_cyc_i, 
                     input logic wb_ack_o, 
                     input logic wb_err_o,
                     input logic wb_int_o,
                      // SPI slave  signals
                     input logic [7:0] ss_pad_o,
                     input logic sclk_pad_o,
                     input logic mosi_pad_o,
                     input logic miso_pad_i);
  
  
//   int ss_r;
//   always @(posedge clk) begin
//     addr == h18 && wi &&
//     ss_r = wr_data;
//   end
  
//--------------------------------------------------------------------------------------------------------------
//property for the ack_o signal ,if wb_we_i =1 the next clock cycle the ack_o is high and followed clock cycle ack_o is low.
property write_ack_o_p();
@(posedge wb_clk_i) disable iff(wb_rst_i)     
  (wb_we_i && wb_stb_i && wb_cyc_i) |=> wb_ack_o ##1 (!wb_ack_o);   
endproperty:write_ack_o_p
  
//asserting the "write_ack_o_p " property
  write_ack_o_p_check:assert property(write_ack_o_p) begin
  //if(wb_we_i) 
    `uvm_info("write_ack_o_p ",$sformatf(" TIME:%0T \" wb_we_i=%b write_ack_o_p  is passed \" ",$time ,wb_we_i),UVM_NONE);
   // if(!wb_we_i)
     //`uvm_info("read_ack_o_p",$sformatf(" TIME:%0T \"read_ack_o_p  is passed \" ",$time),UVM_NONE);
  end
 
//covering reporty of the "write_ack_o_p" property
write_ack_o_p_cover_report:cover property(write_ack_o_p);
//*******************************************************************************************
  
//-------------------------------------------------------------------------------------------
  
  
//--------------------------------------------------------------------------------------------  
property read_ack_o_p();
@(posedge wb_clk_i) disable iff(wb_rst_i)     
  (!wb_we_i) |=> wb_ack_o ##1 (!wb_ack_o);   
endproperty:read_ack_o_p
  
//asserting the "write_ack_o_p " property
read_ack_o_p_check:assert property(read_ack_o_p)
`uvm_info("read_ack_o_p",$sformatf(" TIME:%0T \"read_ack_o_p  is passed \" ",$time),UVM_NONE);
 
//covering reporty of the "write_ack_o_p" property
 read_ack_o_p_cover_report:cover property(read_ack_o_p);
//***************************************************************************************   
   
//property for the "wb_dat_o" ,if wb_we_i=0 then next clock cycle the wb_dat_o come.
//property dat_o_p();
 // @(posedge clk) disable iff(wb_rst_i)
 // (!wb_we_i && wb_stb_i && wb_cyc_i) |=> 
    
//endproperty:dat_o_p
  
  
   
//--------------------------------------------------------------------------------------------   
//property for ss_pad_o 
property ss_pad_o_p();
@(posedge wb_clk_i) disable iff(wb_rst_i) 
(wb_we_i && wb_stb_i && wb_cyc_i && wb_sel_i == 4'hf && (wb_adr_i == 5'h10) && (wb_dat_i[13] == 1'b1) && (wb_dat_i[8] == 1'b1))|->
  ##[1:3] ss_pad_o != 8'hff##[0:$] ss_pad_o==8'hff;//##[1:3] (ss_pad_o == (!ss_r))##char_len (ss_pad_o == 8'hff) ; //char len. ##[0:$] ss_pad_o==ff;
endproperty:ss_pad_o_p
   

   
//asserting the "ss_pad_o_p"
ss_pad_o_p_check:assert property(ss_pad_o_p)
`uvm_info("ss_pad_o_p_check",$sformatf(" TIME:%0T \" Property_>: ss_pad_o_p is passed \" ",$time),UVM_NONE);

//COVER PROPERTY "ss_pad_o_p"
ss_pad_o_p_cover:cover property(ss_pad_o_p);
  
//***************************************************************************************************
  
//----------------------------------------------------------------------------------------------------------
  
//property for int_o
property int_o_p();
disable iff(wb_rst_i)
@(posedge wb_clk_i) 
  ((wb_we_i) && (wb_stb_i) && (wb_cyc_i) && (wb_sel_i == 4'hf) && (wb_adr_i == 5'h10) && (wb_dat_i[12] == 1'b1) && (wb_dat_i[8] == 1'b1)) |-> ##[1:$] wb_int_o ##[1:$]( (wb_we_i || !wb_we_i) && ((wb_stb_i) && (wb_cyc_i) && (wb_sel_i == 4'hf))) ##2 !wb_int_o; 
endproperty:int_o_p
   
//asserting the int_o
int_o_p_check:assert property(int_o_p)
`uvm_info("int_o_p_check",$sformatf(" TIME:%0T \" Property_>: int_o_p is passed \" ",$time),UVM_NONE);


//COVER PROPERTY int_o
 int_o_p_cover:cover property(int_o_p);  
   
//*******************************************************************************************************
   //for seeing reset behaviour
   property rst_bhv_ack_o_p();
     @(posedge wb_clk_i)
     wb_rst_i |=> (wb_ack_o==1'b0); 
   endproperty:rst_bhv_ack_o_p
   
   rst_bhv_p_check:assert property( rst_bhv_ack_o_p)
     `uvm_info(" rst_bhv_ack_o_p",$sformatf("TIME:%0T \"property_>:  rst_bhv_ack_o_pis passed \" " ,$time),UVM_NONE);

rst_bhv_ack_o_p_cover:cover property( rst_bhv_ack_o_p);

//for seeing reset behaviour
   property rst_bhv_int_o_p();
     @(posedge wb_clk_i)
     wb_rst_i |=> (wb_int_o==1'b0); 
   endproperty:rst_bhv_int_o_p
   
rst_bhv_int_o_p_check:assert property(rst_bhv_int_o_p)
    `uvm_info("rst_bhv_int_o_p_check",$sformatf("TIME:%0T \"property_>: rst_bhv_int_o_p_check is passed \" " ,$time),UVM_NONE);

rst_bhv_int_o_p_cover:cover property(rst_bhv_int_o_p);
  
  property rst_bhv_dat_o_p();
    @(posedge wb_clk_i)
    wb_rst_i |=> wb_dat_o == 32'h0000_0000;
  endproperty:rst_bhv_dat_o_p
  
  rst_bhv_dat_o_p_check:assert property(rst_bhv_dat_o_p)
  `uvm_info("rst_bhv_dat_o_p_check",$sformatf(" TIME:%0T \" property_>: rst_phv_dat_o_p_check is passed \"" ,$time),UVM_NONE);
                                              
rst_bhv_dat_o_p_cover:cover property(rst_bhv_dat_o_p);                                              
  
 ////i need some some more propertyes if rst high directly read the internal register of tx0,tx1,tx2,tx3,div,ss,ctrl .
  //output signal mosi,ss_pad_o==ff,int=0,error=0,
//**********************************************************************************************  
 
  
//------------------------------------------------------------------------------------

property sclk_pad_o_p();
@(posedge wb_clk_i) disable iff(wb_rst_i)
  (wb_we_i && wb_stb_i && wb_cyc_i && wb_sel_i == 4'hf &&(wb_adr_i == 5'h10) && (wb_dat_i[13] == 1'b1) && (wb_dat_i[8] == 1'b1)) |-> ##[1:3] ss_pad_o != 8'hff ##[1:3] sclk_pad_o;    //count the no of clock pluses it equal to char_len.  
endproperty:sclk_pad_o_p
  
sclk_pad_o_p_check:assert property(sclk_pad_o_p)
  `uvm_info("sclk_pad_o_p_check",$sformatf(" TIME:%0T \" property_>:sclk_pad_o_p_check is passed \" ",$time),UVM_NONE);
  
  sclk_pad_o_p_cover:cover property(sclk_pad_o_p);
    
    
endmodule:spi_assertion_module
  
  
  
  