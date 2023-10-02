// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtesttx.h for the primary calling header

#include "verilated.h"

#include "Vtesttx__Syms.h"
#include "Vtesttx__Syms.h"
#include "Vtesttx___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtesttx___024root___dump_triggers__act(Vtesttx___024root* vlSelf);
#endif  // VL_DEBUG

void Vtesttx___024root___eval_triggers__act(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->i_clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_clk__0))));
    vlSelf->__Vtrigprevexpr___TOP__i_clk__0 = vlSelf->i_clk;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtesttx___024root___dump_triggers__act(vlSelf);
    }
#endif
}
