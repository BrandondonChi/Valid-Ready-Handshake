// 对valid打拍
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
	//either the downstream ready is high (the data in these registers 
	//is being accepted downstream) OR downstream valid is low 
	//(the registers currently have no valid data).
endmodule 