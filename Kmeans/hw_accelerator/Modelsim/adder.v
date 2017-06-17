module adder(clock, reset, start, ack, a, b, stb, z);
input 		clock, reset, start, ack;
input 		[63:0] a;
input 		[63:0] b;
output		stb;
output 		[63:0] z;

wire     	[63:0] input_a;
wire     	input_a_stb;
wire    		input_a_ack;
wire     	[63:0] input_b;
wire     	input_b_stb;
wire    		input_b_ack;
wire    		[63:0] output_z;
wire    		output_z_stb;
wire     	output_z_ack;
reg       	[63:0] s_input_a;
reg       	s_input_a_stb;
reg       	[63:0] s_input_b;
reg       	s_input_b_stb;
reg    		[63:0] s_z;
reg			s_output_z_ack;
reg			s_stb;
reg 			[2:0] s_state;
parameter 	idle = 3'd0,
				write_a = 3'd1,
				write_b = 3'd2,
				read = 3'd3,
				wait_for_ack = 3'd4;

adder_core 	add(
				input_a,
				input_b,
				input_a_stb,
				input_b_stb,
				output_z_ack,
				clock,
				reset,
				output_z,
				output_z_stb,
				input_a_ack,
				input_b_ack);
			
always@ (posedge clock)
begin
	case(s_state)
	
		idle:
		begin
			if(start)
			begin
				s_stb <= 0;
				s_input_a_stb <= 0;
				s_input_b_stb <= 0;
				s_output_z_ack <= 0;
				s_state <= write_a;
			end
			
			else
			begin
				s_state <= idle;
			end
		end
		
		write_a:
		begin
			if(input_a_ack)
			begin
				s_input_a <= a;
				s_input_a_stb <= 1;
				s_state <= write_b;
			end
			
			else
			begin
				s_state <= write_a;
			end
		end
	
		write_b:
		begin
			if(input_b_ack)
			begin
				s_input_b <= b;
				s_input_b_stb <= 1;
				s_state <= read;
			end
			
			else
			begin
				s_state <= write_b;
			end
		end
		
		read:
		begin
			if(output_z_stb)
			begin
				s_z <= output_z;
				s_input_a_stb <= 0;
				s_input_b_stb <= 0;
				s_output_z_ack <= 1;
				s_stb <= 1;
				s_state <= wait_for_ack;
			end
			
			else
			begin
				s_state <= read;
			end
		end
		
		wait_for_ack:
		begin
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

assign input_a = s_input_a;
assign input_a_stb = s_input_a_stb;
assign input_b = s_input_b;
assign input_b_stb = s_input_b_stb;
assign output_z_ack = s_output_z_ack;
assign z = s_z;
assign stb = s_stb;

endmodule
