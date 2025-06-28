//tx_reg0 register

class tx_reg0 extends uvm_reg;
  
//factory registration
  `uvm_object_utils(tx_reg0)
  
//tx_reg0 is a data register ,it not have a control fields.  
rand uvm_reg_field  tx_reg0_data;
  
//default constructor
function new(string name=" tx_reg0 ");
super.new(name,32,UVM_NO_COVERAGE);//32 BIT REGISTER.
endfunction:new

//function void build ,it is  not a build phase.
function void build;
tx_reg0_data = uvm_reg_field::type_id::create("tx_reg0_data");
tx_reg0_data.configure(this,32,0,"RW",0,0,1,1,0); 
endfunction:build


endclass:tx_reg0

//*****************************************************************************

//-----------------------------------------------------------------------------

class tx_reg1 extends uvm_reg;
  
//factory registration.
`uvm_object_utils(tx_reg1)

//tx_reg1 is a data register ,so it not have any control fields
rand uvm_reg_field tx_reg1_data;
  
//default constructor.
function new(string name = " tx_reg1 "); 
super.new(name,32,UVM_NO_COVERAGE);
endfunction:new
  
function void build;
tx_reg1_data = uvm_reg_field::type_id::create("tx_reg1_data");
tx_reg1_data.configure(this,32,0,"RW",0,0,1,1,0);
endfunction:build
  
endclass:tx_reg1

//*************************************************************************************
 
//------------------------------------------------------------------------------------

class tx_reg2 extends uvm_reg;
  
//factory registration.
`uvm_object_utils(tx_reg2)

//tx_reg2 is a data register ,so it not have any control fields
rand uvm_reg_field tx_reg2_data;
  
//default constructor.
function new(string name = " tx_reg2 "); 
super.new(name,32,UVM_NO_COVERAGE);
endfunction:new
  
function void build;
tx_reg2_data = uvm_reg_field::type_id::create("tx_reg2_data");
tx_reg2_data.configure(this,32,0,"RW",0,0,1,1,0);
endfunction:build
  
endclass:tx_reg2



//**************************************************************************************************

//------------------------------------------------------------------------------------
class tx_reg3 extends uvm_reg;
  
//factory registration.
`uvm_object_utils(tx_reg3)

//tx_reg3 is a data register ,so it not have any control fields
rand uvm_reg_field tx_reg3_data;
  
//default constructor.
function new(string name = " tx_reg3 "); 
super.new(name,32,UVM_NO_COVERAGE);
endfunction:new
  
function void build;
tx_reg3_data = uvm_reg_field::type_id::create("tx_reg3_data");
tx_reg3_data.configure(this,32,0,"RW",0,0,1,1,0);
endfunction:build
  
endclass:tx_reg3

//*******************************************************************************
//-------------------------------------------------------------------------------------------

//for ctrl register.
class ctrl_reg extends uvm_reg;
  
//factory registration
`uvm_object_utils(ctrl_reg)
  
  
//3.4 Control and status register [CTRL]
//Bit #   31:14    13     12    11    10       9         8          7          6:0
//Access   R      R/W    R/W   R/W    R/W     R/W       R/W         R          R/W
//Name  Reserved  ASS    IE    LSB   Tx_NEG  Rx_NEG   GO_BSY   Reserved      CHAR_LEN

//Reset Value: 0x0000_0000
  
//ctrl register format.
//       31:14            13   12     11     10      9        8           7            6:0    
//   reserved_bits       ass   ie    lsb   tx_neg  rx_neg  go_busy  reserver_bit     char_len
  
//ctrl_reg is a 32 bit register ,it have 18 fields 
  rand uvm_reg_field char_len;//[6:0]
  rand uvm_reg_field resvd_bit7;//[7]
  rand uvm_reg_field go_busy;//[8]
  rand uvm_reg_field rx_neg;//[9]
  rand uvm_reg_field tx_neg;//[10]
  rand uvm_reg_field lsb;//[11]
  rand uvm_reg_field ie;//[12]
  rand uvm_reg_field ass;//[13]
  rand uvm_reg_field resvd_bits31_14; //[31:14]
  
  
//default constructor
function new(string name="ctrl_reg");
super.new(name,32,UVM_NO_COVERAGE); //32 bits
endfunction:new
 
// NB build, not build_phase  
function void build;                    
//f1 = uvm_reg_field::type_id::create("f1");
//f1.configure(this, 8, 0, "RW", 0, 0, 1, 1, 0);  
// reg, bitwidth, lsb, access, volatile, reselVal, hasReset, isRand, fieldAccess
  
char_len       = uvm_reg_field::type_id::create("char_len");
resvd_bit7     = uvm_reg_field::type_id::create("resvd_bit7");
go_busy        = uvm_reg_field::type_id::create("go_busy");
rx_neg         = uvm_reg_field::type_id::create("rx_neg");
tx_neg         = uvm_reg_field::type_id::create("tx_neg");  
lsb            = uvm_reg_field::type_id::create("lsb");
ie             = uvm_reg_field::type_id::create("ie");
ass            = uvm_reg_field::type_id::create("ass");
resvd_bits31_14= uvm_reg_field::type_id::create("resvd_bits31_14"); 
  
  char_len.configure(   this,7,0,"RW",0,7'b0000_000,1,1,0);
  resvd_bit7.configure( this,1,7,"RW",0,1'B0,1,1,0);
  go_busy.configure(    this,1,8,"RW",0,1'b0,1,1,0);
  rx_neg.configure(     this,1,9,"RW",0,1'b0,1,1,0);
  tx_neg.configure(     this,1,10,"RW",0,1'b0,1,1,0);
  lsb.configure   (     this,1,11,"RW",0,1'b0,1,1,0);
  ie.configure    (     this,1,12,"RW",0,1'b0,1,1,0);
  ass.configure   (     this,1,13,"RW",0,1'b0,1,1,0);
  resvd_bits31_14 (     this,18,14,"RW",0,18'h0000_0,1,1,0);
endfunction
  
endclass:ctrl_reg

//******************************************************************************

//-------------------------------------------------------------------------------

class div_reg extends uvm_reg;

//factory registration.
  `uvm_object_utils(div_reg)
  
//3.5 Divider register [DIVIDER]
//Bit #      31:16             15:0
//Access       R                R/W
//Name      Reserved           DIVIDER

//Reset Value: 0x0000ffff

rand uvm_field_reg div_data;
rand uvm_field_reg  div_resvd_bits
 
//default constructor
function new(string name = " div_reg");
super.new(name,32,UVM_NO_COVERAGE);  
endfunction:new
  
//function build ,it is not a build ph;;ase
function void build;
div_data = uvm_reg_field::type_id::create("div_data");
div_data.configure(this,16,0,"RW",0,0,1,1,0);
div_resvd_bits=uvm_reg_field::type_id::create("div_resvd_bits");
div_data.configure(this,16,16,"RW",0,0,1,1,0);
endfunction:build
  
endclass:div_reg

//******************************************************************************

//---------------------------------------------------------------------------------

class ss_reg extends uvm_reg;
  //factory registration
  `uvm_object_utils(ss_reg)
//3.6   Slave select register [SS]
//Bit #   31:8     7:0
//Access   R       R/W  
  
rand uvm_reg_field ss_data;
rand uvm_reg_field ss_resvd_bits;
  
  function new(string name = " ss_reg");
    super.name(name,32,UVM_NO_COVERAGE);
  endfunction:new
  
//it is not a build phase.
function void build;
  ss_data = uvm_reg_field::type_id::create("ss_data");
  ss_data.configure(this,8,0,"RW",0,0,1,1,0);
  ss_resvd_bits=uvm_reg_field::type_id::create("ss_resvd_bits");
  ss_resvd_bits.configure(this,24,8,"RW",0,0,1,1,0);
endfunction:build
  
endclass:ss_reg

//**************************************************************************************



//-------------------------------------------------------------------------------------------

// this is the register block
//uvm_reg_block is object class.

class wb_reg_model extends uvm_reg_block;
 
//factory registration
  `uvm_object_utils(wb_reg_model)
  
//declare the all registers.
tx_reg0  tx_reg0_h;
tx_reg1  tx_reg1_h;
tx_reg2  tx_reg2_h;
tx_reg3  tx_reg3_h;

ctrl_reg ctrl_reg_h;
div_reg  div_reg_h;
ss_reg   ss_reg_h;
  
//default constructor.
  function new(string name = "wb_reg_model")
super.new(name,build_coverage(UVM_NO_COVERAGE));
endfunction:new
//r0.add_hdl_path_slice("ctrl", 'h10, 32);      // name, offset, bitwidth // register name inside rtl when you open will get to know  //Back door access
function void build:
tx_reg0_h = tx_reg0::type_id::create("tx_reg0_h");
tx_reg0_h.build();
tx_reg0_h.configure(this); 
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
tx_reg0_h.add_hdl_path_slice(        "    "  ,       5'h00,      32); 

  tx_reg1_h = tx_reg1::type_id::create("tx_reg1_h");
  tx_reg1_h.build()
  tx_reg1_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
  tx_reg1_h.add_hdl_path_slice(        "    "    ,   5'h04    ,       32    );
  
  tx_reg2_h = tx_reg2::type_id::create("tx_reg2_h);
  tx_reg2_h.build();
  tx_reg2_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
tx_reg2_h.add_hdl_path_slice(        "    "      , 5'h08     ,32    );
  
tx_reg3_h = tx_reg3::type_id::create("tx_reg3_h"); 
tx_reg3_h.build();                                       
tx_reg3_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
tx_reg3_h.add_hdl_path_slice(        "    "        ,5'h0c     ,     32    );
  
ctrl_reg_h = ctrl_reg::type_id::create("ctrl_reg_h"); 
ctrl_reg_h.build();
ctrl_reg_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
ctrl_reg_h.add_hdl_path_slice(        "ctrl"   ,    5'h10      ,     32    );

div_reg_h = div_reg::type_id::create("div_reg_h");
div_reg_h.build();
div_reg_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
div_reg_h.add_hdl_path_slice(        "divider"   ,    5'h14    ,       32    );
                                       
ss_reg_h = ss_reg::type_id::create("ss_reg_h");
ss_reg_h.build();
ss_reg_h.configure(this);
//           add_hdl_path_slice <reg_name_in_dut>, <offset> ,<bit_width>); //here offset means addr of register in dut.
ss_reg_h.add_hdl_path_slice(        "ss"   ,      5'h18 ,         32    );
                                     
                                       
endfunction:build
  
endclass:wb_reg_model

//**********************************************************************************
                                       
////////////-------------------------------------------------

//uvm_adapter connects register model to sequencer.
class wb_adapter extends uvm_adapter;
//factory registration.
`uvm_object_utils(wb_adapter)

//default constructor.
function new(string name = "wb_adapter");
super.new(name);    
endfunction:name
  
//we have two methods in uvm_adapter which are standard i. bus to register ii.reg to bus.

//ii.reg to bus
function uvm_sequence_item reg2bus(const ref uvm_bus_reg_op rw);
spi_master_seq_item pkt;
pkt = spi_master_seq_item::type_id::create("pkt");
pkt.we_i = 1'b1;
pkt.adr_i = rw.adr_i;// rw is register item which only have addr,data;
pkt.dat_i = rw.dat_i;
pkt.stb_i = 1'b1;
pkt.cyc_i = 1'b1;
pkt.sel_i = 4'hf;
endfunction:reg2bus
  
// bus2reg //monitor to reg.//converting into register items.
function void bus2reg(uvm_sequence_item bus_item ,ref uvm_reg_bus_op rw);
  
spi_master_seq_item pkt;
assert($cast(pkt,bus_item))
else `uvm_fatal("wb_adapter_bus2reg"," A bad thing has happend in wb_adapter");
rw.adr_i = pkt.adr_i;
rw.dat_i = pkt.dat_i;
rw.status = UVM_IS_OK ;
  
endfunction:bus2reg
  
  
endclass:wb_adapter
                                       
//**********************************************************************************************
                                       
//---------------------------------------------------------------------------------------------
                                       
class wb_reg_model_sequence  extends uvm_sequence#(spi_master_seq_item);
  
bit lsb_s;
bit tx_neg_s;
bit rx_neg_s;

//register model handle declaration.
 wb_reg_model  regmodel;
  
//factory registration
  `uvm_object_utils(wb_reg_model_sequence)

//default constructor
  function new(string name ="wb_reg_model_sequence");
super.new(name);    
endfunction:new

virtual task pre_start();
  
if(! uvm_config_db#(bit)::get(this," ","lsb",lsb_s) 
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" lsb \"  and then access");
   
if(! uvm_config_db#(bit)::get(this," ","tx_neg",tx_neg_s)
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" tx_neg \"  and then access");   
   
if(! uvm_config_db#(bit)::get(this," ","rx_neg",rx_neg_s)
`uvm_fatal(get_full_name()," first set the  CONFIG DB \" rx_neg \"  and then access");
   
endtask:pre_start

virtual task body();
  
regmodel = wb_reg_model::type_id::create("regmodel");
  static bit [31:0} ctrl_temp;
static  bit [7:0] ss_reg_val = 8'b0000_0001;
// uvm_reg_data_t incoming;
uvm_status_e status;
//config my ctrl reg with the ass= 1 and ie=1 and go busy=0 and char_len=8
regmodel.ctrl_reg_h.write(status ,val({18'h0000_0,1'b1,1'b1,lsb_s,tx_neg_s,rx_neg_s,1'b0,1'b0,7'b000_1000}),.parent(this));

//configuring the divider register div=2;
regmodel.div_reg_h.write(status,val(2),.parent(this));

//configuring the ss register
regmodel.ss_reg_h.write(status,val(ss_reg_val),.parent(this));
//now configuring the control register with go_busy =1 with other fields are same as above configuration values.
regmodel.ctrl_reg_h.write(status ,val({18'h0000_0,1'b1,1'b1,lsb_s,tx_neg_s,rx_neg_s,1'b1,1'b0,7'b000_1000}),.parent(this));
            
ss_reg_val = (ss_reg_val<< 1);//left shift by one bit every time.


endtask:body
  
endclass:wb_reg_model_sequence
                                       