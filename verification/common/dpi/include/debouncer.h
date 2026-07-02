//==============================================================================
// [Filename]     debouncer.h
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Dec 2025
// [Modified]     -
// [Description]  -
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#ifndef DEBOUNCER_H
#define DEBOUNCER_H

#include <iostream>
#include <cstdio>
#include <cstdint>
#include <fstream>

class Debouncer {
  public:
    Debouncer(uint32_t max_count);
    void step(bool rst, bool sw);
    void print_state(std::string const& msg = "State");
    
    bool get_tick_state()     const { return tick_state;    }
    bool get_level_state()    const { return level_state;   }
    uint32_t get_cycle_counter()  const { return cycle_counter; }
    
  private:
    
    uint32_t max_count;

    // Outputs
    bool tick_state = 0;
    bool level_state = 0;

    // Internal
    bool sw_state = 0;
    uint32_t cycle_counter = 0;
    uint32_t sync_counter = 0;
    bool value_to_load = 0;
};

/*
 * SystemVerilog DPI-C Data Type Mappings
 * ========================================
 *
 * BASIC DATA TYPES
 * -------------------------------------------------------------------------------
 * SystemVerilog      | C/C++ (svdpi.h)    | Size   | Notes
 * -------------------------------------------------------------------------------
 * byte               | char               | 8-bit  | Signed
 * shortint           | short int          | 16-bit | Signed
 * int                | int                | 32-bit | Signed
 * longint            | long long          | 64-bit | Signed
 * real               | double             | 64-bit | IEEE 754
 * shortreal          | float              | 32-bit | IEEE 754
 * chandle            | void*              | Ptr    | Opaque handle
 * string             | const char*        | Ptr    | Null-terminated
 * bit                | svBit              | 1-bit  | Unsigned
 * logic              | svLogic            | 1-bit  | 4-state (0,1,X,Z)
 *
 * PACKED ARRAYS (VECTORS)
 * -------------------------------------------------------------------------------
 * SystemVerilog      | C/C++ (svdpi.h)    | Notes
 * -------------------------------------------------------------------------------
 * bit [N:0]          | svBitVecVal*       | 2-state vector
 * logic [N:0]        | svLogicVecVal*     | 4-state vector
 *
 * UNPACKED ARRAYS
 * -------------------------------------------------------------------------------
 * SystemVerilog      | C/C++ (svdpi.h)           | Notes
 * -------------------------------------------------------------------------------
 * Open array []      | const svOpenArrayHandle   | Read-only array
 * Open array []      | svOpenArrayHandle         | Writable array
 *
 * SPECIAL TYPES
 * -------------------------------------------------------------------------------
 * Type               | Usage
 * -------------------------------------------------------------------------------
 * svScope            | Get/set current scope
 * svBitVecVal        | Structure for bit vectors
 * svLogicVecVal      | Structure for logic vectors (aval/bval)
 *
 * EXAMPLE USAGE:
 * -------------------------------------------------------------------------------
 * #include "svdpi.h"
 *
 * extern "C" void my_dpi_func(
 *     int a,              // SystemVerilog: int
 *     long long b,        // SystemVerilog: longint
 *     double c,           // SystemVerilog: real
 *     const char* str,    // SystemVerilog: string
 *     void* handle        // SystemVerilog: chandle
 * );
 */

 #endif // DEBOUNCER_H
