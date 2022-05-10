// 对valid打拍
/*------------------------------------------------------------------------
实现方法为 在Master握手成功（m_valid m_ready均为1时）之后将
valid 和data保持住，直到Slave也握手成功。
------------------------------------------------------------------------*/

//----------------------------------------------------------------------------------------
module Forward_Registered #( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input m_valid,
	input [WIDTH-1:0] m_data,
	output m_ready,
	output reg s_valid,
	output reg [WIDTH-1:0] s_data,
	input s_ready
	);
/*
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			s_valid <= 1'b0;
		end
		else if(m_ready) begin
			s_valid <= m_valid;
		end
		else begin
			s_valid <= s_valid;
		end
	end


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			s_data <= {WIDTH{1'b0}};
		end
		else if(m_ready) begin
			s_data <= m_data;
		end
		else begin
			s_data <= s_data;
		end
	end
	
	assign m_ready = ~s_valid | s_ready;

*/

always @(posedge clk or negedge rst_n)begin//在master发请求(拉高m_valid)时拉高s_valid，直到当前master没有valid请求并且slave可以接收请求(拉高s_ready)时拉低s_valid，表示一次传输完成。
   if (rst_n == 1'd0)
       s_valid <= 1'd0;
   else if (m_valid == 1'd1)
       s_valid <= 1'd1;
   else if (s_ready == 1'd1)
       s_valid <= 1'd0;
   else
	   s_valid<=s_valid;
end
 
always @(posedge clk or negedge rst_n)begin
   if (rst_n == 1'd0)
       s_data <= 'd0;
   else if (m_valid == 1'd1 && m_ready == 1'd1)
       s_data <=  m_data;
	else 
		s_data<=s_data;
end
 
m_ready = (~s_valid) | s_ready; //在完成一次传输后（s_valid=0）或者slave可以接收数据时将m_ready拉高，可提高传输效率
endmodule 