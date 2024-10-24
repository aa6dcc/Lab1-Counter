module counter #(
  parameter WIDTH = 8
)(
  // interface signals
  input  logic             clk,      // clock
  input  logic             rst,      // reset
  input  logic             ld,       // load counter from data
  input  logic             en,       // enable signal from Vbuddy
  input  logic [WIDTH-1:0] v,        // value to preload
  output logic [WIDTH-1:0] count     // count output
);

//always_ff @ (posedge clk)
  //if (rst) count <= {WIDTH{1'b0}};
  //else     count <= ld ? v : count + {{WIDTH-1{1'b0}},1'b1} // When ld is asserted, the value v is loaded into the counter as a pre-set value.

always_ff @ (posedge clk) // triggers on the positive edge of the clock, automatically goes unasserted after one cycle
  if (rst) count <= {WIDTH{1'b0}};  // if the reset is high, the counter is set to 0         
  else if (ld) count <= v; // if load is high, the counter is pre-loaded with the value v                      
  else if (en) count <= v; // When the flag is triggered, you set top->en = vbdFlag();, which causes the enable signal (en) to go high, thus loading the counter with the value v in the simulation.   
  else count <= count + {{WIDTH-1{1'b0}},1'b1};  // Increment counter, sequential logic controls it
endmodule
