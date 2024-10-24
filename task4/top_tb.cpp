#include "Vtop.h"             // Include the top module
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"         // Include Vbuddy file

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop* top = new Vtop;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("top.vcd");

    // init vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 1: Counter with BCD");

    vbdSetMode(1);

    // initialize inputs
    top->clk = 1;
    top->rst = 1;
    top->v = 3;
    top->en = 0;

    // run simulation for 300 cycles
    for (i=0; i<300; i++) {

        // Toggle clock
        for (clk = 0; clk < 2; clk++) {
            tfp->dump (2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        // Check if Vbuddy flag is set
        top->en = vbdFlag();     // Enable signal

        // Send BCD values to Vbuddy
        vbdHex(4, (int(top->bcd) >> 8) & 0xF);
        vbdHex(3, (int(top->bcd) >> 4) & 0xF);
        vbdHex(2, int(top->bcd) & 0xF);

        vbdPlot(int(top->bcd), 0, 999);

        vbdCycle(i+1);
        
        // Reset for the first few cycles
        top->rst = (i < 2) | (i == 15);
        
        if (Verilated::gotFinish()) exit(0);
    }

    vbdClose();
    tfp->close();
    exit(0);
}
