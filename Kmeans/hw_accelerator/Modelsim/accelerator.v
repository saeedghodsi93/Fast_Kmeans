//----------------------------------------------------------------------------
// accelerator - module
//----------------------------------------------------------------------------
// IMPORTANT:
// DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
//
// SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
//
// TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
// PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
// OF THE USER_LOGIC ENTITY.
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          accelerator
// Version:           1.00.a
// Description:       Example FSL core (Verilog).
// Date:              Wed Jan 02 00:03:44 2002 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// FSL_Clk             : Synchronous clock
// FSL_Rst           : System reset, should always come from FSL bus
// FSL_S_Clk       : Slave asynchronous clock
// FSL_S_Read      : Read signal, requiring next available input to be read
// FSL_S_Data      : Input data
// FSL_S_Control   : Control Bit, indicating the input data are control word
// FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
// FSL_M_Clk       : Master asynchronous clock
// FSL_M_Write     : Write signal, enabling writing to output FSL bus
// FSL_M_Data      : Output data
// FSL_M_Control   : Control Bit, indicating the output data are contol word
// FSL_M_Full      : Full Bit, indicating output FSL bus is full
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------
// Module Section
//----------------------------------------
module accelerator 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here 
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
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
		FSL_M_Full
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
// ADD USER PORTS ABOVE THIS LINE 

input                                     FSL_Clk;
input                                     FSL_Rst;
input                                     FSL_S_Clk;
output                                    FSL_S_Read;
input      [0 : 31]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;
input                                     FSL_M_Clk;
output                                    FSL_M_Write;
output     [0 : 31]                       FSL_M_Data;
output                                    FSL_M_Control;
input                                     FSL_M_Full;

// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here 
// ADD USER PARAMETERS ABOVE THIS LINE


//----------------------------------------
// Implementation Section
//----------------------------------------
// In this section, we povide an example implementation of MODULE accelerator
// that does the following:
//
// 1. Read all inputs
// 2. Add each input to the contents of register 'sum' which
//    acts as an accumulator
// 3. After all the inputs have been read, write out the
//    content of 'sum' into the output FSL bus NUMBER_OF_OUTPUT_WORDS times
//
// You will need to modify this example for
// MODULE accelerator to implement your coprocessor

   localparam NUMBER_OF_INPUT_WORDS  = 10;
   localparam NUMBER_OF_OUTPUT_WORDS = 1;
	
// Define the states of state machine
   localparam Idle  = 3'b100;
   localparam Read_Inputs = 3'b010;
   localparam Write_Outputs  = 3'b001;
	
	wire	min_clock, min_reset, min_start, min_ack, min_stb;
	wire	[5:0] min_k;
	wire	[9:0] min_dim;
	
	wire	mem_input_write_enable_1, mem_a_write_enable_1, mem_b_write_enable_1;
	wire	[31:0] mem_input_input_data_1, mem_a_input_data_1, mem_b_input_data_1;
	wire	[8:0] mem_input_address_1, mem_a_address_1;
	wire	[13:0] mem_b_address_1;

	wire	[31:0] mem_output_data_1;
	wire	stb, mem_write_enable_2;
	wire	[31:0] mem_input_data_2, mem_a_output_data_2, mem_b_output_data_2;
	wire	[8:0] mem_a_address_2;
	wire	[13:0] mem_b_address_2;
	wire	[4:0] min_out;
	
	reg	s_mem_a_write_enable_1, s_mem_b_write_enable_1;
	reg	[31:0] s_mem_a_input_data_1, s_mem_b_input_data_1;
	reg	[8:0] s_mem_a_address_1;
	reg	[13:0] s_mem_b_address_1;
	
	reg [0:31] n, k, dim;
   reg [0:2] state;
   reg [0:31] out;

   // Counters to store the number inputs read & outputs written
   reg [0:NUMBER_OF_INPUT_WORDS - 1] nr_of_reads;
   reg [0:NUMBER_OF_OUTPUT_WORDS - 1] nr_of_writes;
   reg [0:NUMBER_OF_INPUT_WORDS - 1] nr_of_centers;
	
   memory #(32,9)  memory_input(mem_input_input_data_1, mem_input_data_2, mem_input_address_1, mem_input_address_2, mem_input_write_enable_1, mem_write_enable_2, clock, mem_input_output_data_1, mem_input_output_data_2);
	memory #(32,9)  memory_a(mem_a_input_data_1, mem_input_data_2, mem_a_address_1, mem_a_address_2, mem_a_write_enable_1, mem_write_enable_2, clock, mem_output_data_1, mem_a_output_data_2);
	memory #(32,14) memory_b(mem_b_input_data_1, mem_input_data_2, mem_b_address_1, mem_b_address_2, mem_b_write_enable_1, mem_write_enable_2, clock, mem_output_data_1, mem_b_output_data_2);	
	min find_min(min_clock, min_reset, min_start, min_ack, min_stb, min_k, min_dim, mem_input_data_2, mem_a_address_2, mem_b_address_2, mem_write_enable_2, mem_a_output_data_2, mem_b_output_data_2, min_out);

   always @(posedge FSL_Clk) 
   begin  // process The_SW_accelerator
      if (FSL_Rst)               // Synchronous reset (active high)
        begin
           // CAUTION: make sure your reset polarity is consistent with the
           // system reset polarity
           state        <= Idle;
           nr_of_reads  <= 0;
           nr_of_writes <= 0;
           out          <= 0;
        end
      else
        case (state)
          Idle: 
            if (FSL_S_Exists == 1)
            begin
              state       <= Read_n_k_dim;
				  nr_of_reads  <= 0;
              out         <= 0;
            end

				
          Read_n_k_dim: 
            if (FSL_S_Exists == 1) 
            begin
              if (nr_of_reads == 0)
                begin
                  n <= FSL_S_Data;
						nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
                end
              else
				  begin
					  if (nr_of_reads == 1)
					  begin
							k <= FSL_S_Data;
							nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
					  end
					  else
					  begin
						  if (nr_of_reads == 2)
						  begin
								state <= Read_centers;
								dim <= FSL_S_Data;
								nr_of_centers <= NUMBER_OF_INPUT_WORDS'd0;
						  end
					  end
				  end
            end
				
			 Read_centers:
            if (nr_of_centers >= k)
            begin
					state <= Read_first;
            end
            else
				begin
					state <= Read_center_point;
					nr_of_reads <= NUMBER_OF_INPUT_WORDS'd0;
					s_mem_b_address_1 <= (nr_of_centers << 9)[13:0];
				end
				
			 Read_center_point: 
            if (FSL_S_Exists == 1) 
            begin
              if (nr_of_reads >= dim)
              begin
						state <= Read_centers;
						nr_of_centers <= nr_of_centers + NUMBER_OF_INPUT_WORDS'd1;
              end
              else
				  begin
						state <= Read_center_point_mem_write_wait;
						s_mem_b_input_data_1 <= FSL_S_Data;
						s_mem_b_write_enable_1 <= 1'b1;
				  end
            end
				
			 Read_center_point_mem_write_wait:
				begin
				state <= Read_center_point_mem_write;
				end
				
			 Read_center_point_mem_write:
				begin
				state <= Read_center_point;
				nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_b_address_1 <= s_mem_b_address_1 + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_b_write_enable_1 <= 1'b0;
				end
					
			 Read_first:
				state <= Read_first_point;
				nr_of_reads <= NUMBER_OF_INPUT_WORDS'd0;
				s_mem_input_address_1 <= 14'd0;
				
			 Read_first_point: 
            if (FSL_S_Exists == 1) 
            begin
              if (nr_of_reads >= dim)
              begin
						state <= Update;
              end
              else
				  begin
						state <= Read_first_point_mem_write_wait;
						s_mem_input_input_data_1 <= FSL_S_Data;
						s_mem_input_write_enable_1 <= 1'b1;
				  end
            end
				
			 Read_first_point_mem_write_wait:
				begin
				state <= Read_first_point_mem_write;
				end
				
			 Read_first_point_mem_write:
				begin
				state <= Read_first_point;
				nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_input_address_1 <= s_mem_input_address_1 + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_input_write_enable_1 <= 1'b0;
				end
			
			 Update:
			 begin
				nr_of_reads <= NUMBER_OF_INPUT_WORDS'd0;
				s_mem_input_address_2 <= 9'd0;
				s_mem_a_address_1 <= 9'd0;
				state <= Update_point;
			 end
	
			 Update_point:
			 begin
				if(nr_of_reads < dim)
				begin
					state <= Read_a_read_wait;
				end
				else
				begin
					state <= Start_process;
				end
			 end
			 
			 Read_a_read_wait:
			 begin
				s_state <= read_a_get_input;
			 end
			
			 read_a_get_input:
		 	 begin
				s_mem_a_input_data_1 <= s_mem_input_output_data_2;
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
				nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_input_address_2 <= s_mem_input_address_2 + 9'd1;
				s_mem_a_address_1 <= s_mem_a_address_1 + 9'd1;
				s_state <= Update_point;
			 end
		
			 Start_process:
			 begin
				state <= Read_next;
				min_ack <= 1'd0;
				min_start <= 1'd1;
			 end
			
			 Read_next:
			 begin
				state <= Read_next_point;
				nr_of_reads <= NUMBER_OF_INPUT_WORDS'd0;
				s_mem_input_address_1 <= 14'd0;
			 end
			 
			 Read_next_point: 
            if (FSL_S_Exists == 1) 
            begin
              if (nr_of_reads >= dim)
              begin
						state <= Process_wait;
              end
              else
				  begin
						state <= Read_next_point_mem_write_wait;
						s_mem_input_input_data_1 <= FSL_S_Data;
						s_mem_input_write_enable_1 <= 1'b1;
				  end
            end
				
			 Read_next_point_mem_write_wait:
				begin
				state <= Read_next_point_mem_write;
				end
				
			 Read_next_point_mem_write:
				begin
				state <= Read_next_point;
				nr_of_reads <= nr_of_reads + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_input_address_1 <= s_mem_input_address_1 + NUMBER_OF_INPUT_WORDS'd1;
				s_mem_input_write_enable_1 <= 1'b0;
				end
			
			 Process_wait:
			 begin
				if(min_stb)
					out <= {27'd0,min_out}
					state <= Write_output;
			 end
			 
			 Write_output:
			 begin
				if(FSL_M_Full == 0)
					state <= Update;
			 end
              
        endcase
   end
	
	assign FSL_S_Read  = (state == Read_Inputs) ? FSL_S_Exists : 0;
   assign FSL_M_Write = (state == Write_Outputs) ? ~FSL_M_Full : 0;

	assign min_clock = FSL_Clk;
	assign min_reset = FSL_Rst;
	assign min_k = k[5:0];
	assign min_dim = dim[9:0];

	assign mem_a_write_enable_1 = s_mem_a_write_enable_1;
	assign mem_b_write_enable_1 = s_mem_b_write_enable_1;
	assign mem_a_input_data_1 = s_mem_a_input_data_1;
	assign mem_b_input_data_1 = s_mem_b_input_data_1;
	assign mem_a_address_1 = s_mem_a_address_1;
	assign mem_b_address_1 = s_mem_b_address_1;
	
   assign FSL_M_Data = out;
	
endmodule
