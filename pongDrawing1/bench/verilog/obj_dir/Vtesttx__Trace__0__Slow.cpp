// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtesttx__Syms.h"


VL_ATTR_COLD void Vtesttx___024root__trace_init_sub__TOP__0(Vtesttx___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+26,"i_clk", false,-1);
    tracep->declBit(c+27,"o_uart_tx", false,-1);
    tracep->pushNamePrefix("testtx ");
    tracep->declBit(c+26,"i_clk", false,-1);
    tracep->declBit(c+27,"o_uart_tx", false,-1);
    for (int i = 0; i < 16; ++i) {
        tracep->declBus(c+1+i*1,"message", true,(i+0), 7,0);
    }
    tracep->declBus(c+17,"counter", false,-1, 27,0);
    tracep->declBit(c+18,"tx_busy", false,-1);
    tracep->declBit(c+19,"tx_stb", false,-1);
    tracep->declBus(c+20,"tx_index", false,-1, 3,0);
    tracep->declBus(c+21,"tx_data", false,-1, 7,0);
    tracep->pushNamePrefix("transmitter ");
    tracep->declBus(c+28,"TIMING_BITS", false,-1, 4,0);
    tracep->declBus(c+28,"TB", false,-1, 4,0);
    tracep->declBus(c+29,"CLOCKS_PER_BAUD", false,-1, 23,0);
    tracep->declBit(c+26,"i_clk", false,-1);
    tracep->declBit(c+19,"i_wr", false,-1);
    tracep->declBus(c+21,"i_data", false,-1, 7,0);
    tracep->declBit(c+27,"o_uart_tx", false,-1);
    tracep->declBit(c+18,"o_busy", false,-1);
    tracep->declBus(c+30,"TXUL_BIT_ZERO", false,-1, 3,0);
    tracep->declBus(c+31,"TXUL_STOP", false,-1, 3,0);
    tracep->declBus(c+32,"TXUL_IDLE", false,-1, 3,0);
    tracep->declBus(c+22,"baud_counter", false,-1, 23,0);
    tracep->declBus(c+23,"state", false,-1, 3,0);
    tracep->declBus(c+24,"lcl_data", false,-1, 7,0);
    tracep->declBit(c+18,"r_busy", false,-1);
    tracep->declBit(c+25,"zero_baud_counter", false,-1);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vtesttx___024root__trace_init_top(Vtesttx___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_init_top\n"); );
    // Body
    Vtesttx___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtesttx___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtesttx___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtesttx___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtesttx___024root__trace_register(Vtesttx___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vtesttx___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vtesttx___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vtesttx___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtesttx___024root__trace_full_sub_0(Vtesttx___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtesttx___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_full_top_0\n"); );
    // Init
    Vtesttx___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtesttx___024root*>(voidSelf);
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtesttx___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtesttx___024root__trace_full_sub_0(Vtesttx___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtesttx___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+1,(vlSelf->testtx__DOT__message[0]),8);
    bufp->fullCData(oldp+2,(vlSelf->testtx__DOT__message[1]),8);
    bufp->fullCData(oldp+3,(vlSelf->testtx__DOT__message[2]),8);
    bufp->fullCData(oldp+4,(vlSelf->testtx__DOT__message[3]),8);
    bufp->fullCData(oldp+5,(vlSelf->testtx__DOT__message[4]),8);
    bufp->fullCData(oldp+6,(vlSelf->testtx__DOT__message[5]),8);
    bufp->fullCData(oldp+7,(vlSelf->testtx__DOT__message[6]),8);
    bufp->fullCData(oldp+8,(vlSelf->testtx__DOT__message[7]),8);
    bufp->fullCData(oldp+9,(vlSelf->testtx__DOT__message[8]),8);
    bufp->fullCData(oldp+10,(vlSelf->testtx__DOT__message[9]),8);
    bufp->fullCData(oldp+11,(vlSelf->testtx__DOT__message[10]),8);
    bufp->fullCData(oldp+12,(vlSelf->testtx__DOT__message[11]),8);
    bufp->fullCData(oldp+13,(vlSelf->testtx__DOT__message[12]),8);
    bufp->fullCData(oldp+14,(vlSelf->testtx__DOT__message[13]),8);
    bufp->fullCData(oldp+15,(vlSelf->testtx__DOT__message[14]),8);
    bufp->fullCData(oldp+16,(vlSelf->testtx__DOT__message[15]),8);
    bufp->fullIData(oldp+17,(vlSelf->testtx__DOT__counter),28);
    bufp->fullBit(oldp+18,(vlSelf->testtx__DOT__transmitter__DOT__r_busy));
    bufp->fullBit(oldp+19,(vlSelf->testtx__DOT__tx_stb));
    bufp->fullCData(oldp+20,(vlSelf->testtx__DOT__tx_index),4);
    bufp->fullCData(oldp+21,(vlSelf->testtx__DOT__tx_data),8);
    bufp->fullIData(oldp+22,(vlSelf->testtx__DOT__transmitter__DOT__baud_counter),24);
    bufp->fullCData(oldp+23,(vlSelf->testtx__DOT__transmitter__DOT__state),4);
    bufp->fullCData(oldp+24,(vlSelf->testtx__DOT__transmitter__DOT__lcl_data),8);
    bufp->fullBit(oldp+25,(vlSelf->testtx__DOT__transmitter__DOT__zero_baud_counter));
    bufp->fullBit(oldp+26,(vlSelf->i_clk));
    bufp->fullBit(oldp+27,(vlSelf->o_uart_tx));
    bufp->fullCData(oldp+28,(0x18U),5);
    bufp->fullIData(oldp+29,(0x364U),24);
    bufp->fullCData(oldp+30,(0U),4);
    bufp->fullCData(oldp+31,(8U),4);
    bufp->fullCData(oldp+32,(0xfU),4);
}
