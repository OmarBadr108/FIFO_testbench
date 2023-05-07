import FIFO_pkg::*;

interface FIFO_if();

	bit clk;
	always #1 clk = ~clk ;

	bit [FIFO_WIDTH-1:0] data_in ;
	bit [FIFO_WIDTH-1:0] data_out ;
	bit [FIFO_WIDTH-1:0] data_out_golden;
	bit full,almostfull,empty,almostempty,overflow,underflow,wr_ack,wr_en,rd_en,rst_n;

	bit [FIFO_WIDTH-1:0] queue_fifo[$];


	modport TB (input clk,data_out,full,almostfull,empty,almostempty,overflow,underflow,wr_ack,
			    output data_in,wr_en,rd_en,rst_n,queue_fifo,data_out_golden);

	modport DUT (input clk,data_in,wr_en,rd_en,rst_n,
			    output data_out,full,almostfull,empty,almostempty,overflow,underflow,wr_ack);

	//modport GOLDEN (input clk,data_in,wr_en,rd_en,rst_n,queue_fifo,
		 //output data_out_golden,full,almostfull,empty,almostempty,overflow,underflow,wr_ack);

	modport MONITOR(input clk,data_in,wr_en,rd_en,rst_n,data_out,full,almostfull,empty,almostempty,overflow,underflow,wr_ack,data_out_golden);

endinterface