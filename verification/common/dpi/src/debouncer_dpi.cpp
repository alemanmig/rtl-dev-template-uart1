//==============================================================================
// [Filename]     debouncer_dpi.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      -
// [Modified]     -
// [Description]  -
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include "svdpi.h"
#include "debouncer.h"

static Debouncer g_dut(100);

extern "C" void debouncer_step(
    svBit rst,
    svBit sw,
    svBit* tick_state,
    svBit* level_state,
    unsigned int* cycle_counter
) {
    
    g_dut.step(static_cast<bool>(rst), static_cast<bool>(sw));
    // g_dut.print_state(" Debug C++ ");

    *tick_state  = static_cast<svBit>(g_dut.get_tick_state());
    *level_state = static_cast<svBit>(g_dut.get_level_state());
    *cycle_counter = static_cast<unsigned int>(g_dut.get_cycle_counter());
}

