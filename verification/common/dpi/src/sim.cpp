//==============================================================================
// [Filename]     sim.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      -
// [Modified]     -
// [Description]  DPI (Direct Programming Interface) simulation
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include <iostream>
#include <cstdio>
#include "debouncer.h"

int main(int argc, char* argv[]) {
   (void)argc;
    (void)argv;

  // Initialization
  uint32_t max_count = 100;
  bool rst = 0;
  bool sw = 0;

  // Create object
  Debouncer dut(max_count);

  std::cout << "Begin of simulation" << "\n";

  // Reset
  rst = 1; sw = 0;
  dut.step(rst, sw);
  dut.print_state(" RESET ");

  // Empty
  rst = 0; sw = 0;
  dut.step(rst, sw);
  dut.print_state(" RESET OFF: ");

  // Execution
  std::string idx;
  rst = 0; sw = 1;
  for (std::size_t i = 0; i < 120; i++) {
    idx = std::to_string(i) + " ";
    dut.step(rst, sw);
    dut.print_state(" ITER: " + idx);
  }

  rst = 0; sw = 0;
  dut.step(rst, sw);
  dut.print_state(" LOW ");

  rst = 0; sw = 0;
  dut.step(rst, sw);
  dut.print_state(" LOW ");

  std::cout << "End of simulation" << "\n";

  return 0;
}
