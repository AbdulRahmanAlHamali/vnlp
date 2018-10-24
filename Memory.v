module Memory(
		output 
			[9:0] ReadData1,
			[9:0] ReadData2,
		input
			WriteEn,
			Clk,
			[8:0] ReadAdd1,
			[8:0] ReadAdd2,
			[9:0] WriteData,
			[8:0] WriteAdd);

	reg [9:0] Data[511:0];

	always @(posedge Clk)
	begin
		if (WriteEn)
			Data[WriteAdd]<= WriteData;
	end
	
	//Write to read forwarding is not enabled here
	assign ReadData1= Data[ReadAdd1];
	assign ReadData2= Data[ReadAdd2];
endmodule

