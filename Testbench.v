`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 16:13:36
// Design Name: 
// Module Name: Micron
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dram_tb;

    reg clk;
    reg [1:0] opcode;
    reg [9:0] row;
    reg [9:0] column;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire[1:0] error;
    reg[7:0] temp;
    wire[2:0] current_state_reg;

    // Instantiate the dram module
    Micron uut (
        .clk(clk),
        .opcode(opcode),
        .row(row),
        .column(column),
        .data_in(data_in),
        .data_out(data_out),
        .error(error),
        .temp(temp),
        .current_state_reg(current_state_reg)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        opcode = 2'b00;
        row = 10'b0;
        column = 10'b0;
        data_in = 32'b0;
        temp=8'b0;

        // Wait for a few clock cycles to initialize
        #15;

        // Test 1: Write valid data
        $display("\n--- Test 1: Write Valid Data ---");
        row = 10'd5;
        column = 10'd10;
        data_in = 32'h99973111;  // Correct parity
        opcode = 2'b10; // Write opcode
        #10
        opcode = 2'b00; // Write opcode
        #10;

        // Test 2: Read valid data
        $display("\n--- Test 2: Read Valid Data ---");
        opcode = 2'b01; // Read opcode
         #10
        opcode = 2'b00; // Write opcode
        #10;

 $display("\n--- Test 3: Refresh Memory ---");
        temp=8'd30;
        opcode = 2'b11; // Refresh
        #10
        opcode = 2'b00; // Write opcode
        #10; // Give enough time for loops
        // Test 3: Write invalid data (wrong parity)
        $display("\n--- Test 4: Write Invalid Data (Parity Error) ---");
        row = 10'd7;
        column = 10'd8;
        data_in = 32'h89973111; // Random wrong parity
        opcode = 2'b10; // Write
        #10
        opcode = 2'b00; // Write opcode
        #50;
        // Finish simulation
        $display("\n--- Simulation Finished ---");
        $stop;
    end

endmodule
