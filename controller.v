`timescale 1ns / 1ps
//`include "ALU_design.v"

module controller
#(
    //parameters
    parameter           NB_DATA = 8,
    parameter           NB_OPCODE = 6,
    parameter           N_PULSADORES = 3
)
(
    input wire signed   [NB_DATA-1:0]           i_switches,
    input wire          [N_PULSADORES-1:0]      i_pulsadores,
    input wire                                  i_clock,    
    input wire                                  i_reset,
    output wire signed  [NB_DATA-1:0]           o_result
);
    // internal registers to store inputs
    reg signed [NB_DATA-1:0]   operandA;
    reg signed [NB_DATA-1:0]   operandB;
    reg [NB_OPCODE-1:0]        opcode;
    
    always @(posedge i_clock)
    begin
        if(i_reset)
            begin
                operandA <= {NB_DATA {1'b0}};
                operandB <= {NB_DATA {1'b0}};
                opcode <= {NB_OPCODE {1'b0}};
            end
        else
            begin
                case(i_pulsadores)
                    {{N_PULSADORES-3 {1'b0}}, 3'b001}: operandA <= i_switches; 
                    {{N_PULSADORES-3 {1'b0}}, 3'b010}: operandB <= i_switches; 
                    {{N_PULSADORES-3 {1'b0}}, 3'b100}: opcode <= i_switches; //pulsador 2: switches -> opcode
                    default: // by default we keep the previous values 
                    begin
                        operandA <= operandA;
                        operandB <= operandB;
                        opcode <= opcode;
                    end
                    endcase
            end
    end
    
    alu
    #(
        .NB_DATA    (NB_DATA),
        .NB_OPCODE  (NB_OPCODE)
    )
    dut
    (
        .i_op_1 (operandA),
        .i_op_2 (operandB),             
        .i_opcode(opcode),
        .o_result(o_result)
    );
endmodule

