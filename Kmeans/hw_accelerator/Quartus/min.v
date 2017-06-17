module min(clock, reset, start, ack, stb, k, dim, mem_input_data, mem_a_address, mem_b_address, mem_write_enable, mem_a_output_data, mem_b_output_data, out);
input			clock, reset;
input			start, ack; 
input			[5:0] k; 
input			[9:0] dim;
output		stb;
output		[4:0] out;

input			[31:0] mem_a_output_data, mem_b_output_data;
output		[31:0] mem_input_data;
output		[8:0] mem_a_address;
output		[13:0] mem_b_address;
output		mem_write_enable;

wire			[63:0] sum;

wire			dis_start, dis_ack;
wire			dis_stb;
wire			[63:0] dis_out;

wire			mem_a_write_enable_1, mem_b_write_enable_1;
wire			[31:0] mem_a_input_data_1, mem_b_input_data_1;
wire			[8:0] mem_a_address_1, mem_b_address_1;
wire			[31:0]  mem_a_output_data_2, mem_b_output_data_2;

wire			[31:0] mem_a_output_data_1, mem_b_output_data_1;
wire			mem_write_enable_2;
wire			[31:0] mem_input_data_2;
wire			[8:0] mem_address_2;

reg			s_stb;
reg			[4:0] s_out;

reg			[8:0] s_mem_a_address;
reg			[13:0] s_mem_b_address;
reg			[5:0] s_k;
reg			[5:0] s_k_counter;
reg			[9:0] s_dim;
reg			[9:0] s_dim_counter;
reg			[13:0] s_b_address;

reg			s_dis_start, s_dis_ack;

reg			s_mem_a_write_enable_1, s_mem_b_write_enable_1;
reg			[31:0] s_mem_a_input_data_1, s_mem_b_input_data_1;
reg			[8:0] s_mem_a_address_1, s_mem_b_address_1;

reg			[63:0] s_min_distance;
reg			[4:0] s_min_index;

reg 			[4:0] s_state;
parameter 	idle = 5'd0,
				read_k_dim = 5'd1,
				read_input = 5'd2,
				read_a = 5'd3,
				read_a_set_address = 5'd4,
				read_a_read_wait = 5'd5,
				read_a_get_input = 5'd6,
				read_a_write_wait = 5'd7,
				read_a_write_input = 5'd8,
				read_b = 5'd9,
				read_b_point = 5'd10,
				read_b_set_address = 5'd11,
				read_b_read_wait = 5'd12,
				read_b_get_input = 5'd13,
				read_b_write_wait = 5'd14,
				read_b_write_input = 5'd15,
				distance_start = 5'd16,
				distance_wait = 5'd17,
				check_min = 5'd18,
				write_output = 5'd19,
				write_output_wait = 5'd20;
				
memory #(32,9) memory_a(mem_a_input_data_1, mem_input_data_2, mem_a_address_1, mem_address_2, mem_a_write_enable_1, mem_write_enable_2, clock, mem_a_output_data_1, mem_a_output_data_2);
memory #(32,9) memory_b(mem_b_input_data_1, mem_input_data_2, mem_b_address_1, mem_address_2, mem_b_write_enable_1, mem_write_enable_2, clock, mem_b_output_data_1, mem_b_output_data_2);

distance dis(clock, reset, dis_start, dis_ack, dis_stb, dim, mem_input_data_2, mem_address_2, mem_write_enable_2, mem_a_output_data_2, mem_b_output_data_2, dis_out);

always@ (posedge clock)
begin
	case(s_state)
	
		idle:
		begin
			if(start)
			begin
				s_stb <= 1'b0;
				
				s_dis_start <= 1'b0;
				s_dis_ack <= 1'b0;
				
				s_state <= read_k_dim;
			end
			
			else
			begin
				s_state <= idle;
			end
		end
		
		read_k_dim:
		begin
			s_k <= k;
			s_dim <= dim;
			s_state <= read_input;
		end
	
		read_input:
		begin
			s_k_counter <= 6'd0;
			s_dim_counter <= 10'd0;
			s_min_distance <= 64'b1111111111111111111111111111111111111111111111111111111111111111;
			s_min_index <= 5'd0;	
			s_state <= read_a;
		end
		
		read_a:
		begin
			if(s_dim_counter < s_dim)
			begin
				s_state <= read_a_set_address;
			end
			
			else
			begin
				s_state <= read_b;
			end
		end

		read_a_set_address:
		begin
			s_mem_a_address <= s_dim_counter[8:0];
			s_mem_a_address_1 <= s_dim_counter[8:0];
			s_state <= read_a_read_wait;
		end
		
		read_a_read_wait:
		begin
			s_state <= read_a_get_input;
		end
		
		read_a_get_input:
		begin
			s_mem_a_input_data_1 <= mem_a_output_data;
			s_mem_a_write_enable_1 <= 1'b1;
			s_state <= read_a_write_wait;
		end
		
		read_a_write_wait:
		begin
			s_state <= read_a_write_input;
		end
		
		read_a_write_input:
		begin
			s_mem_a_write_enable_1 <= 1'b0;
			s_dim_counter <= s_dim_counter + 10'd1;
			s_state <= read_a;
		end
		
		read_b:
		begin
			if(s_k_counter < s_k)
			begin
				s_dim_counter <= 9'd0;
				s_b_address <= s_k_counter << 9;
				s_state <= read_b_point;
			end
			
			else
			begin
				s_state <= write_output;
			end
		end
		
		read_b_point:
		begin
			if(s_dim_counter < s_dim)
			begin
				s_state <= read_b_set_address;
			end
			
			else
			begin
				s_state <= distance_start;
			end
		end

		read_b_set_address:
		begin
			s_mem_b_address <= s_b_address + s_dim_counter;
			s_mem_b_address_1 <= s_dim_counter[8:0];
			s_state <= read_b_read_wait;
		end
		
		read_b_read_wait:
		begin
			s_state <= read_b_get_input;
		end
		
		read_b_get_input:
		begin
			s_mem_b_input_data_1 <= mem_b_output_data;
			s_mem_b_write_enable_1 <= 1'b1;
			s_state <= read_b_write_wait;
		end
		
		read_b_write_wait:
		begin
			s_state <= read_b_write_input;
		end
		
		read_b_write_input:
		begin
			s_mem_b_write_enable_1 <= 1'b0;
			s_dim_counter <= s_dim_counter + 10'd1;
			s_state <= read_b_point;
		end
		
		distance_start:
		begin
			s_dis_start <= 1'b1;
			s_dis_ack <= 1'b0;
			s_state <= distance_wait;
		end
		
		distance_wait:
		begin
			if(dis_stb)
			begin
				s_dis_start <= 1'b0;
				s_dis_ack <= 1'b1;
				s_state <= check_min;
			end
			
			else
			begin
				s_state <= distance_wait;
			end
		end
		
		check_min:
		begin
			if(s_min_distance >= dis_out)
			begin
				s_min_distance <= dis_out;
				s_min_index <= s_k_counter[4:0];
			end
			
			else
			begin
				s_min_distance <= s_min_distance;
				s_min_index <= s_min_index;
			end
			
			s_k_counter <= s_k_counter + 5'd1;
			s_state <= read_b;
		end
		
		write_output:
		begin
			s_out <= s_min_index;
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
assign out = s_out;
assign mem_a_address = s_mem_a_address;
assign mem_b_address = s_mem_b_address;

assign dis_start = s_dis_start;
assign dis_ack = s_dis_ack;

assign mem_a_write_enable_1 = s_mem_a_write_enable_1;
assign mem_b_write_enable_1 = s_mem_b_write_enable_1;
assign mem_a_input_data_1 = s_mem_a_input_data_1;
assign mem_b_input_data_1 = s_mem_b_input_data_1;
assign mem_a_address_1 = s_mem_a_address_1;
assign mem_b_address_1 = s_mem_b_address_1;

assign mem_input_data = 32'd0;
assign mem_write_enable = 1'b0;

endmodule
