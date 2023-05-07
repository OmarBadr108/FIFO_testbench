module top_FIFO();

// momken aktb hna clk

	FIFO_if f_if();
	FIFO DUT(f_if);
	FIFO_TB TB(f_if);
	FIFO_MON MONITOR(f_if);
	// bind FIFO FIFO_sva FIFO_sva_instance(f_if);
endmodule 