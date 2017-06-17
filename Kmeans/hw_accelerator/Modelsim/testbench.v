`timescale 1 ns/ 1 ns;
module testbench();
	reg 	FSL_Clk,
	reg	FSL_Rst,
	wire	FSL_S_Clk,
	reg	FSL_S_Read,
	reg	FSL_S_Data,
	wire	FSL_S_Control,
	wire	FSL_S_Exists,
	wire	FSL_M_Clk,
	wire	FSL_M_Write,
	wire	FSL_M_Data,
	wire	FSL_M_Control,
	wire	FSL_M_Full
	integer write_pointer;

	accelerator DUT(FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists,
		FSL_M_Clk,
		FSL_M_Write,
		FSL_M_Data,
		FSL_M_Control,
		FSL_M_Full);

	initial
	begin
		clock = 1'd0;
		reset = 1'd0;
		start = 1'd0;
		ack = 1'b0;
		write_pointer = $fopen ("Results.txt","w");
		#50 reset =  1'd1;
		#50 reset =  1'd0;

		#50 mem_a_input_data_1 = 32'd1;
		mem_a_address_1 = 9'd0;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd2;
		mem_a_address_1 = 9'd1;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd3;
		mem_a_address_1 = 9'd2;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd4;
		mem_a_address_1 = 9'd3;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd5;
		mem_a_address_1 = 9'd4;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd6;
		mem_a_address_1 = 9'd5;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd7;
		mem_a_address_1 = 9'd6;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;
		#50 mem_a_input_data_1 = 32'd8;
		mem_a_address_1 = 9'd7;
		mem_a_write_enable_1 = 1'b1;
		#50 mem_a_write_enable_1 = 1'b0;

		#50 mem_b_input_data_1 = 32'd4;
		mem_b_address_1 = 14'd0;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd5;
		mem_b_address_1 = 14'd1;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd6;
		mem_b_address_1 = 14'd2;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd7;
		mem_b_address_1 = 14'd3;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd8;
		mem_b_address_1 = 14'd4;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd9;
		mem_b_address_1 = 14'd5;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd10;
		mem_b_address_1 = 14'd6;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd11;
		mem_b_address_1 = 14'd7;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;

		#50 mem_b_input_data_1 = 32'd2;
		mem_b_address_1 = 14'd512;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd3;
		mem_b_address_1 = 14'd513;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd4;
		mem_b_address_1 = 14'd514;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd5;
		mem_b_address_1 = 14'd515;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd6;
		mem_b_address_1 = 14'd516;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd7;
		mem_b_address_1 = 14'd517;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd8;
		mem_b_address_1 = 14'd518;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd9;
		mem_b_address_1 = 14'd519;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;


		#50 mem_b_input_data_1 = 32'd3;
		mem_b_address_1 = 14'd1024;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd4;
		mem_b_address_1 = 14'd1025;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd5;
		mem_b_address_1 = 14'd1026;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd6;
		mem_b_address_1 = 14'd1027;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd7;
		mem_b_address_1 = 14'd1028;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd8;
		mem_b_address_1 = 14'd1029;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd9;
		mem_b_address_1 = 14'd1030;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;
		#50 mem_b_input_data_1 = 32'd10;
		mem_b_address_1 = 14'd1031;
		mem_b_write_enable_1 = 1'b1;
		#50 mem_b_write_enable_1 = 1'b0;

		k = 6'd3;
		dim = 10'd8;
		#50 start = 1'b1;
	end

	always 
	begin
		#5 clock =  ~clock;
	end

	always @(posedge clock) 
	begin
		if(stb)
		begin
			#50 start = 1'b0;
			#50 ack = 1'b1;
			#50 ack = 1'b0;
		end
	end

	always @(posedge clock) 
	begin
		#1 $fwrite (write_pointer, "reset=%d,\t start=%d,\t ack=%d,\t stb=%b,\t mem_a_output_data=%d,\t mem_b_output_data=%d,\t mem_a_address=%d,\t mem_b_address=%d,\t out=%d\n", reset, start, ack, stb, mem_a_output_data_2, mem_b_output_data_2, mem_a_address_2, mem_b_address_2, out);
	end

endmodule
