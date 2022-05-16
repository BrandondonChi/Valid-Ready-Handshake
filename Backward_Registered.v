`timescale 1ns / 1ps

module Backward #( parameter DWIDTH = 8 ) 
(
   input  clk     ,    
   input  rst_n   ,   
   
   input   [DWIDTH-1 : 0] m_data   ,     
   input                  m_valid  ,     
   output                 m_ready  ,     

   output  [DWIDTH-1 : 0] s_data   ,     
   output                 s_valid  ,     
   input                  s_ready        
) ;

parameter S0  = 1'b0 ;
parameter S1  = 1'b1 ;

reg                state                                     ;        
reg [DWIDTH-1 : 0] data_rg, sparebuff_rg                     ;        
reg                valid_rg, sparebuff_valid_rg, ready_rg    ;        
wire               ready                                     ;        

always @(posedge clk) begin 
   if (!rst_n) begin
      state              <= S0 ;
      data_rg            <= '0   ;     
      sparebuff_rg       <= '0   ;
      valid_rg           <= 1'b0 ;
      sparebuff_valid_rg <= 1'b0 ;
      ready_rg           <= 1'b0 ;

   end
   else begin
      case (state)   
         S0 : begin          
            if (ready) begin
               data_rg            <= m_data  ;  
               valid_rg           <= m_valid ;
               ready_rg           <= 1'b1    ;               
            end
            else begin
               sparebuff_rg       <= m_data  ;
               sparebuff_valid_rg <= m_valid ;
               ready_rg           <= 1'b0    ;
               state           <= S1    ;
            end

         end
         S1 : begin       
            if (ready) begin
               data_rg  <= sparebuff_rg       ;
               valid_rg <= sparebuff_valid_rg ;               
               ready_rg <= 1'b1               ;
               state <= S0                    ;               
            end

         end

      endcase

   end

end

assign ready   = s_ready || ~valid_rg ;
assign m_ready = ready_rg             ;
assign s_data  = data_rg              ;
assign s_valid = valid_rg             ;

endmodule

/*
module Backward #( parameter WIDTH = 8) (
        input              clk,
        input              rst_n,

        input              m_valid,
        output             m_ready,
        input [WIDTH-1:0]  m_data,

        output             s_valid,
        input              s_ready,
        output [WIDTH-1:0] s_data
        );

    reg                        reg_valid;
    wire                       reg_valid_in;
    reg                        reg_ready_out;
    wire                       reg_ready_in;
    wire                       reg_ns_data_in;
    wire                       pass_through;
    wire                       reg_valid_out;
    reg    [0:WIDTH-1]         reg_data;



always @(posedge clk)begin
    if(!rst_n)
    begin
		reg_valid <= 0;
		reg_ready_out <= 1'b1;
		reg_data <= {WIDTH{1'b0}};
    end
    else
    begin
        reg_ready_out <= (reg_ready_in||(reg_ns_data_in && ~reg_valid));//除气泡 数据存入寄存器且寄存器内无数据时，m_ready可为高
        if (reg_ready_out)//寄存器准备好接收数据
        begin
            reg_valid <= reg_valid_in;
            reg_data <= m_data;
        end
        else
        begin
            if (reg_valid_out && reg_ready_in)
                reg_valid <= 1'b0;
            else reg_valid <= reg_valid;
        end
    end
end



assign reg_ns_data_in = ~(reg_valid_in && reg_ready_out);//master握手不成功时为1，此时无数据进入寄存器

assign pass_through = m_ready && s_ready && ~reg_valid;//数据直通状态 ready一直为高时，只需valid为高即可直接进行握手

assign reg_valid_in = ~pass_through && m_valid;//数据直通时valid不存入寄存器

assign reg_valid_out = reg_valid;

assign reg_ready_in = s_ready;

assign m_ready = reg_ready_out;

//master和slave直接相连，不经过寄存器
assign s_valid = pass_through ? m_valid : reg_valid;
assign s_data = pass_through ? m_data : reg_data;

endmodule
*/