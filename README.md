Simulation of a DRAM controller with basic read, write, and refresh capabilities, along with error checking.

**Inputs:**

clk: Clock signal.

opcode [1:0]: Command selector.

00: No operation.

01: Read.

10: Write.

11: Refresh.

row, column [9:0]: Memory address (used as 2D access mem[row][column]).

data_in [31:0]: Input data for writing.

temp [7:0]: Simulated temperature input for refresh logic.

**Outputs:**

data_out [31:0]: Output data during a read.

error [1:0]: Error code:

01: Read error (parity failed).

10: Write error (parity failed).

**FSM States:**
**Initial:** Startup state — prints messages simulating POST (power-on self-test).

**Idle:** Waits for a valid opcode.

**Read:** Reads memory if parity is valid.

**Write:** Writes to memory if parity is valid.

**Refresh:** Refreshes memory based on temperature:

 >40°C → adaptive refresh.

≤40°C → scheduled refresh.

**Error:** Displays appropriate error messages based on the error type.

**Memory:**
A 2D array mem[1023][1023] of 32-bit values.

Memory data uses parity bit at bit 31 for error detection:

Parity check: data[31] == ^data[30:0]

