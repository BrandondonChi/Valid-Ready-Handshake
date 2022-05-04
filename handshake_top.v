module handshake_top#( parameter WIDTH = 8)(
	input clk,
	input rst_n,
	input en_master,
	input en_slave,
	output m_valid,
	output m_ready,
	output s_valid,
	output s_ready,
	output [7:0]addr,
	input  [WIDTH-1:0] m_data_in,
	output [WIDTH-1:0] m_data_out,
	output [WIDTH-1:0] s_data_in,
	output [WIDTH-1:0] s_data_out
	);
		

//===========================================================================
//不打拍
/*
	assign m_ready=s_ready;
	assign s_valid=m_valid;
	assign s_data_in=m_data_out;
	master master_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_master), 
		.ready(m_ready), 
		.addr(addr),
		.m_data_in(m_data_in),
		.m_data_out(m_data_out), 
		.valid(m_valid)
		);

	slave slave_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_slave), 
		.valid(s_valid), 
		.data_in(s_data_in), 
		.ready(s_ready), 
		.data_out(s_data_out)
		);

*/

//===========================================================================
//对valid打拍
/*
	master master_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_master), 
		.ready(m_ready),
		.addr(addr), 
		.m_data_in(m_data_in),
		.m_data_out(m_data_out), 
		.valid(m_valid)
		);
	Forward_Registered Forward_Registered_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.m_valid(m_valid), 
		.m_data(m_data_out), 
		.m_ready(m_ready), 
		.s_valid(s_valid), 
		.s_data(s_data_in), 
		.s_ready(s_ready)
		);

	slave slave_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_slave), 
		.valid(s_valid), 
		.data_in(s_data_in), 
		.ready(s_ready), 
		.data_out(s_data_out)
		);
*/
//===========================================================================
//对ready打拍
/*
	master master_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_master), 
		.ready(m_ready), 
		.addr(addr),
		.m_data_in(m_data_in),
		.m_data_out(m_data_out), 
		.valid(m_valid)
		);

	Backward_Registered Backward_Registered_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.m_valid(m_valid), 
		.m_data(m_data_out), 
		.m_ready(m_ready), 
		.s_valid(s_valid), 
		.s_data(s_data_in), 
		.s_ready(s_ready)
		);
	slave slave_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_slave), 
		.valid(s_valid), 
		.data_in(s_data_in), 
		.ready(s_ready), 
		.data_out(s_data_out)
		);	
*/
//===========================================================================
//对valid和ready同时打拍

	wire valid_internal;
	wire ready_internal;
	wire  [WIDTH-1:0] data_internal;

	master master_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_master), 
		.ready(m_ready), 
		.m_data_in(m_data_in),
		.m_data_out(m_data_out), 
		.addr(addr),
		.valid(m_valid)
		);
	Forward_Registered Forward_Registered_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.m_valid(valid_internal), 
		.m_data (data_internal), 
		.m_ready(ready_internal), 
		.s_valid(s_valid), 
		.s_data(s_data_in), 
		.s_ready(s_ready)
		);

	Backward_Registered Backward_Registered_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.m_valid(m_valid), 
		.m_data(m_data_out), 
		.m_ready(m_ready), 
		.s_valid(valid_internal), 
		.s_data (data_internal), 
		.s_ready(ready_internal)
		);
	slave slave_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.en(en_slave), 
		.valid(s_valid), 
		.data_in(s_data_in), 
		.ready(s_ready), 
		.data_out(s_data_out)
		);

endmodule

	