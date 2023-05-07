package FIFO_pkg ;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 512;

class FIFO_CLASS ;
	rand bit [15:0] data_in ;
	rand bit wr_en ;
	rand bit rd_en ;
	rand bit rst_n ;
	bit clk,full,almostfull,empty,almostempty,overflow,underflow,wr_ack;

	constraint my_constraints {
		data_in dist {16'hffff:/20,0:/20,[16'h0001:16'hfffe]:/60};
		wr_en dist {1:/70,0:/30};
		//rd_en dist {1:/20,0:/80};
		rst_n dist {1:=500,0:=1};
	}
	
	covergroup CovCode @(posedge clk);
		// coverpoint for operands 
		data_in_cp : coverpoint data_in {
			bins max = {16'hffff};
			bins zero = {0};
			bins others = default ;
		}
		
		full_cp : coverpoint full{
			bins full_1 = {1};
			bins full_0 = {0};
		}

		almostfull_cp : coverpoint almostfull{
			bins almostfull_1 = {1};
			bins almostfull_0 = {0};
		}
		empty_cp : coverpoint empty{
			bins empty_1 = {1};
			bins empty_0 = {0};
		}
		almostempty_cp : coverpoint almostempty{
			bins almostempty_1 = {1};
			bins almostempty_0 = {0};
		}
		overflow_cp : coverpoint overflow{
			bins overflow_1 = {1};
			bins overflow_0 = {0};
		}
		underflow_cp : coverpoint underflow{
			bins underflow_1 = {1};
			bins underflow_0 = {0};
		}
		wr_ack_cp : coverpoint wr_ack{
			bins underflow_1 = {1};
			bins underflow_0 = {0};
		}

	endgroup

	function new();
		CovCode = new();
	endfunction
	
endclass
endpackage 