
task body();
  //1st send configure tx registers `uvm_do_with(req,{addr==0,we==1})
  `uvm_do_with(req,{addr==4,we==1});
  `uvm_do_with(req,{addr==8,we==1});
  `uvm_do_with(req,{addr=='hc,we==1});
  
  
  //configure control registers with go_Busy==0; `uvm_do_with(req,{});
  //configure ss register `uvm_do_with(req,{req.addr=='h18,we==1};) 
  
  //configure divide reginster
  //configure ctrl register with go_busy==1
  
endtask