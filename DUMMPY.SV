constraint adr_const{adr inside{0,4,8};}





if(tx_neg ==0 && rx_neg == 0) begin:B1
  @(posedge sclk_pad_o);
  b=io_vintf.mosi_pad_o;
 if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],b};
   b=data[127];
  end:lsb_0
  else begin:lsb_1
   data={b,data[127:1]};
    b=data[0];
 end:lsb_1
io_vintf.miso_pad_i <= b;
end:B1


if(tx_neg ==0 && rx_neg == 1) begin
  @(posedge sclk_pad_o);
  b=io_vintf.mosi_pad_o;
 if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],b};
   b=data[127];
  end:lsb_0
  else begin:lsb_1
   data={b,data[127:1]};
    b=data[0];
 end:lsb_1
@(negedge sclk_pad_o);
io_vintf.miso_pad_i <= b; 
end

if(tx_neg ==1 && rx_neg == 0) begin
  @(posedge io_vintf.sclk_pad_o);
  b=io_vintf.mosi_pad_o;
  if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],b};
   b=data[127];
  end:lsb_0
  else begin:lsb_1
   data={b,data[127:1]};
    b=data[0];
  io_vintf.miso_pad_i <= b; 
 end:lsb_1
  
end

if(tx_neg ==1 && rx_neg == 1) begin
  @(posedge io_vintf.sclk_pad_o);
  b=io_vintf.mosi_pad_o;
  if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],b};
   b=data[127];
  end:lsb_0
  else begin:lsb_1
   data={b,data[127:1]};
    b=data[0];
  @(negedge io_vintf.sclk_pad_o);
  io_vintf.miso_pad_i <= b;
end


//for monitor

if(tx_neg ==0 && rx_neg == 0) begin:B1
  @(negedge sclk_pad_o); //transmission is happend at mosi at posedge and miso at Posedge but we collected at negedge ok.
   a=io_vintf.mosi_pad_o;
   b=io_vintf.miso_pad_i;
 
 if(lsb ==0 ) begin:lsb_0
   data ={data[126:0],a};
  data1 = {data1[126:0],b};
  end:lsb_0
  
  else begin:lsb_1
    data={a,data[127:1]};
    data1={b,dat1[127:1]];
 end:lsb_1
end:B1
           
         
if(tx_neg ==0 && rx_neg == 1) begin //transmission is happend at mosi at posedge and miso at negedge but we collected at posedge ok.
  @(negedge sclk_pad_o);
  a=io_vintf.mosi_pad_o;
 @(posedge sclk_pad_o);
   b=io_vintf.miso_pad_i; 
 if(lsb ==0 ) begin:lsb_0
   data ={data[126:0],a};
   data1={data[126:0],b};
  end:lsb_0
  else begin:lsb_1
  data={a,data[127:1]};
  data1={b,data[127:1]};
 end:lsb_1

end


if(tx_neg ==1 && rx_neg == 0) begin
 @(negedge io_vintf.sclk_pad_o);
  b=io_vintf.miso_pad_i;
  @(posedge io_vintf.sclk_pad_o);
  a=io_vintf.mosi_pad_o;
  if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],a};
    data1={data[126:0],b};
  end:lsb_0
  else begin:lsb_1
    data={a,data[127:1]};
    data1={b,data[127:1]};
  
 end:lsb_1
  
end
         
if(tx_neg ==1 && rx_neg == 1) begin
   @(negedge io_vintf.sclk_pad_o);
   @(posedge io_vintf.sclk_pad_o);
   b=io_vintf.miso_pad_i;
   a=io_vintf.mosi_pad_o;
  if(lsb ==0 ) begin:lsb_0
    data ={data[126:0],a};
    data1={data1[126:0],b};
  end:lsb_0
  else begin:lsb_1
    data={a,data[127:1]};
    data1={b,data1[127:1]};
   end