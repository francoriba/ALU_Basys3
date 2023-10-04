`timescale 1ns / 1ps

module alu #( 
    parameter NB_DATA = 8, NB_OPCODE = 6
)(
    input wire signed [NB_DATA-1:0] i_op_1,
    input wire signed [NB_DATA-1:0] i_op_2, 
    input wire [NB_OPCODE-1:0] i_opcode,
  	output wire signed [NB_DATA-1:0] o_result
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
assign o_result = result;

//combinational logic bock
always @(*)
begin
    case (i_opcode)
        ADD : result = i_op_1 + i_op_2;    
        SUB : result = i_op_1 - i_op_2;    
      	AND : result= i_op_1 & i_op_2;    
        OR  : result = i_op_1 | i_op_2;    
        XOR : result = i_op_1 ^ i_op_2;    
        SRA : result = i_op_1 >> i_op_2;  
        SRL : result = i_op_1 >>> i_op_2;   
        NOR : result = ~(i_op_1 | i_op_2); 
    default: result = {NB_DATA {1'b0}}; //non valid opcode -> output = 0
    endcase
end
endmodule
