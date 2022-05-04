`timescale 1ns / 1ps
module handshake_tb ();
	parameter WIDTH = 8;

	reg clk;
	reg rst_n;
	reg en_master;
	reg en_slave;

	wire [WIDTH-1:0] m_data_out;
	wire [WIDTH-1:0] s_data_in;
	wire [WIDTH-1:0] s_data_out;
	wire  m_valid;
	wire  m_ready;
	wire  s_valid;
	wire  s_ready;

    wire [7:0] addr;
    reg read,ena;
    wire [7:0] data_rom;

	initial begin
		clk = 1'b1;
		rst_n = 1'b0;
		#20 rst_n = 1'b1;
        $readmemh("test1.pro",rom_inst.memory);
        read=1;
        ena=1;
	end
	always #10 clk = ~clk;	

    rom rom_inst(
        .addr(addr),
        .read(read),
        .ena(ena),
        .data(data_rom)
    );



	initial begin
		en_master = 1'b0;
		#100 en_master = 1'b1;
		#100 en_master = 1'b0;
		#20	 en_master = 1'b1;
		#40	 en_master = 1'b0;
		#20	 en_master = 1'b1;
		#60	 en_master = 1'b0;
		#40	 en_master = 1'b1;
		#80	 en_master = 1'b0;
		#100 en_master = 1'b1;
		#40	 en_master = 1'b0;
		#60	 en_master = 1'b1;
		#20	 en_master = 1'b0;
		#60	 en_master = 1'b1;
		#120 en_master = 1'b0;
		#20	 en_master = 1'b1;
		#80	 en_master = 1'b0;
	end

	initial begin
		en_slave = 1'b0;
		#20  en_slave = 1'b1;
		#20  en_slave = 1'b0;
		#20  en_slave = 1'b1;
		#20  en_slave = 1'b0;
		#40	 en_slave = 1'b1;
		#20	 en_slave = 1'b0;
		#20  en_slave = 1'b1;
		#60  en_slave = 1'b0;
		#80  en_slave = 1'b1;
		#40  en_slave = 1'b0;
		#100  en_slave = 1'b1;
		#120  en_slave = 1'b0;
		#80  en_slave = 1'b1;
		#40  en_slave = 1'b0;
		#60  en_slave = 1'b1;
		#20  en_slave = 1'b0;
		#100  en_slave = 1'b1;
		#60  en_slave = 1'b0;
		#20  en_slave = 1'b1;
		#40  en_slave = 1'b0;
	end

	handshake_top handshake_top_inst (
		.clk(clk), 
		.rst_n(rst_n), 
		.addr(addr),
		.en_master(en_master), 
		.en_slave(en_slave), 
		.m_valid(m_valid), 
		.m_ready(m_ready), 
		.s_valid(s_valid), 
		.s_ready(s_ready), 
		.m_data_in(data_rom),
		.m_data_out(m_data_out),
		.s_data_in(s_data_in),
		.s_data_out(s_data_out)
		);
	
endmodule


module rom (
    input [7:0] addr,
    input read,
    input ena,
    output [7:0] data
);
    reg [7:0] memory [255:0];
    assign data=(read && ena)?memory[addr]:8'bzzzz_zzzz;

endmodule