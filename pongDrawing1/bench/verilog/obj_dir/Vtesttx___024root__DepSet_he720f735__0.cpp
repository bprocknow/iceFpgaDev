// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtesttx.h for the primary calling header

#include "verilated.h"

#include "Vtesttx__Syms.h"
#include "Vtesttx___024root.h"

void Vtesttx___024root___eval_act(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_act\n"); );
}

extern const VlUnpacked<CData/*1:0*/, 128> Vtesttx__ConstPool__TABLE_h830a6074_0;
extern const VlUnpacked<CData/*3:0*/, 128> Vtesttx__ConstPool__TABLE_he96f8c77_0;
extern const VlUnpacked<CData/*0:0*/, 128> Vtesttx__ConstPool__TABLE_he5bf331d_0;

VL_INLINE_OPT void Vtesttx___024root___nba_sequent__TOP__0(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*6:0*/ __Vtableidx1;
    __Vtableidx1 = 0;
    IData/*27:0*/ __Vdly__testtx__DOT__counter;
    __Vdly__testtx__DOT__counter = 0;
    CData/*3:0*/ __Vdly__testtx__DOT__tx_index;
    __Vdly__testtx__DOT__tx_index = 0;
    CData/*0:0*/ __Vdly__testtx__DOT__tx_stb;
    __Vdly__testtx__DOT__tx_stb = 0;
    CData/*0:0*/ __Vdly__testtx__DOT__transmitter__DOT__r_busy;
    __Vdly__testtx__DOT__transmitter__DOT__r_busy = 0;
    CData/*7:0*/ __Vdly__testtx__DOT__transmitter__DOT__lcl_data;
    __Vdly__testtx__DOT__transmitter__DOT__lcl_data = 0;
    CData/*0:0*/ __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter;
    __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter = 0;
    IData/*23:0*/ __Vdly__testtx__DOT__transmitter__DOT__baud_counter;
    __Vdly__testtx__DOT__transmitter__DOT__baud_counter = 0;
    // Body
    __Vdly__testtx__DOT__counter = vlSelf->testtx__DOT__counter;
    __Vdly__testtx__DOT__tx_index = vlSelf->testtx__DOT__tx_index;
    __Vdly__testtx__DOT__tx_stb = vlSelf->testtx__DOT__tx_stb;
    __Vdly__testtx__DOT__transmitter__DOT__baud_counter 
        = vlSelf->testtx__DOT__transmitter__DOT__baud_counter;
    __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter 
        = vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter;
    __Vdly__testtx__DOT__transmitter__DOT__r_busy = vlSelf->testtx__DOT__transmitter__DOT__r_busy;
    __Vdly__testtx__DOT__transmitter__DOT__lcl_data 
        = vlSelf->testtx__DOT__transmitter__DOT__lcl_data;
    __Vdly__testtx__DOT__counter = (0xfffffffU & ((IData)(1U) 
                                                  + vlSelf->testtx__DOT__counter));
    if (((IData)(vlSelf->testtx__DOT__tx_stb) & (~ (IData)(vlSelf->testtx__DOT__transmitter__DOT__r_busy)))) {
        __Vdly__testtx__DOT__tx_index = (0xfU & ((IData)(1U) 
                                                 + (IData)(vlSelf->testtx__DOT__tx_index)));
        __Vdly__testtx__DOT__transmitter__DOT__lcl_data 
            = vlSelf->testtx__DOT__tx_data;
        vlSelf->o_uart_tx = 0U;
    } else if (vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter) {
        __Vdly__testtx__DOT__transmitter__DOT__lcl_data 
            = (0x80U | (0x7fU & ((IData)(vlSelf->testtx__DOT__transmitter__DOT__lcl_data) 
                                 >> 1U)));
        vlSelf->o_uart_tx = (1U & (IData)(vlSelf->testtx__DOT__transmitter__DOT__lcl_data));
    }
    if ((0xfffffffU == vlSelf->testtx__DOT__counter)) {
        __Vdly__testtx__DOT__tx_stb = 1U;
    } else if ((((IData)(vlSelf->testtx__DOT__tx_stb) 
                 & (~ (IData)(vlSelf->testtx__DOT__transmitter__DOT__r_busy))) 
                & (0xfU == (IData)(vlSelf->testtx__DOT__tx_index)))) {
        __Vdly__testtx__DOT__tx_stb = 0U;
    }
    __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter 
        = (1U == vlSelf->testtx__DOT__transmitter__DOT__baud_counter);
    if ((0xfU == (IData)(vlSelf->testtx__DOT__transmitter__DOT__state))) {
        __Vdly__testtx__DOT__transmitter__DOT__baud_counter = 0U;
        __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter = 1U;
        if (((IData)(vlSelf->testtx__DOT__tx_stb) & 
             (~ (IData)(vlSelf->testtx__DOT__transmitter__DOT__r_busy)))) {
            __Vdly__testtx__DOT__transmitter__DOT__baud_counter = 0x363U;
            __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter = 0U;
        }
    } else if (vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter) {
        if ((8U < (IData)(vlSelf->testtx__DOT__transmitter__DOT__state))) {
            __Vdly__testtx__DOT__transmitter__DOT__baud_counter = 0U;
            __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter = 1U;
        } else {
            __Vdly__testtx__DOT__transmitter__DOT__baud_counter 
                = ((8U == (IData)(vlSelf->testtx__DOT__transmitter__DOT__state))
                    ? 0x362U : 0x363U);
        }
    } else {
        __Vdly__testtx__DOT__transmitter__DOT__baud_counter 
            = (0xffffffU & (vlSelf->testtx__DOT__transmitter__DOT__baud_counter 
                            - (IData)(1U)));
    }
    __Vtableidx1 = (((IData)(vlSelf->testtx__DOT__transmitter__DOT__r_busy) 
                     << 6U) | (((IData)(vlSelf->testtx__DOT__tx_stb) 
                                << 5U) | (((IData)(vlSelf->testtx__DOT__transmitter__DOT__state) 
                                           << 1U) | (IData)(vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter))));
    if ((1U & Vtesttx__ConstPool__TABLE_h830a6074_0
         [__Vtableidx1])) {
        vlSelf->testtx__DOT__transmitter__DOT__state 
            = Vtesttx__ConstPool__TABLE_he96f8c77_0
            [__Vtableidx1];
    }
    __Vdly__testtx__DOT__transmitter__DOT__r_busy = 
        Vtesttx__ConstPool__TABLE_he5bf331d_0[__Vtableidx1];
    vlSelf->testtx__DOT__counter = __Vdly__testtx__DOT__counter;
    vlSelf->testtx__DOT__transmitter__DOT__baud_counter 
        = __Vdly__testtx__DOT__transmitter__DOT__baud_counter;
    vlSelf->testtx__DOT__transmitter__DOT__lcl_data 
        = __Vdly__testtx__DOT__transmitter__DOT__lcl_data;
    vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter 
        = __Vdly__testtx__DOT__transmitter__DOT__zero_baud_counter;
    vlSelf->testtx__DOT__tx_stb = __Vdly__testtx__DOT__tx_stb;
    vlSelf->testtx__DOT__transmitter__DOT__r_busy = __Vdly__testtx__DOT__transmitter__DOT__r_busy;
    vlSelf->testtx__DOT__tx_data = vlSelf->testtx__DOT__message
        [vlSelf->testtx__DOT__tx_index];
    vlSelf->testtx__DOT__tx_index = __Vdly__testtx__DOT__tx_index;
}

void Vtesttx___024root___eval_nba(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtesttx___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
}

void Vtesttx___024root___eval_triggers__act(Vtesttx___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtesttx___024root___dump_triggers__act(Vtesttx___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtesttx___024root___dump_triggers__nba(Vtesttx___024root* vlSelf);
#endif  // VL_DEBUG

void Vtesttx___024root___eval(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vtesttx___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vtesttx___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("testtx.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vtesttx___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vtesttx___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("testtx.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vtesttx___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vtesttx___024root___eval_debug_assertions(Vtesttx___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->i_clk & 0xfeU))) {
        Verilated::overWidthError("i_clk");}
}
#endif  // VL_DEBUG
