module master#( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input en,
	input ready,
	input [WIDTH-1:0] m_data_in,

	output reg [7:0] addr,
	output reg [WIDTH-1:0] m_data_out,
	output reg valid
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			m_data_out <= {WIDTH{1'b0}};
		end
		else if (valid & ready) begin
			m_data_out <= m_data_in;//data + 1'b1;
		end
		else begin
			m_data_out <= m_data_out;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			valid <= 1'b0;
		end
		else begin
			valid <= en;
		end
	end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            addr<=8'b0;
        end
        else begin
			if (addr==8'h30) 
            	addr<=8'b0;
			else if ((addr<8'h30)&(valid & ready) )
				addr<=addr+8'b1;
			else addr<=addr;
		end  
    end	



endmodule