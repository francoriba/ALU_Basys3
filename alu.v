`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 09/02/2023 11:17:23 AM
// Design Name: ALU
// Module Name: alu
// Project Name: ALU module
// Target Devices: Basys3 
// Description:  Implementation of an arithmetic and logic unit in Verilog for the basys 3 board
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module alu #( 
    parameter NB_DATA = 8, NB_OPCODE = 6
)(
    input wire signed [NB_DATA-1:0] i_op_1,
    input wire signed [NB_DATA-1:0] i_op_2, 
    input wire [NB_OPCODE-1:0] i_opcode,
  	output wire signed [NB_DATA-1:0] o_result,
  	output wire o_carry
);

//operations opcodes
localparam  ADD = 6'b100000;
localparam  SUB = 6'b100010;
localparam  AND = 6'b100100;
localparam  OR  = 6'b100101;
localparam  XOR = 6'b100110;
localparam  SRA = 6'b000011;
localparam  SRL = 6'b000010;
localparam  NOR = 6'b100111;

reg signed [NB_DATA-1 : 0] result; //register for storing result
//reg carry; //register for storing carry if needed
assign o_result = result;
//assign o_carry = carry;

//reg [NB_DATA-1 : 0] i_op_1_r; //register for storing fisrt operand 
//reg [NB_DATA-1 : 0] i_op_2_r; //register for storing second operand 


//combinational logic bock
always @(*)
begin
    case (i_opcode)
        ADD : {carry,result} = i_op_1 + i_op_2;    //ADD
        SUB : result = i_op_1 - i_op_2;    //SUB
      	AND : result= i_op_1 & i_op_2;    //AND
        OR  : result = i_op_1 | i_op_2;    	//OR
        XOR : result = i_op_1 ^ i_op_2;    //XOR
        SRA : result = i_op_1 >>> i_op_2;  //SRA
        SRL : result = i_op_1 >> i_op_2;   //SRL
        NOR : result = ~(i_op_1 | i_op_2); //NOR
    default: result = {NB_DATA {1'b0}}; //non valid opcode -> output = 0
    endcase
end

/*
//secuential logic bock
always @(*)
begin
    i_op_1_r = i_op_1;
    i_op_2_r = i_op_2;        
end
*/
endmodule
