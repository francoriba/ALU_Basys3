`timescale 1ns / 1ps

module tb_alu_autocheck();

    //local parameters
    localparam    N_BITS_DATA   = 8;
    localparam    N_BITS_OP     = 6;
    localparam    NB_INTEGER    = 32;
    localparam    CANT_OP       = 8;
    //bits operaciones
    localparam ADD = 6'b100000;
    localparam SUB = 6'b100010;
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam SRA = 6'b000011;
    localparam SRL = 6'b000010;
    localparam NOR = 6'b100111;

    //TB signals
    reg clk;
    reg  test_start;
    integer i;
    integer j;
    //INPUTS
    reg signed [N_BITS_DATA-1 : 0] i_dato_A;
    reg signed [N_BITS_DATA-1 : 0] i_dato_B;
    reg [N_BITS_OP-1 : 0]   i_operacion;
    //OUTPUTS
    wire signed [N_BITS_DATA-1 : 0] o_resultado;

    initial begin
    #0 //Inicializo entradas a cero
    clk = 1'b0;
    test_start = 1'b0;
    i = {NB_INTEGER {1'b0}};
    j = {NB_INTEGER {1'b0}};
    i_dato_A    =   {N_BITS_DATA {1'b0}};
    i_dato_B    =   {N_BITS_DATA {1'b0}};
    i_operacion =   {N_BITS_OP {1'b0}};

    #10
    test_start = 1'b1;

    #900
    $display("############# Test OK ############");
    //si llega hasta aca es porque todos los test dieron OK
    $finish();
    end // initial

    //Module instance
    alu
    #(
        .N_BITS_DATA    (N_BITS_DATA),
        .N_BITS_OP      (N_BITS_OP)
    )
    u_alu
    (
        .i_dato_A       (i_dato_A),
        .i_dato_B       (i_dato_B),
        .i_operacion    (i_operacion),
        .o_resultado    (o_resultado)
    );

    //Clock generation
    always #10 clk = ~clk;
 /*
    En un primer ciclo se eligen aleatoriamente los operandos A y B.
    Luego en los ciclos siguientes se van realizando de a una operacion por ciclo
    pasando por todas las operaciones.
    En un ciclo, todas las operaciones se realizan con los mismos operandos.
 */
    //Random Data
    always @(posedge clk)
    begin
        if(i%(CANT_OP+1) == 0)
            begin
            i_dato_A <= $urandom; //random sin signo
            i_dato_B <= $urandom;
           // i_dato_B <= 8'b10000011;
            j <= j + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //j++
            
            #1
            $display("----------Iteracion n°%d----------", j);
            $display("A = %b", i_dato_A);
            $display("B = %b", i_dato_B);  
            end
    end
        
    //Check Module Output 
    always @(posedge clk)
    begin
        if(test_start)
        begin
            i <= i + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //i++
            case (i%(CANT_OP+1))
                {{NB_INTEGER-4 {1'b0}}, 4'b0001}://i == 1
                begin
                    i_operacion <=   ADD;
                    #1
                    if(o_resultado != (i_dato_A+i_dato_B))
                    begin
                        $error("Error en la SUMA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A+i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0010}://i == 2
                begin
                    i_operacion <=   SUB;
                    #1
                    if(o_resultado != (i_dato_A-i_dato_B))
                    begin
                        $error("Error en la RESTA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A-i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0011}://i == 3
                begin
                    i_operacion <=   AND;
                    #1
                    if(o_resultado != (i_dato_A&i_dato_B))
                    begin
                        $error("Error en el AND!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A&i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0100}://i == 4
                begin
                    i_operacion <=   OR;
                    #1
                    if(o_resultado != (i_dato_A|i_dato_B))
                    begin
                        $error("Error en el OR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A|i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0101}://i == 5
                begin
                    i_operacion <=   XOR;
                    #1
                    if(o_resultado != (i_dato_A^i_dato_B))
                    begin
                        $error("Error en el XOR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A^i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0110}://i == 6
                begin
                    i_operacion <=   SRA;
                    #1
                    if(o_resultado != (i_dato_A>>>i_dato_B))
                    begin
                        $error("Error en el SRA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A>>>i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0111}://i == 7
                begin
                    i_operacion <=   SRL;
                    #1
                    if(o_resultado != (i_dato_A>>i_dato_B))
                    begin
                        $error("Error en el SRL!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, i_dato_A>>i_dato_B);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b1000}://i == 8
                begin
                    i_operacion <=   NOR;
                    #1
                    if(o_resultado != ~(i_dato_A|i_dato_B))
                    begin
                        $error("Error en el NOR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_resultado, ~(i_dato_A|i_dato_B));
                        $finish();
                    end
                end
                default: 
                  begin
                      //no hace nada -> en este ciclo se cambian los argumentos de entrada
                  end
            endcase
        end
    end

endmodule //tb_alu_autocheck