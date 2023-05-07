import FIFO_pkg::*;

module FIFO_TB(FIFO_if.TB f_if);
	FIFO_CLASS fifo_object ;
	//bit [FIFO_WIDTH-1:0] data_out_expected ;
	integer i ;
	integer error_write = 0 ;
	integer error_read = 0 ;
	initial begin
		fifo_object = new();
		@(negedge f_if.clk);
		for(i=0;i<5000;i++)begin
			
			assert(fifo_object.randomize());
			// el 7agat deh bta5od el value ely fel interface we tdeh lel object 34an a3rf a3ml functional coverage (outputs)
			fifo_object.clk = f_if.clk ;
			fifo_object.full = f_if.full ;
			fifo_object.almostfull = f_if.almostfull ;
			fifo_object.empty = f_if.empty ;
			fifo_object.almostempty = f_if.almostempty ;
			fifo_object.overflow = f_if.overflow ;
			fifo_object.underflow = f_if.underflow ;
			fifo_object.wr_ack = f_if.wr_ack ;

			// el 7agat deh bta5od el value el randmomized mn el object tdeh lel interface (inputs)
			f_if.data_in = fifo_object.data_in;
			f_if.wr_en = fifo_object.wr_en;
			f_if.rd_en = ~(fifo_object.wr_en);
			f_if.rst_n = fifo_object.rst_n;


		 // queue block 
			if(~f_if.rst_n) begin
				f_if.data_out_golden = 0;
			// assertion for flags 
			end
			else begin

				//if (~f_if.full) begin // write operation 
					if(f_if.wr_en && (f_if.queue_fifo.size() <= FIFO_DEPTH))begin
						f_if.queue_fifo.push_back(fifo_object.data_in) ;
						// assertion line wr_ack ;
					end
					else if (~f_if.empty)begin // read operation
						if (f_if.rd_en && (f_if.queue_fifo.size() != 0))begin
							f_if.data_out_golden = f_if.queue_fifo.pop_back();
						end
					end
					check_answer();
				//end

			end 
		end
		$stop ;
	end
	task check_answer (); 
		@(negedge f_if.clk)
		 // testing write operation
		if(f_if.wr_en && (f_if.queue_fifo.size() <= FIFO_DEPTH)) begin
			 if (f_if.data_in != f_if.queue_fifo[$])begin
			 	$display("error message in write operation %t :data_in = %h, last_item_in_queue = %h",$time ,f_if.data_in,f_if.queue_fifo[$]);
			 	error_write++ ;
			 end
		end
		// testing read operation 
		else if (f_if.rd_en && (f_if.queue_fifo.size() != 0))begin 
			if (f_if.data_out != f_if.data_out_golden) begin
				$display("error message in read operation %t :data_out_design = %h, data_out_golden = %h",$time ,f_if.data_out ,f_if.data_out_golden);
				error_read++ ;
			end
		end
			
	endtask
		
	// ASSERTIONS

	// 1- wr_ack flag
	property wr_ack_flag ;
		@(posedge f_if.clk)(~f_if.full && f_if.wr_en && (f_if.queue_fifo.size() < FIFO_DEPTH))|-> ##[0:2] f_if.wr_ack;
	endproperty
		wr_ack_flag_lb : assert property (wr_ack_flag) $display("wr_ack PASS"); 
												  else $info ("wr_ack failed") ;

// 2- almostfull flag 
	property almostfull_flag ;
		@(posedge f_if.clk)(f_if.queue_fifo.size() == FIFO_DEPTH-1)|-> f_if.almostfull ;
	endproperty
		almostfull_flag_lb : assert property (almostfull_flag) $display("almostfull PASS");
														  else $info("almostfull failed") ;

// 3- full_flag 
	property full_flag ;
		@(posedge f_if.clk)(f_if.queue_fifo.size() == FIFO_DEPTH)|-> f_if.full ;
	endproperty
		full_flag_lb : assert property (almostfull_flag) $display("full PASS");
													else $info("full failed") ;

// 4- almostempty_flag 
	property almostempty_flag ;
		@(posedge f_if.clk)(f_if.queue_fifo.size() == 1)|-> f_if.almostempty ;
	endproperty
		almostempty_flag_lb : assert property (almostfull_flag) $display("almostempty PASS");
														   else $info("almostempty failed") ;

// 5- empty_flag 
	property empty_flag ;
		@(posedge f_if.clk)(f_if.queue_fifo.size() == 0)|-> f_if.empty ;
	endproperty
		empty_flag_lb : assert property (almostfull_flag) $display("empty PASS");
												     else $info("empty failed") ;

// 6- overflow 
	property overflow_flag ;
		@(posedge f_if.clk)(f_if.full && f_if.wr_en)|-> f_if.overflow ;
	endproperty
		overflow_flag_lb : assert property (almostfull_flag) $display("overflow PASS");
													    else $info("overflow failed") ;

// 7- underflow 
	property underflow_flag ;
		@(posedge f_if.clk)(f_if.empty && f_if.rd_en)|-> f_if.underflow ;
	endproperty
		underflow_flag_lb : assert property (almostfull_flag) $display("underflow PASS");
													     else $info("underflow failed") ;


endmodule