`timescale 1ns / 1ps
module tb();
	reg clk;
	reg rst_n;
    reg [12:0] addr;
    reg read,ena;
    wire [7:0] data;

	initial begin
		clk = 1'b1;
		rst_n = 1'b1;
		#20 rst_n = 1'b0;
		#40 rst_n = 1'b1;
        $readmemh("test1.pro",rom_inst.memory);
        read=1;
        ena=1;
	end
	always #10 clk = ~clk;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            addr<=13'b0;
        end
        else if (addr==13'h30) begin
            addr<=13'b0;
        end
        else addr<=addr+1;
    end

    rom rom_inst(
        .addr(addr),
        .read(read),
        .ena(ena),
        .data(data)
    );
endmodule

module rom (
    input [12:0] addr,
    input read,
    input ena,
    output [7:0] data
);
    reg [7:0] memory [255:0];
    assign data=(read && ena)?memory[addr]:8'bzzzz_zzzz;

endmodule