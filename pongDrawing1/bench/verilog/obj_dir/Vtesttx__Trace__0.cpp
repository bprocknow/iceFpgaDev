// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtesttx__Syms.h"


void Vtesttx___024root__trace_chg_sub_0(Vtesttx___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtesttx___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_chg_top_0\n"); );
    // Init
    Vtesttx___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtesttx___024root*>(voidSelf);
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtesttx___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vtesttx___024root__trace_chg_sub_0(Vtesttx___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[0U])) {
        bufp->chgCData(oldp+0,(vlSelf->testtx__DOT__message[0]),8);
        bufp->chgCData(oldp+1,(vlSelf->testtx__DOT__message[1]),8);
        bufp->chgCData(oldp+2,(vlSelf->testtx__DOT__message[2]),8);
        bufp->chgCData(oldp+3,(vlSelf->testtx__DOT__message[3]),8);
        bufp->chgCData(oldp+4,(vlSelf->testtx__DOT__message[4]),8);
        bufp->chgCData(oldp+5,(vlSelf->testtx__DOT__message[5]),8);
        bufp->chgCData(oldp+6,(vlSelf->testtx__DOT__message[6]),8);
        bufp->chgCData(oldp+7,(vlSelf->testtx__DOT__message[7]),8);
        bufp->chgCData(oldp+8,(vlSelf->testtx__DOT__message[8]),8);
        bufp->chgCData(oldp+9,(vlSelf->testtx__DOT__message[9]),8);
        bufp->chgCData(oldp+10,(vlSelf->testtx__DOT__message[10]),8);
        bufp->chgCData(oldp+11,(vlSelf->testtx__DOT__message[11]),8);
        bufp->chgCData(oldp+12,(vlSelf->testtx__DOT__message[12]),8);
        bufp->chgCData(oldp+13,(vlSelf->testtx__DOT__message[13]),8);
        bufp->chgCData(oldp+14,(vlSelf->testtx__DOT__message[14]),8);
        bufp->chgCData(oldp+15,(vlSelf->testtx__DOT__message[15]),8);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+16,(vlSelf->testtx__DOT__counter),28);
        bufp->chgBit(oldp+17,(vlSelf->testtx__DOT__transmitter__DOT__r_busy));
        bufp->chgBit(oldp+18,(vlSelf->testtx__DOT__tx_stb));
        bufp->chgCData(oldp+19,(vlSelf->testtx__DOT__tx_index),4);
        bufp->chgCData(oldp+20,(vlSelf->testtx__DOT__tx_data),8);
        bufp->chgIData(oldp+21,(vlSelf->testtx__DOT__transmitter__DOT__baud_counter),24);
        bufp->chgCData(oldp+22,(vlSelf->testtx__DOT__transmitter__DOT__state),4);
        bufp->chgCData(oldp+23,(vlSelf->testtx__DOT__transmitter__DOT__lcl_data),8);
        bufp->chgBit(oldp+24,(vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter));
    }
    bufp->chgBit(oldp+25,(vlSelf->i_clk));
    bufp->chgBit(oldp+26,(vlSelf->o_uart_tx));
}

void Vtesttx___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_cleanup\n"); );
    // Init
    Vtesttx___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtesttx___024root*>(voidSelf);
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
