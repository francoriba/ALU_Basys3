`timescale 1ns / 1ps

module alu_tb;

    // Paramenters and signals needed for the test bench
    localparam NB_DATA = 8;
    localparam NB_OPCODE = 6;
	localparam NB_CANT_OP = 8;
    localparam NB_INTEGER = 32;

    reg signed [NB_DATA-1:0] i_op_1;
    reg signed [NB_DATA-1:0] i_op_2;
    reg [NB_OPCODE-1:0] i_opcode;
  	wire signed [NB_DATA-1:0] o_result;
    wire _carry;

    // create instance of alu module
    alu #(NB_DATA, NB_OPCODE) dut (
        .i_op_1(i_op_1),
        .i_op_2(i_op_2),
        .i_opcode(i_opcode),
        .o_result(o_result)
    );

    // Generate test signals
    initial begin
      
      
         // ADD without carry, result shoud be 0 0000_0010 = 2h = 2d
        i_op_1 = 8'b0000001;
        i_op_2 = 8'b0000001;
        i_opcode = 6'b100000;
        #10; // wait before cheking the result
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result); 
      
        // ADD with carry, result shoud be 1011_10110 = 176h = -138d
        i_op_1 = 8'b10101010;
        i_op_2 = 8'b11001100;
        i_opcode = 6'b100000;
        #10;
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);

        
        // SUB A > B 0x0F - 0x01 = 0x0E
        i_op_1 = 8'b00001111;
        i_op_2 = 8'b00000001;
        i_opcode = 6'b100010;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);		
      
      
        // SUB A < B 0x04 - 0x05 = 0xFF (ca2) = -1
        i_op_1 = 8'b00000100;
        i_op_2 = 8'b00000101;
        i_opcode = 6'b100010;

        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);	      
       
        // AND 0xD3 & 0x5A = 0x52
        i_op_1 = 8'b11010011;
        i_op_2 = 8'b01011010;
        i_opcode = 6'b100100;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);	      
      
      
        // OR  0xD3 | 0x5A = 0xDB
        i_op_1 = 8'b11010011;
        i_op_2 = 8'b01011010;
        i_opcode = 6'b100101;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);	    
      
        // OR  0x6B ^ 0xDD = 0xB6
        i_op_1 = 8'b01101011;
        i_op_2 = 8'b11011101;
        i_opcode = 6'b100110;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);
      
        // SRA 8'b00010000 >>> 8'00000100
        i_op_1 = 8'b00010000;
      	i_op_2 = 8'b00000010;
        i_opcode = 6'b000011;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);
      
        // SRL 8'b11011011 >> 8'01101101
        i_op_1 = 8'b11011011;
      	i_op_2 = 8'b00000001;
        i_opcode = 6'b000010;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);      
      
      
       // NOR 8'b00001111 >> 8'b11110000
        i_op_1 = 8'b00001111;
      	i_op_2 = 8'b00001111;
        i_opcode = 6'b100111;
        #10; 
      	$display("Result = %b bin = %h h = %d d", o_result, o_result, o_result);      
      
        // finish simulation
        $finish;
    end

endmodule
