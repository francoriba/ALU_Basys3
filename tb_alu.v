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
    reg signed [NB_DATA-1:0] operandA;
    reg signed [NB_DATA-1:0] operandB;
    reg [NB_OPCODE-1:0] opcode;
  	reg [31:0] operation_name;
    // output
  	wire signed [NB_DATA-1:0] o_result;

    // TB signals
    reg clk;
    reg test_start;
    integer i, j; //counters  i-> number of operations completed j-> number of iteration

    // Generate test signals
    initial begin

      clk = 1'b0; 
      test_start = 1'b0;
      i = {NB_INTEGER {1'b0}};
      j = {NB_INTEGER {1'b0}};
      operandA = {NB_DATA {1'b0}};
      operandB = {NB_DATA {1'b0}};
      opcode = {NB_OPCODE {1'b0}};

      #10
      test_start = 1'b1;
      #900
      $display("############# Tests are finished ############");
      $finish;
    end

    // create instance of "alu" module and assign input and output signals of "alu" to the corresponding signals of benchtest  //.alu(controller)
    alu #(
      .NB_DATA(NB_DATA), 
      .NB_OPCODE(NB_OPCODE)
    )
    dut(
        .i_op_1(operandA),
        .i_op_2(operandB),
        .i_opcode(opcode),
        .o_result(o_result)
    );

    //Clock generation
    always #10 clk = ~clk;
    
    //Generation of new random data after finishing all operations of each iteration ()
    always @(posedge clk)
    begin
        if(i%(CANT_OP+1) == 0)
            begin
              operandA <= $urandom; // unsigned random 
              operandB <= $urandom;
              j <= j + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //j++
            
              #1
              $display("----------Iteration n°%d ----------", j);
              $display("A = %bb = %dd = %hh ", operandA, operandA, operandA);
              $display("B = %bb = %dd = %hh ", operandB, operandB, operandB);
            end
    end

    //Check alu module output
    always @(posedge clk)
    begin
        if(test_start)
        begin
          i <= i + {{NB_INTEGER-1 {1'b0}}, 1'b1}; //i+1
          operation_name = "";
            case (i%(CANT_OP+1))  //based on number of iteration decide what
                {{NB_INTEGER-4 {1'b0}}, 4'b0001}://i == 1
                begin
                    opcode <=   ADD;
                  	operation_name = "ADD";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", operandA + operandB, operandA + operandB, operandA + operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA + operandB))
                    begin
                        $error("Error in ADD!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA + operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0010}://i == 2
                begin
                    opcode <=   SUB;
                  	operation_name = "SUB";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", operandA - operandB, operandA - operandB, operandA - operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA - operandB))
                    begin
                        $error("Error in RESTA!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA - operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0011}://i == 3
                begin
                    opcode <=   AND;
                   	operation_name = "AND";
                    #1
                  	$display("\t Operation: %s" , operation_name);
                    $display("\t \t Target result: %bb = %dd = %hh", operandA & operandB, operandA & operandB, operandA & operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA & operandB))
                    begin
                        $error("Error in AND!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA & operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0100}://i == 4
                begin
                    opcode <=   OR;
                    operation_name = "OR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                    $display("\t \t Target result: %bb = %dd = %hh", operandA | operandB, operandA | operandB, operandA | operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA |operandB))
                    begin
                        $error("Error in OR!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA | operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0101}://i == 5
                begin
                    opcode <=   XOR;
                    operation_name = "XOR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", operandA ^ operandB, operandA ^ operandB, operandA ^ operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA ^ operandB))
                    begin
                        $error("Error in XOR!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA ^ operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0110}://i == 6
                begin
                    opcode <= SRA;
                    operation_name = "SRA";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", operandA >>> operandB, operandA >>> operandB, operandA >>> operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA >>> operandB))
                    begin
                        $error("Error in SRA!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA >>> operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b0111}://i == 7
                begin
                    opcode <=   SRL;
                  	operation_name = "SRL";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh", operandA >> operandB, operandA >> operandB, operandA >> operandB);
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != (operandA >> operandB))
                    begin
                        $error("Error in SRL!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, operandA >> operandB);
                        $finish();
                    end
                end
                {{NB_INTEGER-4 {1'b0}}, 4'b1000}://i == 8
                begin
                    opcode <=   NOR;
                  	operation_name = "NOR";
                    #1
                    $display("\t Operation: %s" , operation_name);
                  	$display("\t \t Target result: %bb = %dd = %hh",~(operandA | operandB),~(operandA | operandB), ~(operandA | operandB));
                  	$display("\t \t ALU output: %bb = %dd = %hh", o_result, o_result, o_result);
                    if(o_result != ~(operandA | operandB))
                    begin
                        $error("Error in NOR!");
                        $display("############# Test FAIL ############");
                        $display("Result was %b and should be %b", o_result, ~(operandA | operandB));
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
