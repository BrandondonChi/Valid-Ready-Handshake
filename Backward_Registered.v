// 对ready打拍
/*-----------------------------------------------------------------
当Master端发送请求但Slave端未就绪时将data暂存于寄存器中，并将valid_skid拉高，表示下一次Slave准备好接收数据时读取暂存于寄存器中的数据。
------------------------------------------------------------------*/
module Backward_Registered #( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input m_valid,
	input [WIDTH-1:0] m_data,
	output m_ready,
	output s_valid,
	output [WIDTH-1:0] s_data,
	// output reg valid_skid,
	// output reg [WIDTH-1:0] data_skid, 用于仿真的接口
	input s_ready
	);

	wire s_ready_dge;
	reg valid_skid;
	reg [WIDTH-1:0] data_skid;
/*
	always @(posedge clk or negedge rst_n) begin
	  	if (!rst_n)
	  	  	valid_skid <= 1'b0;          
	  	else if (valid_skid)
	  	 	valid_skid <= ~s_ready;          
	  	else if (~valid_skid^s_ready)
	  	  	valid_skid <= m_valid;    //buffer_skid中有数据有效信号
	end                           
	*/  
//-------------------------------------
//更新之后的写法
	always @(posedge clk or negedge rst_n)begin
		if (rst_n == 1'd0)
			valid_skid <= 1'd0;
		else if (m_valid == 1'd1 && s_ready == 1'd0 &&valid_skid == 1'd0)//master发送请求但slave未准备好接收数据，将valid_skid拉高，表明下一次Slave准备好接收数据时读取暂存于寄存器中的数据。
			valid_skid <= 1'd1;
		else if (s_ready == 1'd1)										//slave已准备好接收数据，将valid_skid拉低
			valid_skid <= 1'd0;
		else 
			valid_skid <= valid_skid;
	end  
//---------------------------------------

	
	always @(posedge clk or negedge rst_n) begin
	  	if (!rst_n)
	  	  	data_skid <= {WIDTH{1'b0}};           
	  	else
	  	  	data_skid <= valid_skid ? data_skid: m_data;      //valid_skid为高电平时，将数据暂存于data_skid中，valid_skid为低电平时更新data_skid中数据
	end 
	
	
	assign  s_valid = valid_skid | m_valid;        			//提前拉高s_valid，一旦slave准备好接收数据（s_ready=1）就可从data_skid中读取数据，提高传输速率
	assign  s_data = valid_skid ? data_skid : m_data;    
	assign  m_ready = ~valid_skid ;  						//valid_skid=0时，一种情况表明slave已准备好接收暂存数据，此时将m_ready拉高做好准备，当m_valid=1时master即可向外发送数据，提高传输速率
															//另一种情况则是m_valid=0 且s_ready=0，此时没有数据可发送，将m_ready信号拉高，提前做好准备，提高传输速率 



endmodule 