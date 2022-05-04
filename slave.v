module slave#( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input en,
	input valid,
	input [WIDTH-1:0] data_in,
	output reg ready,
	output reg [WIDTH-1:0] data_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			ready <= 1'b0;
		end
		else begin
			ready <= en;
		end
	end

    always@ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= {WIDTH{1'b0}};                 
        else if (ready && valid)
            data_out <= data_in;              
        else 
            data_out <= {WIDTH{1'b1}};
    end      

endmodule