// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtesttx.h for the primary calling header

#include "verilated.h"

#include "Vtesttx__Syms.h"
#include "Vtesttx___024root.h"

VL_ATTR_COLD void Vtesttx___024root___eval_static(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vtesttx___024root___eval_initial__TOP(Vtesttx___024root* vlSelf);

VL_ATTR_COLD void Vtesttx___024root___eval_initial(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_initial\n"); );
    // Body
    Vtesttx___024root___eval_initial__TOP(vlSelf);
    vlSelf->__Vm_traceActivity[1U] = 1U;
    vlSelf->__Vm_traceActivity[0U] = 1U;
    vlSelf->__Vtrigprevexpr___TOP__i_clk__0 = vlSelf->i_clk;
}

VL_ATTR_COLD void Vtesttx___024root___eval_initial__TOP(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_initial__TOP\n"); );
    // Body
    vlSelf->testtx__DOT__message[0U] = 0x48U;
    vlSelf->testtx__DOT__message[1U] = 0x65U;
    vlSelf->testtx__DOT__message[2U] = 0x6cU;
    vlSelf->testtx__DOT__message[3U] = 0x6cU;
    vlSelf->testtx__DOT__message[4U] = 0x6fU;
    vlSelf->testtx__DOT__message[5U] = 0x2cU;
    vlSelf->testtx__DOT__message[6U] = 0x20U;
    vlSelf->testtx__DOT__message[7U] = 0x57U;
    vlSelf->testtx__DOT__message[8U] = 0x6fU;
    vlSelf->testtx__DOT__message[9U] = 0x72U;
    vlSelf->testtx__DOT__message[0xaU] = 0x6cU;
    vlSelf->testtx__DOT__message[0xbU] = 0x64U;
    vlSelf->testtx__DOT__message[0xcU] = 0x21U;
    vlSelf->testtx__DOT__message[0xdU] = 0x20U;
    vlSelf->testtx__DOT__message[0xeU] = 0xdU;
    vlSelf->testtx__DOT__message[0xfU] = 0xaU;
    vlSelf->testtx__DOT__counter = 0xffffff0U;
    vlSelf->testtx__DOT__tx_index = 0U;
    vlSelf->testtx__DOT__tx_stb = 0U;
    vlSelf->testtx__DOT__transmitter__DOT__r_busy = 1U;
    vlSelf->testtx__DOT__transmitter__DOT__state = 0xfU;
    vlSelf->testtx__DOT__transmitter__DOT__lcl_data = 0xffU;
    vlSelf->o_uart_tx = 1U;
    vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter = 1U;
    vlSelf->testtx__DOT__transmitter__DOT__baud_counter = 0U;
}

VL_ATTR_COLD void Vtesttx___024root___eval_final(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vtesttx___024root___eval_settle(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtesttx___024root___dump_triggers__act(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge i_clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtesttx___024root___dump_triggers__nba(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge i_clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtesttx___024root___ctor_var_reset(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->i_clk = VL_RAND_RESET_I(1);
    vlSelf->o_uart_tx = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->testtx__DOT__message[__Vi0] = VL_RAND_RESET_I(8);
    }
    vlSelf->testtx__DOT__counter = VL_RAND_RESET_I(28);
    vlSelf->testtx__DOT__tx_stb = VL_RAND_RESET_I(1);
    vlSelf->testtx__DOT__tx_index = VL_RAND_RESET_I(4);
    vlSelf->testtx__DOT__tx_data = VL_RAND_RESET_I(8);
    vlSelf->testtx__DOT__transmitter__DOT__baud_counter = VL_RAND_RESET_I(24);
    vlSelf->testtx__DOT__transmitter__DOT__state = VL_RAND_RESET_I(4);
    vlSelf->testtx__DOT__transmitter__DOT__lcl_data = VL_RAND_RESET_I(8);
    vlSelf->testtx__DOT__transmitter__DOT__r_busy = VL_RAND_RESET_I(1);
    vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__i_clk__0 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
