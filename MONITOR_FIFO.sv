module FIFO_MON (FIFO_if.MONITOR f_if);
	always@(posedge f_if.clk) begin
		$display("data_in=%d,
			wr_en=%d ,
			rd_en = %s ,
			rst_n = %d,
			data_out = %d,
			data_out_golden = %d,
			
			full = %d,
			almostfull = %d,
			empty = %d,
			almostempty = %d,
			overflow = %d,
			underflow = %d,
			wr_ack = %d" 
			,
			f_if.data_in,
			f_if.wr_en,
			f_if.rd_en,
			f_if.rst_n,
			f_if.data_out,
			f_if.data_out_golden,
			
			f_if.full,
			f_if.almostfull,
			f_if.empty,
			f_if.almostempty,
			f_if.overflow,
			f_if.underflow,
			f_if.wr_ack);
	end
endmodule 