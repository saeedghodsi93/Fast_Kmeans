module distance(clock, reset, 
				start, ack, stb, dim,
				mem_input_data, mem_address, mem_write_enable, mem_a_output_data, mem_b_output_data, out);
input 		clock, reset;
input			start, ack; 
output		stb;
input			[9:0] dim;
input			[31:0] mem_a_output_data, mem_b_output_data;
output		[31:0] mem_input_data;
output		[8:0] mem_address;
output		mem_write_enable;
output		[63:0] out;

wire			core_start;
wire			core_ack;
wire			[31:0] core_1_a, core_2_a, core_3_a, core_4_a;
wire			[31:0] core_1_b, core_2_b, core_3_b, core_4_b;
wire			core_stb, core_1_stb, core_2_stb, core_3_stb, core_4_stb;
wire			[63:0] core_1_z, core_2_z, core_3_z, core_4_z;

wire			add_1_start;
wire			add_1_ack;
wire			[63:0] add_1_1_a, add_1_2_a;
wire			[63:0] add_1_1_b, add_1_2_b; 
wire			add_1_stb, add_1_1_stb, add_1_2_stb; 
wire			[63:0] add_1_1_z, add_1_2_z;

wire			add_2_start;
wire			add_2_ack;
wire			[63:0] add_2_1_a;
wire			[63:0] add_2_1_b; 
wire			add_2_stb, add_2_1_stb; 
wire			[63:0] add_2_1_z;

wire			add_3_start;
wire			add_3_ack;
wire			[63:0] add_3_1_a;
wire			[63:0] add_3_1_b; 
wire			add_3_stb, add_3_1_stb; 
wire			[63:0] add_3_1_z;

reg			s_stb;
reg			[63:0] s_sum;
reg			[9:0] s_dim, s_dim_counter;
reg			[8:0] s_mem_address;
reg			s_mem_write_enable;
reg			[63:0] s_out;

reg			s_core_start;
reg			s_core_ack;
reg			[31:0] s_core_1_a, s_core_2_a, s_core_3_a, s_core_4_a;
reg			[31:0] s_core_1_b, s_core_2_b, s_core_3_b, s_core_4_b;

reg			s_add_1_start;
reg			s_add_1_ack;
reg			[63:0] s_add_1_1_a, s_add_1_2_a;
reg			[63:0] s_add_1_1_b, s_add_1_2_b; 

reg			s_add_2_start;
reg			s_add_2_ack;
reg			[63:0] s_add_2_1_a;
reg			[63:0] s_add_2_1_b; 

reg			s_add_3_start;
reg			s_add_3_ack;
reg			[63:0] s_add_3_1_a;
reg			[63:0] s_add_3_1_b; 

reg 			[4:0] s_state;
parameter 	idle = 5'd0,
				read_dim = 5'd1,
				read_input = 5'd2,
				read_input_1_set_address = 5'd3,
				read_input_1_data_ready = 5'd4,
				read_input_1_get_input = 5'd5,
				read_input_2_set_address = 5'd6,
				read_input_2_data_ready = 5'd7,
				read_input_2_get_input = 5'd8,
				read_input_3_set_address = 5'd9,
				read_input_3_data_ready = 5'd10,
				read_input_3_get_input = 5'd11,
				read_input_4_set_address = 5'd12,
				read_input_4_data_ready = 5'd13,
				read_input_4_get_input = 5'd14,
				calculate_distance = 5'd15,
				distance_core_start = 5'd16,
				distance_core_wait = 5'd17,
				adder_1_start = 5'd18,
				adder_1_wait = 5'd19,
				adder_2_start = 5'd20,
				adder_2_wait = 5'd21,
				adder_3_start = 5'd22,
				adder_3_wait = 5'd23,
				read_next_data = 5'd24,
				write_output = 5'd25,
				write_output_wait = 5'd26;
				
distance_core core_1(clock, reset, core_start, core_ack, core_1_a, core_1_b, core_1_stb, core_1_z);	
distance_core core_2(clock, reset, core_start, core_ack, core_2_a, core_2_b, core_2_stb, core_2_z);
distance_core core_3(clock, reset, core_start, core_ack, core_3_a, core_3_b, core_3_stb, core_3_z);
distance_core core_4(clock, reset, core_start, core_ack, core_4_a, core_4_b, core_4_stb, core_4_z);
		
adder add_1_1(clock, reset, add_1_start, add_1_ack, add_1_1_a, add_1_1_b, add_1_1_stb, add_1_1_z);
adder add_1_2(clock, reset, add_1_start, add_1_ack, add_1_2_a, add_1_2_b, add_1_2_stb, add_1_2_z);

adder add_2_1(clock, reset, add_2_start, add_2_ack, add_2_1_a, add_2_1_b, add_2_1_stb, add_2_1_z);

adder add_3_1(clock, reset, add_3_start, add_3_ack, add_3_1_a, add_3_1_b, add_3_1_stb, add_3_1_z);

always@ (posedge clock)
begin
	case(s_state)
	
		idle:
		begin
			if(start)
			begin
				s_sum <= 64'd0;
				s_stb <= 1'b0;
				
				s_core_1_a <= 32'd0;
				s_core_1_b <= 32'd0;
				s_core_2_a <= 32'd0;
				s_core_2_b <= 32'd0;
				s_core_3_a <= 32'd0;
				s_core_3_b <= 32'd0;
				s_core_4_a <= 32'd0;
				s_core_4_b <= 32'd0;	
				s_core_start <= 1'b0;
				s_core_ack <= 1'b0;
				
				s_add_1_start <= 1'b0;
				s_add_1_ack <= 1'b0;
				
				s_add_2_start <= 1'b0;
				s_add_2_ack <= 1'b0;
				
				s_add_3_start <= 1'b0;
				s_add_3_ack <= 1'b0;
				
				s_state <= read_dim;
			end
			
			else
			begin
				s_state <= idle;
			end
		end
		
		read_dim:
		begin
			s_dim <= dim;
			s_dim_counter <= 10'd0;
			s_state <= read_input;
		end
	
		read_input:
		begin
			if(s_dim_counter < s_dim)
			begin
				s_state <= read_input_1_set_address;
			end
			
			else
			begin
				s_state <= write_output;
			end
		end
		
		read_input_1_set_address:
		begin
			s_mem_address <= s_dim_counter[8:0];
			s_state <= read_input_1_data_ready;
		end
		
		read_input_1_data_ready:
		begin
			s_state <= read_input_1_get_input;
		end
		
		read_input_1_get_input:
		begin
			s_core_1_a <= mem_a_output_data;
			s_core_1_b <= mem_b_output_data;
			s_dim_counter <= s_dim_counter + 9'd1;
			s_state <= read_input_2_set_address;
		end
		
		read_input_2_set_address:
		begin
			s_mem_address <= s_dim_counter[8:0];
			s_state <= read_input_2_data_ready;
		end
		
		read_input_2_data_ready:
		begin
			s_state <= read_input_2_get_input;
		end
		
		read_input_2_get_input:
		begin
			s_core_2_a <= mem_a_output_data;
			s_core_2_b <= mem_b_output_data;
			s_dim_counter <= s_dim_counter + 9'd1;
			s_state <= read_input_3_set_address;
		end
		
		read_input_3_set_address:
		begin
			s_mem_address <= s_dim_counter[8:0];
			s_state <= read_input_3_data_ready;
		end
		
		read_input_3_data_ready:
		begin
			s_state <= read_input_3_get_input;
		end
		
		read_input_3_get_input:
		begin
			s_core_3_a <= mem_a_output_data;
			s_core_3_b <= mem_b_output_data;
			s_dim_counter <= s_dim_counter + 9'd1;
			s_state <= read_input_4_set_address;
		end
		
		read_input_4_set_address:
		begin
			s_mem_address <= s_dim_counter[8:0];
			s_state <= read_input_4_data_ready;
		end
		
		read_input_4_data_ready:
		begin
			s_state <= read_input_4_get_input;
		end
		
		read_input_4_get_input:
		begin
			s_core_4_a <= mem_a_output_data;
			s_core_4_b <= mem_b_output_data;
			s_dim_counter <= s_dim_counter + 9'd1;
			s_state <= calculate_distance;
		end
		
		calculate_distance:
		begin
			s_core_ack <= 1'b0;
			s_add_1_ack <= 1'b0;
			s_add_2_ack <= 1'b0;
			s_add_3_ack <= 1'b0;
			s_state <= distance_core_start;
		end
		
		distance_core_start:
		begin
			s_core_start <= 1'b1;
			s_state <= distance_core_wait;
		end
		
		distance_core_wait:
		begin
			if(core_stb)
			begin
				s_add_1_1_a <= core_1_z;
				s_add_1_1_b <= core_2_z;
				s_add_1_2_a <= core_3_z;
				s_add_1_2_b <= core_4_z;
				s_core_start <= 1'b0;
				s_core_ack <= 1'b1;
				s_state <= adder_1_start;
			end
			
			else
			begin
				s_state <= distance_core_wait;
			end
		end
		
		adder_1_start:
		begin
			s_core_ack <= 1'b0;
			s_add_1_start <= 1'b1;
			s_state <= adder_1_wait;
		end
		
		adder_1_wait:
		begin
			if(add_1_stb)
			begin
				s_add_2_1_a <= add_1_1_z;
				s_add_2_1_b <= add_1_2_z;
				s_add_1_start <= 1'b0;
				s_add_1_ack <= 1'b1;
				s_state <= adder_2_start;
			end
			
			else
			begin
				s_state <= adder_1_wait;
			end
		end
		
		adder_2_start:
		begin
			s_add_1_ack <= 1'b0;
			s_add_2_start <= 1'b1;
			s_state <= adder_2_wait;
		end
		
		adder_2_wait:
		begin
			if(add_2_stb)
			begin
				s_add_3_1_a <= add_2_1_z;
				s_add_3_1_b <= s_sum;
				s_add_2_start <= 1'b0;
				s_add_2_ack <= 1'b1;
				s_state <= adder_3_start;
			end
			
			else
			begin
				s_state <= adder_2_wait;
			end
		end
		
		adder_3_start:
		begin
			s_add_2_ack <= 1'b0;
			s_add_3_start <= 1'b1;
			s_state <= adder_3_wait;
		end
		
		adder_3_wait:
		begin
			if(add_3_stb)
			begin
				s_sum <= add_3_1_z;
				s_add_3_start <= 1'b0;
				s_add_3_ack <= 1'b1;
				s_state <= read_next_data;
			end
			
			else
			begin
				s_state <= adder_3_wait;
			end
		end
		
		read_next_data:
		begin
			s_add_3_ack <= 1'b0;
			s_state <= read_input;
		end
		
		write_output:
		begin
			s_out <= s_sum;
			s_stb <= 1'b1;
			s_state <= write_output_wait;
		end
		
		write_output_wait:
		begin
			if(ack)
			begin
				s_stb <= 1'b0;
				s_state <= idle;
			end
			
			else
			begin
				s_state <= write_output_wait;
			end
		end
		
	endcase
	
	if(reset==1)
	begin
		s_state <= idle;
	end
end

assign stb = s_stb;
assign mem_address = s_mem_address;
assign mem_input_data = 32'd0;
assign mem_write_enable = 1'b0;
assign out = s_out;

assign core_start = s_core_start;
assign core_ack = s_core_ack;
assign core_1_a = s_core_1_a;
assign core_2_a = s_core_2_a;
assign core_3_a = s_core_3_a;
assign core_4_a = s_core_4_a;
assign core_1_b = s_core_1_b;
assign core_2_b = s_core_2_b;
assign core_3_b = s_core_3_b;
assign core_4_b = s_core_4_b;
assign core_stb = core_1_stb & core_2_stb & core_3_stb & core_4_stb;

assign add_1_start = s_add_1_start;
assign add_1_ack = s_add_1_ack;
assign add_1_1_a = s_add_1_1_a;
assign add_1_2_a = s_add_1_2_a;
assign add_1_1_b = s_add_1_1_b; 
assign add_1_2_b = s_add_1_2_b;
assign add_1_stb = add_1_1_stb & add_1_2_stb;

assign add_2_start = s_add_2_start;
assign add_2_ack = s_add_2_ack;
assign add_2_1_a = s_add_2_1_a;
assign add_2_1_b = s_add_2_1_b;
assign add_2_stb = add_2_1_stb;

assign add_3_start = s_add_3_start;
assign add_3_ack = s_add_3_ack;
assign add_3_1_a = s_add_3_1_a;
assign add_3_1_b = s_add_3_1_b; 
assign add_3_stb = add_3_1_stb;

endmodule
