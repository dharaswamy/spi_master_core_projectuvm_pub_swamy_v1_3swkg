
class tx_reg3 extends uvm_reg;
  
//factory registration.
`uvm_object_utils(tx_reg3)

//tx_reg3 is a data register ,so it not have any control fields
rand uvm_reg_field tx_reg3_data;
  
//default constructor.
function new(string name = " tx_reg3 "); 
super.new(name,"32",UVM_NO_COVERAGE);
endfunction:new
  
function void build;
tx_reg3_data = uvm_reg_field::type_id::create("tx_reg3_data");
tx_reg3_data.configure(this,32,0,"RW",0,0,1,1,0);
endfunction:build
  
endclass:tx_reg3



