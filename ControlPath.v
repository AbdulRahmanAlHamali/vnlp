module ControlPath(
		output
			reg [2:0] mux_adder,
			reg [2:0] load_memRegs,
			reg reset_nextReg,
			reg reset_prevReg,
			reg reset_sumReg,
			reg reset_memRegs,
			reg reset_multRegs,
			reg reset_accReg,
			reg reset_lenReg,
			reg load_nextReg,
			reg load_prevReg,
			reg load_sumReg,
			reg load_multRegs,
			reg load_accReg,
			reg load_lenReg,
			reg mux_memAdd,
			reg mux_npAdders,
			reg mux_comparator,
			reg done,
		input
			reset,
			start,
			dp_done,
			clk);

	parameter	S_Idle= 2'b00;
	parameter	S_readNext= 2'b01;
	parameter	S_movePointers= 2'b10;
	parameter	S_readPrev= 2'b11;

	reg [1:0] currentState;
	reg [1:0] nextState;
	
	reg [2:0] finishUpCounter;
	reg reset_finishUpCounter;
	reg fullyDone;
	reg [3:0] currentMultiplier;
	reg finishing;

	always @(posedge clk or posedge reset)
		if (reset)
			currentState<= S_Idle;		
		else
			currentState<= nextState;
	
	always @(*)
	begin
		reset_nextReg= 0;
		reset_prevReg= 0;
		reset_sumReg= 0;
		reset_memRegs= 0;
		reset_multRegs= 0;
		reset_accReg= 0;
		reset_lenReg= 0;
		load_nextReg= 0;
		load_prevReg= 0;
		load_sumReg= 0;
		load_multRegs= 1;
		load_accReg= 0;
		load_memRegs= 0;
		load_lenReg= 0;
		mux_adder= 0;
		mux_memAdd= 0;
		mux_npAdders= 0;
		mux_comparator= 0;
		done= 0;

		reset_finishUpCounter= 0;

		case (currentState)
		S_Idle:
		begin	
			done= 1;
			finishing<= 0;
			if (start)
			begin
				reset_nextReg= 1;
				reset_prevReg= 1;
				reset_sumReg= 1;
				reset_memRegs= 1;
				reset_multRegs= 1;
				reset_accReg= 1;
				reset_lenReg= 1;

				currentMultiplier= 0;
				fullyDone= 0;

				nextState= S_readNext;
			end
			else
				nextState= S_Idle;
		end
		S_readNext:
		begin
			if (fullyDone)
			begin
				done= 1;
				nextState= S_Idle;
			end
			else
			begin
				mux_memAdd= 1;
				mux_npAdders= 0;
				load_sumReg= 1;
				
				if (!finishing)
					load_lenReg= 1;
				
				case (currentMultiplier)
				1:
					load_memRegs= 3'b001;
				4:
					load_memRegs= 3'b100;
				7:
					load_memRegs= 3'b010;
				default:
					load_memRegs= 3'b000;
				endcase

				nextState= S_movePointers;
			end
		end
		S_movePointers:
		begin
			if (fullyDone)
			begin
				done= 1;
				nextState= S_Idle;
			end
			else
			begin
				mux_memAdd= 0;
				mux_comparator= 1;
				load_accReg= 1;
				load_nextReg= 1;
				load_prevReg= 1;

				if (dp_done)
				begin
					if (!finishing)
					begin
						reset_finishUpCounter= 1;
						finishUpCounter= 5;		
					end
				end

				case (currentMultiplier)
				2:
					mux_adder= 3'b001;
				5:
					mux_adder= 3'b100;
				8:
					mux_adder= 3'b010;
				default:
					mux_adder= 3'b000;
				endcase

				nextState= S_readPrev;
			end
		end
		S_readPrev:
		begin
			if (fullyDone)
			begin
				done= 1;
				nextState= S_Idle;
			end
			else
			begin
				mux_memAdd= 1;
				mux_npAdders= 1;
				load_accReg= 1;
				load_sumReg= 1;
				
				if (!finishing)
					load_lenReg= 1;

				if (dp_done)
				begin
					if (!finishing)
					begin
						finishUpCounter= 6;
						reset_finishUpCounter= 1;
					end
				end
				
				case (currentMultiplier)
				3:
				begin
					load_memRegs= 3'b010;
					mux_adder= 3'b010;
				end
				6:
				begin
					load_memRegs= 3'b001;
					mux_adder= 3'b001;
				end
				9:
				begin
					load_memRegs= 3'b100;
					mux_adder= 3'b100;
				end
				default:
				begin
					load_memRegs= 3'b000;
					mux_adder= 3'b000;
				end
				endcase

				nextState= S_readNext;
			end
		end

		default:
			nextState= S_Idle;
		endcase
	end

/*
	always @ (posedge clk)
	begin
		if (reset_startUpCounter)
		begin
			startUpCounter= 0;
			starting= 1;
		end
		else
		begin
			startUpCounter= startUpCounter + 1;
			if (startUpCounter == 0)
				starting= 0;
		end
	end
*/

	
	always @ (posedge clk)	//To determine when done
	begin
		if (reset_finishUpCounter)
		begin
			finishing= 1;
		end
		if (finishing)
		begin
			finishUpCounter<= finishUpCounter - 1;
			if (finishUpCounter == 0)
			begin
				fullyDone<= 1;
				finishing= 0;
			end
		end
	end

	always @ (posedge clk)
	begin
		currentMultiplier<= currentMultiplier + 1;
		if (currentMultiplier == 4'b1001)
			currentMultiplier<= 1;
	end
endmodule
