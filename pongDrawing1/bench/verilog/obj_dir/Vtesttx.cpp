// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtesttx.h"
#include "Vtesttx__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtesttx::Vtesttx(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtesttx__Syms(contextp(), _vcname__, this)}
    , i_clk{vlSymsp->TOP.i_clk}
    , o_uart_tx{vlSymsp->TOP.o_uart_tx}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vtesttx::Vtesttx(const char* _vcname__)
    : Vtesttx(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtesttx::~Vtesttx() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtesttx___024root___eval_debug_assertions(Vtesttx___024root* vlSelf);
#endif  // VL_DEBUG
void Vtesttx___024root___eval_static(Vtesttx___024root* vlSelf);
void Vtesttx___024root___eval_initial(Vtesttx___024root* vlSelf);
void Vtesttx___024root___eval_settle(Vtesttx___024root* vlSelf);
void Vtesttx___024root___eval(Vtesttx___024root* vlSelf);

void Vtesttx::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtesttx::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtesttx___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtesttx___024root___eval_static(&(vlSymsp->TOP));
        Vtesttx___024root___eval_initial(&(vlSymsp->TOP));
        Vtesttx___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtesttx___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtesttx::eventsPending() { return false; }

uint64_t Vtesttx::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vtesttx::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtesttx___024root___eval_final(Vtesttx___024root* vlSelf);

VL_ATTR_COLD void Vtesttx::final() {
    Vtesttx___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtesttx::hierName() const { return vlSymsp->name(); }
const char* Vtesttx::modelName() const { return "Vtesttx"; }
unsigned Vtesttx::threads() const { return 1; }
void Vtesttx::prepareClone() const { contextp()->prepareClone(); }
void Vtesttx::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vtesttx::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vtesttx___024root__trace_init_top(Vtesttx___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtesttx___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtesttx___024root*>(voidSelf);
    Vtesttx__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vtesttx___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vtesttx___024root__trace_register(Vtesttx___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtesttx::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtesttx::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vtesttx___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
