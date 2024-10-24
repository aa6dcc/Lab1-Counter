module top #(
  parameter WIDTH = 8
)(
  // interface signals
  input  logic             clk,      // clock
  input  logic             rst,      // reset
  input  logic             en,       // enable
  input  logic [WIDTH-1:0] v,        // value to preload
  output logic [11:0]      bcd       // BCD count output
);

  logic  [WIDTH-1:0]       count;    // interconnect wire
  logic                    ld;       // load signal

  assign ld = rst;  // Load the counter with 'v' when rst is high (or other condition)

counter myCounter (
  .clk (clk),
  .rst (rst),
  .en (en),
  .ld (ld),       // Connect the load signal
  .v (v),         // Connect the 'v' pin (preload value)
  .count (count)  // Output of the counter
);

bin2bcd myDecoder (
  .x (count),     // Binary value from counter
  .BCD (bcd)      // BCD representation output
);

endmodule
