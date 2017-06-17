module adder_64_bit(a,b,z); 
input 	[63:0] a,b; 
output 	[63:0] z; 

wire		c_0, c_1, c_2, c_3, c_4, c_5, c_6, c_7, c_8;

adder_8_bit add_8_1(a[7:0],b[7:0],c_0,z[7:0],c_1);
adder_8_bit add_8_2(a[15:8],b[15:8],c_1,z[15:8],c_2);
adder_8_bit add_8_3(a[23:16],b[23:16],c_2,z[23:16],c_3);
adder_8_bit add_8_4(a[31:24],b[31:24],c_3,z[31:24],c_4);
adder_8_bit add_8_5(a[39:32],b[39:32],c_4,z[39:32],c_5);
adder_8_bit add_8_6(a[47:40],b[47:40],c_5,z[47:40],c_6);
adder_8_bit add_8_7(a[55:48],b[55:48],c_6,z[55:48],c_7);
adder_8_bit add_8_8(a[63:56],b[63:56],c_7,z[63:56],c_8);

assign c_0 = 1'b0;

endmodule 
