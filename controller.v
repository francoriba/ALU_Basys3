`timescale 1ns / 1ps
//`include "ALU_design.v"

module controlador
#(
    //PARAMETROS
    parameter           N_BITS_DATA = 8,
    parameter           N_BITS_OP = 6,
    parameter           N_PULSADORES = 3
)
(
    input wire signed   [N_BITS_DATA-1:0]       i_switches,
    input wire                                  i_clock,    
    input wire          [N_PULSADORES-1:0]      i_pulsadores,
    input wire                                  i_reset,
    output wire signed  [N_BITS_DATA-1:0]       o_resultado
);
    
    reg signed [N_BITS_DATA-1:0]   dato_A ;
    reg signed [N_BITS_DATA-1:0]   dato_B ;
    reg [N_BITS_OP-1:0]     operacion ;
    
    always @(posedge i_clock)
    begin
        if(i_reset)
        begin
            dato_A <= {N_BITS_DATA {1'b0}};
            dato_B <= {N_BITS_DATA {1'b0}};
            operacion <= {N_BITS_OP {1'b0}};
        end
        else
        begin
            case(i_pulsadores)//poner reset
                {{N_PULSADORES-3 {1'b0}}, 3'b001}: dato_A <= i_switches;
                {{N_PULSADORES-3 {1'b0}}, 3'b010}: dato_B <= i_switches;
                {{N_PULSADORES-3 {1'b0}}, 3'b100}: operacion <= i_switches;
                
                default: //por defecto quedan los datos anteriores
                begin
                    dato_A <= dato_A;
                    dato_B <= dato_B;
                    operacion <= operacion;
                end
                endcase
        end
    end
    
    alu
    #(
        .N_BITS_DATA    (N_BITS_DATA),
        .N_BITS_OP      (N_BITS_OP)
    )
    u_alu
    (
        .i_dato_A (dato_A),
        .i_dato_B (dato_B),             
        .i_operacion(operacion),
        .o_resultado(o_resultado)
    );
endmodule

