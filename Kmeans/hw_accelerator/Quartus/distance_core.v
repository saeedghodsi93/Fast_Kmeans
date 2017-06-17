module distance_core(clock, reset, start, ack, a, b, stb, z);
input 		clock, reset, start, ack;
input 		[31:0] a;
input 		[31:0] b;
output		stb;
output 		[63:0] z;

wire			subtractor_start;
wire			subtractor_stb;
wire			subtractor_ack;
wire			[63:0] input_a;
wire			[63:0] input_b;
wire     	[63:0] output_sub;
wire			square_start;
wire			square_stb;
wire			square_ack;
wire     	[63:0] input_sub;
wire			[63:0] output_z;
reg			s_subtractor_start;
reg			s_subtractor_ack;
reg			[63:0] s_input_a;
reg			[63:0] s_input_b;
reg			s_square_start;
reg			s_square_ack;
reg			[63:0] s_input_sub;
reg			s_stb;
reg    		[63:0] s_z;
reg 			[2:0] s_state;
parameter 	idle = 3'd0,
				write_subtractor = 3'd1,
				read_subtractor = 3'd2,
				read_square = 3'd3,
				wait_for_ack = 3'd4;
				
subtractor sub(clock, reset, subtractor_start, subtractor_ack, input_a, input_b, subtractor_stb, output_sub);
square sqr(clock, reset, square_start, square_ack, input_sub, square_stb, output_z);
			
always@ (posedge clock)
begin
	case(s_state)
	
		idle:
		begin
			if(start)
			begin
				s_stb <= 0;
				s_subtractor_start <= 0;
				s_square_start <= 0;
				s_state <= write_subtractor;
			end
			
			else
			begin
				s_state <= idle;
			end
		end
		
		write_subtractor:
		begin
			s_input_a <= {32'd0,a};
			s_input_b <= {32'd0,b};
			s_subtractor_start <= 1;
			s_state <= read_subtractor;
		end
	
		read_subtractor:
		begin
			s_subtractor_start <= 0;
			if(subtractor_stb)
			begin
				s_input_sub <= output_sub;
				s_subtractor_ack <= 1;
				s_square_start <= 1;
				s_state <= read_square;
			end
			
			else
			begin
				s_state <= read_subtractor;
			end
		end
		
		read_square:
		begin
			s_subtractor_ack <= 0;
			s_square_start <= 0;
			if(square_stb)
			begin
				s_z <= output_z;
				s_square_ack <= 1;
				s_stb <= 1;
				s_state <= wait_for_ack;
			end
			
			else
			begin
				s_state <= read_square;
			end
		end
		
		wait_for_ack:
		begin
			s_square_ack <= 0;
			if(ack)
			begin
				s_stb <= 0;
				s_state <= idle;
			end
			
			else
			begin
				s_state <= wait_for_ack;
			end
		end
	endcase
	
	if(reset==1)
	begin
		s_state <= idle;
	end
end

assign subtractor_start = s_subtractor_start;
assign subtractor_ack = s_subtractor_ack;
assign input_a = s_input_a;
assign input_b = s_input_b;
assign square_start = s_square_start;
assign square_ack = s_square_ack;
assign input_sub = s_input_sub;
assign stb = s_stb;
assign z = s_z;

endmodule
