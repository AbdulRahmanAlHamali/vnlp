module DataPath(
		output
			Done,
			[8:0] MemAdd1,
			[8:0] MemAdd2,
			[27:0] Result,
			[7:0] Len,
		input
			reset_nextReg,
			reset_prevReg,
			reset_sumReg,
			reset_memRegs,
			reset_multRegs,
			reset_accReg,
			reset_lenReg,
			load_nextReg,
			load_prevReg,
			load_sumReg,
			load_multRegs,
			load_accReg,
			load_lenReg,
			mux_memAdd,
			mux_npAdders,
			mux_comparator,
			done,
			Clk,
			[2:0] mux_adder,
			[2:0] load_memRegs,
			[9:0] MemData1,
			[9:0] MemData2);

	wire [8:0]	muxMemAdd1_out;
	wire [8:0]	muxMemAdd2_out;
	wire [8:0]	muxMemAdd1_in0;
	wire [8:0]	muxMemAdd1_in1;
	wire [8:0]	muxMemAdd2_in0;
	wire [8:0]	muxMemAdd2_in1;
	wire [8:0]	nextVal;
	wire [8:0]	prevVal;
	wire [8:0]	adder2_in1;
	wire [8:0]	adder2_in2;
	wire [8:0]	adder2;
	wire [8:0]	adder13_in1;
	wire [8:0]	adder13_in2;
	wire [8:0]	adder13;
	wire [8:0]	nextPlusOne;
	wire [8:0]	muxComp_in0;
	wire [8:0]	muxComp_in1;
	wire [8:0]	comp_in1;
	wire [8:0]	comp_in2;
	wire [27:0]	sumAdder_in1;
	wire [27:0]	sumAdder_in2;
	wire [27:0]	sumAdder_out;
	wire [39:0]	muxAdder_in [2:0];
	wire [20:0]	mainAdderOut;
	wire [39:0]	mainAdderIns;
	wire [19:0]	squarePair0_in;
	wire [19:0]	squarePair1_in;
	wire [19:0]	squarePair2_in;
	wire [19:0]	squarePair3_in;
	wire [19:0]	squarePair4_in;
	wire [19:0]	squarePair5_in;
	wire [39:0]	squarePair0_out;
	wire [39:0]	squarePair1_out;
	wire [39:0]	squarePair2_out;
	wire [39:0]	squarePair3_out;
	wire [39:0]	squarePair4_out;
	wire [39:0]	squarePair5_out;
	wire [20:0]	accValue;
	wire [7:0]	lenValue;
	wire [7:0]	lenAdder_out;

	RegisterUnit#(.Size(9), .ResetValue(0)) Next(.Value(nextVal), .Reset(reset_nextReg), .Load(load_nextReg), .DataIn(MemData1[8:0]), .Clk(Clk));
	RegisterUnit#(.Size(9), .ResetValue(1)) Prev(.Value(prevVal), .Reset(reset_prevReg), .Load(load_prevReg), .DataIn(MemData2[8:0]), .Clk(Clk));
	RegisterUnit#(.Size(28), .ResetValue(0)) Sum(.Value(sumAdder_in2), .Reset(reset_sumReg), .Load(load_sumReg), .DataIn(sumAdder_out), .Clk(Clk));
	RegisterUnit#(.Size(20), .ResetValue(0)) SquarePair0Input(.Value(squarePair0_in), .Reset(reset_memRegs), .Load(load_memRegs[0]), .DataIn({MemData2, MemData1}), .Clk(Clk));
	RegisterUnit#(.Size(20), .ResetValue(0)) SquarePair1Input(.Value(squarePair1_in), .Reset(reset_memRegs), .Load(load_memRegs[1]), .DataIn({MemData2, MemData1}), .Clk(Clk));
	RegisterUnit#(.Size(20), .ResetValue(0)) SquarePair2Input(.Value(squarePair2_in), .Reset(reset_memRegs), .Load(load_memRegs[2]), .DataIn({MemData2, MemData1}), .Clk(Clk));
	RegisterUnit#(.Size(40), .ResetValue(0)) SquarePair0Output(.Value(muxAdder_in[0]), .Reset(reset_multRegs), .Load(load_multRegs), .DataIn(squarePair0_out), .Clk(Clk));
	RegisterUnit#(.Size(40), .ResetValue(0)) SquarePair1Output(.Value(muxAdder_in[1]), .Reset(reset_multRegs), .Load(load_multRegs), .DataIn(squarePair1_out), .Clk(Clk));
	RegisterUnit#(.Size(40), .ResetValue(0)) SquarePair2Output(.Value(muxAdder_in[2]), .Reset(reset_multRegs), .Load(load_multRegs), .DataIn(squarePair2_out), .Clk(Clk));
	RegisterUnit#(.Size(21), .ResetValue(0)) AccReg(.Value(accValue), .Reset(reset_accReg), .Load(load_accReg), .DataIn(mainAdderOut), .Clk(Clk));
	RegisterUnit#(.Size(8), .ResetValue(0)) LenReg(.Value(lenValue), .Reset(reset_lenReg), .Load(load_lenReg), .DataIn(lenAdder_out), .Clk(Clk));

	SquarePair SquarePair0(.Result(squarePair0_out), .Data(squarePair0_in));
	SquarePair SquarePair1(.Result(squarePair1_out), .Data(squarePair1_in));
	SquarePair SquarePair2(.Result(squarePair2_out), .Data(squarePair2_in));
	
	assign muxMemAdd1_in0= nextVal;
	assign muxMemAdd2_in0= prevVal;
	assign muxMemAdd1_in1= adder2;
	assign muxMemAdd2_in1= adder13;
	assign muxMemAdd1_out= mux_memAdd? muxMemAdd1_in1 : muxMemAdd1_in0;
	assign muxMemAdd2_out= mux_memAdd? muxMemAdd2_in1 : muxMemAdd2_in0;
	assign MemAdd1= muxMemAdd1_out;
	assign MemAdd2= muxMemAdd2_out;

	assign adder2_in1= mux_npAdders? prevVal: nextVal;
	assign adder2_in2= 2;
	assign adder2= adder2_in1 + adder2_in2;

	assign adder13_in1= mux_npAdders? prevVal: nextVal;
	assign adder13_in2= mux_npAdders? 1: 3;
	assign adder13= adder13_in1 + adder13_in2;

	assign muxComp_in0= prevVal;
	assign muxComp_in1= MemData2[8:0];
	assign comp_in1= mux_comparator? muxComp_in1 : muxComp_in0;
	assign comp_in2= nextVal + 1;
	assign Done= (comp_in1 == comp_in2);

	assign mainAdderIns= mux_adder[0]? muxAdder_in[0] : 
			mux_adder[1]? muxAdder_in[1] :
			mux_adder[2]? muxAdder_in[2] : 40'h0000000000; 

	assign mainAdderOut= mainAdderIns[19:0] + mainAdderIns[39:20];

	assign sumAdder_in1= {6'b000000, accValue};
	assign sumAdder_out= sumAdder_in1 + sumAdder_in2;

	assign lenAdder_out= lenValue + 1;

	assign Result= sumAdder_in2;
	assign Len= lenValue;
endmodule

module RegisterUnit #(parameter Size= 8, parameter [Size-1:0] ResetValue= 0)(
		output
			[Size-1:0] Value,
		input
			Reset,
			Load,
			Clk,
			[Size-1:0] DataIn);
	reg [Size-1:0] Data;

	always @ (posedge Clk)
		if (Reset)
			Data= ResetValue;
		else if (Load)
			Data= DataIn;

	assign Value= Data;
endmodule

module SquarePair(
		output
			[39:0] Result,
		input
			[19:0] Data);


	wire signed [9:0] in1;
	wire signed [9:0] in2;

	assign in1= Data[9:0];
	assign in2= Data[19:10];

	assign Result[19:0]= in1 * in1;
	assign Result[39:20]= in2 * in2;

endmodule
