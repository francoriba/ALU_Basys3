`timescale 1ns / 1ps

module alu_tb;

    // Paramenters and signals needed for the test bench
    localparam NB_DATA = 8;
    localparam NB_OPCODE = 6;
	  localparam CANT_OP = 8;
    localparam NB_INTEGER = 32;

    // opcodes
    localparam ADD = 6'b100000;
    localparam SUB = 6'b100010;
    localparam AND = 6'b100100;
    localparam OR  = 6'b100101;
    localparam XOR = 6'b100110;
    localparam SRA = 6'b000011;
    localparam SRL = 6'b000010;
    localparam NOR = 6'b100111;

    // inputs
    reg signed [NB_DATA-1:0] i_op_1;
    reg signed [NB_DATA-1:0] i_op_2;
    reg [NB_OPCODE-1:0] i_opcode;
  	reg [31:0] operation_name;
    // outputs
  	wire signed [NB_DATA-1:0] o_result;
    wire _carry;
    // TB signals
    reg clk;
    reg test_start;
    integer i, j; //counters


    // Generate test signals
    initial begin

      clk = 1'b0; 
      test_start = 1'b0;
      i = {NB_INTEGER {1'b0}};
      j = {NB_INTEGER {1'b0}};
      i_op_1 = {NB_DATA {1'b0}};
      i_op_2 = {NB_DATA {1'b0}};
      i_opcode = {NB_OPCODE {1'b0}};

      #10
      test_start = 1'b1;
      #900
      $display("############# Tests are finished ############");
      $finish;
    end

    // create instance of "alu" module and assign input and output signals of "alu" to the corresponding signals of benchtest
    alu #(
      .NB_DATA(NB_DATA), 
      .NB_OPCODE(NB_OPCODE)
    )
    dut(
        .i_op_1(i_op_1),
        .i_op_2(i_op_2),
        .i_opcode(i_opcode),
        .o_result(o_result)
    );

    //Clock generation
    always #10 clk = ~clk;
    
    //Generation of random data 
    always @(posedge clk)
    begin
        if(i%(CANT_OP+1) == 0)
            begin
              i_op_1 <= $urandom; //random sin signo
              i_op_2 <= $urandom;
              j <= j + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //j++
            
              #1
              $display("----------Iteracion n°%d----------", j);
              $display("A = %bb = %dd = %hh ", i_op_1, i_op_1, i_op_1);
              $display("B = %bb = %dd = %hh ", i_op_2, i_op_2, i_op_2);
            end
    end

    //Check alu module output
    always @(posedge clk)
    begin
        if(test_start)
        begin
          i <= i + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //i+1
          operation_name = "";
            case (i%(CANT_OP+1))
                {{NB_INTEGER-4 {1'b0}}, 4'b0001}://i == 1
                begin
                    i_opcode <=   ADD;
                  	operation_name = "ADD";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", i_op_1 + i_op_2, i_op_1 + i_op_2, i_op_1 + i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 + i_op_2))
                    begin
                        $error("Error en la SUMA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 + i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0010}://i == 2
                begin
                    i_opcode <=   SUB;
                  	operation_name = "SUB";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", i_op_1 - i_op_2, i_op_1 - i_op_2, i_op_1 - i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 - i_op_2))
                    begin
                        $error("Error en la RESTA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 - i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0011}://i == 3
                begin
                    i_opcode <=   AND;
                   	operation_name = "AND";
                    #1
                  	$display("\t Operation: %s" , operation_name);
                    $display("\t \t Target result: %bb = %dd = %hh", i_op_1 & i_op_2, i_op_1 & i_op_2, i_op_1 & i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 & i_op_2))
                    begin
                        $error("Error en el AND!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 & i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0100}://i == 4
                begin
                    i_opcode <=   OR;
                    operation_name = "OR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                    $display("\t \t Target result: %bb = %dd = %hh", i_op_1 | i_op_2, i_op_1 | i_op_2, i_op_1 | i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 |i_op_2))
                    begin
                        $error("Error en el OR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 | i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0101}://i == 5
                begin
                    i_opcode <=   XOR;
                    operation_name = "XOR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", i_op_1 ^ i_op_2, i_op_1 ^ i_op_2, i_op_1 ^ i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 ^ i_op_2))
                    begin
                        $error("Error en el XOR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 ^ i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0110}://i == 6
                begin
                    i_opcode <= SRA;
                    operation_name = "SRA";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", i_op_1 >>> i_op_2, i_op_1 >>> i_op_2, i_op_1 >>> i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 >>> i_op_2))
                    begin
                        $error("Error en el SRA!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 >>> i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0111}://i == 7
                begin
                    i_opcode <=   SRL;
                  	operation_name = "SRL";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", i_op_1 >> i_op_2, i_op_1 >> i_op_2, i_op_1 >> i_op_2);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (i_op_1 >> i_op_2))
                    begin
                        $error("Error en el SRL!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, i_op_1 >> i_op_2);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b1000}://i == 8
                begin
                    i_opcode <=   NOR;
                  	operation_name = "NOR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh",~(i_op_1 | i_op_2),~(i_op_1 | i_op_2), ~(i_op_1 | i_op_2));
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != ~(i_op_1 | i_op_2))
                    begin
                        $error("Error en el NOR!");
                        $display("############# Test FALLO ############");
                        $display("El resultado fue %b cuando debio ser %b", o_result, ~(i_op_1 | i_op_2));
                        $finish();
                    end
                end
                default: 
                  begin
                  end
            endcase
        end
    end
      
endmodule
