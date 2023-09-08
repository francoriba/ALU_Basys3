Implementation of an arithmetic and logic unit in Verilog for the Basys3 board (Digilent). Computer Architecture 2023. FCEFyN, UNC, Argentina.

# Goal
- Impementation of an ALU in FPGA, specifically the Basys3 board.
- The ALU takes 3 inputs, 2 of them are operands (8 bits) and the other is the opcode (6 bits).
- 8 swiches are used to establish the bits states for each input.
- As there are 8 swiches for 3 different inputs, 3 buttons of the board are used to select to wich input will correspond the value given by the 8 swiches.

# Project structure

The figure below shows all the source files of this project. Simulation sources (yellow) are the testbench files for software testing of the "controller" and "alu" (green) modules.

![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/esquema.png)

# ALU module
This module corresponds to the desing source file ``alu.v`` and contains the implementation of an Arithmetic and Logic Unit supporting 8 different operations distinguished by their 6 bit opcode:<br>
* ADD (100000)
* SUB (100010)
* AND (100100)
* OR  (100101)
* XOR (100110)
* SRA (000011)
* SRL (000010)
* NOR (100111)

This module uses an ``always@(*)`` block wich allows to implement combinational logic with the goal of performing the right operation by decoding it with help of the opcode and a ``case`` conditional. 
At any given time if one of the signals used inside the always block (i_op_1 or i_op2) change then this block will excecute again and the output (o_result) will change, as it would in a combinational circuit.

The figure below shows the generated desing of the ALU made by the RTL Analysis feature of the Vivado software. 

![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/alu.png)

# Controller module
This module corresponds to the desing source file ``controller.v`` and contains the necesary logic to assign the values of the switch ports to differents inputs depending on wich button was last pressed, again this is made by using a ``case`` conditional. The alu module is instanciated here using the corresponding values as input parameters.

The figure below shows the generated desing of the controller made by the RTL Analysis feature of the Vivado software. 

![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/controller.png)

# ALU Testbench
This module corresponds to the simulation source file ``tb_alu.v`` and implements a simulation for testing the output of the ALU when using randomly generated values for the operands.

The duration of the test can be changed, by default we have set it to #900, during this time there will be different iterations, in each iteration all operations will be tested, but also each iteration will have different randomly generated operands.

This is achieved by generating a clock signal with a period of 10 time units and using a variable as a counter. Each time an operation is completed the counter is incremented by one, the counter value is checked to see if it is divisible by the total amount of the operation (8) plus one, if this happens it means we have performed the 8 operations for 2 operands and it is time to reach new random operands and repeat all the operations again.

In addition, each time an operation is performed, the result is checked and error messages are displayed if the two values do not match.

The figure below shows an example of an error-free output.

![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/tb_alu_errorfree.png)

The figure below shows an example of an error output.

![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/tb_alu_error.png)

# Controller Testbench
This module corresponds to the simulation source file ``tb_controller.v`` and implements a simulation for testing the controller module.

Again we set up a clock signal with a period of 10 time units and a variable to be used as a counter, this counter will be used to determine which cycle we are in.
There are 4 cycles:
* 1st cycle: assign the first operand
* 2nd cycle: assign second operand
* 3rd cycle: allocate opcode
* 4th cycle: check result

Using a new ``case'' condition, the value of the switches is randomly assigned and the "button pressed" is set depending on which cycle it is. For example, if the variable used as a counter has the value 1, then the value 001 is assigned to the button input variable and a random operand is set.

The figure below shows the time analysis of the simulation.
![](https://github.com/francoriba/ALU_Basys3/blob/main/docs/time_analysis.png)