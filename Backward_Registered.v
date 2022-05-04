// 对ready打拍
module Backward_Registered #( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input m_valid,
	input [WIDTH-1:0] m_data,
	output m_ready,
	output s_valid,
	output [WIDTH-1:0] s_data,
	input s_ready
	);

	wire s_ready_dge;
	reg valid_skid;
	reg [WIDTH-1:0] data_skid;

	always @(posedge clk or negedge rst_n) begin
	  	if (!rst_n)
	  	  	valid_skid <= 1'b0;          
	  	else if (valid_skid)
	  	 	valid_skid <= ~s_ready;          
	  	else if (~valid_skid^s_ready)
	  	  	valid_skid <= m_valid;    //buffer_skid中有数据有效信号
	end                           
	  
	
	always @(posedge clk or negedge rst_n) begin
	  	if (!rst_n)
	  	  	data_skid <= {WIDTH{1'b0}};           
	  	else
	  	  	data_skid <= valid_skid ? data_skid: m_data;      
	end 
	
	
	assign  s_valid = valid_skid | m_valid;        
	assign  s_data = valid_skid ? data_skid : m_data;    
	assign  m_ready = ~valid_skid ;    

endmodule 