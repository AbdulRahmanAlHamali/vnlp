module VNLP (
		output
			Done,
			[7:0] Len,
			[27:0] Result,
		input
			Start,
			Reset,
			Clk);
	
	wire [8:0] MemAdd1;
	wire [8:0] MemAdd2;
	wire DP_Done;
	wire [9:0] MemData1;
	wire [9:0] MemData2;
	wire reset_nextRef;
	wire reset_prevReg;
	wire reset_sumReg;
	wire reset_memRegs;
	wire reset_multRegs;
	wire reset_accReg;
	wire reset_lenReg;
	wire load_nextReg;
	wire load_prevReg;
	wire load_sumReg;
	wire load_multRegs;
	wire load_accReg;
	wire load_lenReg;
	wire mux_memAdd;
	wire mux_npAdders;
	wire mux_comparator;
	wire [2:0] load_memRegs;
	wire [2:0] mux_adder;

	DataPath DP(
		.MemAdd1(MemAdd1),
		.MemAdd2(MemAdd2),
		.Result(Result),
		.Len(Len),
		.Done(DP_Done),
		.MemData1(MemData1),
		.MemData2(MemData2),
		.reset_nextReg(reset_nextReg),
		.reset_prevReg(reset_prevReg),
		.reset_sumReg(reset_sumReg),
		.reset_memRegs(reset_memRegs),
		.reset_multRegs(reset_multRegs),
		.reset_accReg(reset_accReg),
		.reset_lenReg(reset_lenReg),
		.load_nextReg(load_nextReg),
		.load_prevReg(load_prevReg),
		.load_sumReg(load_sumReg),
		.load_multRegs(load_multRegs),
		.load_accReg(load_accReg),
		.load_lenReg(load_lenReg),
		.mux_memAdd(mux_memAdd),
		.mux_npAdders(mux_npAdders),
		.mux_comparator(mux_comparator),
		.done(DP_Done),
		.Clk(Clk),
		.mux_adder(mux_adder),
		.load_memRegs(load_memRegs));

	ControlPath CP(
		.reset_nextReg(reset_nextReg),
		.reset_prevReg(reset_prevReg),
		.reset_sumReg(reset_sumReg),
		.reset_memRegs(reset_memRegs),
		.reset_multRegs(reset_multRegs),
		.reset_accReg(reset_accReg),
		.reset_lenReg(reset_lenReg),
		.load_nextReg(load_nextReg),
		.load_prevReg(load_prevReg),
		.load_sumReg(load_sumReg),
		.load_multRegs(load_multRegs),
		.load_accReg(load_accReg),
		.load_memRegs(load_memRegs),
		.load_lenReg(load_lenReg),
		.mux_adder(mux_adder),
		.mux_memAdd(mux_memAdd),
		.mux_npAdders(mux_npAdders),
		.mux_comparator(mux_comparator),
		.done(Done),	
		.reset(Reset),
		.start(Start),
		.dp_done(DP_Done),
		.clk(Clk));

	Memory M( 
		.ReadData1(MemData1),
		.ReadData2(MemData2),
		.ReadAdd1(MemAdd1),
		.ReadAdd2(MemAdd2),
		.WriteData(),
		.WriteAdd(),
		.WriteEn(1'b0),
		.Clk(Clk));

endmodule
