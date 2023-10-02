// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtesttx.h for the primary calling header

#ifndef VERILATED_VTESTTX___024ROOT_H_
#define VERILATED_VTESTTX___024ROOT_H_  // guard

#include "verilated.h"


class Vtesttx__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtesttx___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(i_clk,0,0);
    VL_OUT8(o_uart_tx,0,0);
    CData/*0:0*/ testtx__DOT__tx_stb;
    CData/*3:0*/ testtx__DOT__tx_index;
    CData/*7:0*/ testtx__DOT__tx_data;
    CData/*3:0*/ testtx__DOT__transmitter__DOT__state;
    CData/*7:0*/ testtx__DOT__transmitter__DOT__lcl_data;
    CData/*0:0*/ testtx__DOT__transmitter__DOT__r_busy;
    CData/*0:0*/ testtx__DOT__transmitter__DOT__zero_baud_counter;
    CData/*0:0*/ __Vtrigprevexpr___TOP__i_clk__0;
    CData/*0:0*/ __VactContinue;
    IData/*27:0*/ testtx__DOT__counter;
    IData/*23:0*/ testtx__DOT__transmitter__DOT__baud_counter;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*7:0*/, 16> testtx__DOT__message;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtesttx__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtesttx___024root(Vtesttx__Syms* symsp, const char* v__name);
    ~Vtesttx___024root();
    VL_UNCOPYABLE(Vtesttx___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
