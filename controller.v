`timescale 1ns / 1ps
//`include "ALU_design.v"

module controlador
#(
    //parameters
    parameter           NB_DATA = 8,
    parameter           NB_OPCODE = 6,
    parameter           N_PULSADORES = 3
)
(
    input wire signed   [NB_DATA-1:0]       i_switches,
    input wire                                  i_clock,    
    input wire          [N_PULSADORES-1:0]      i_pulsadores,
    input wire                                  i_reset,
    output wire signed  [NB_DATA-1:0]       o_result
);
    
    reg signed [NB_DATA-1:0]   i_op_1 ;
    reg signed [NB_DATA-1:0]   i_op_2 ;
    reg [NB_OPCODE-1:0]     i_opcode ;
    
    always @(posedge i_clock)
    begin
        if(i_reset)
        begin
            i_op_1 <= {NB_DATA {1'b0}};
            i_op_2 <= {NB_DATA {1'b0}};
            i_opcode <= {NB_OPCODE {1'b0}};
        end
        else
        begin
            case(i_pulsadores)//poner reset
                {{N_PULSADORES-3 {1'b0}}, 3'b001}: i_op_1 <= i_switches;
                {{N_PULSADORES-3 {1'b0}}, 3'b010}: i_op_2 <= i_switches;
                {{N_PULSADORES-3 {1'b0}}, 3'b100}: i_opcode <= i_switches;
                
                default: //por defecto quedan los datos anteriores
                begin
                    i_op_1 <= i_op_1;
                    i_op_2 <= i_op_2;
                    i_opcode <= i_opcode;
                end
                endcase
        end
    end
    
    alu
    #(
        .NB_DATA    (NB_DATA),
        .NB_OPCODE      (NB_OPCODE)
    )
    dut
    (
        .i_op_1 (i_op_1),
        .i_op_2 (i_op_2),             
        .i_opcode(i_opcode),
        .o_result(o_result)
    );
endmodule

