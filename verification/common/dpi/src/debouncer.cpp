//==============================================================================
// [Filename]     debouncer.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Dec 2025
// [Modified]     -
// [Description]  DPI (Direct Programming Interface) model
// [Notes]        
//                reset -> clear state
//                input change -> model sync latency
//                stable input -> restart debounce counter
//                counter reaches max_count - 1 -> update debounced level
//                0 -> 1 debounced transition -> generate one-cycle tick
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include "debouncer.h"

Debouncer::Debouncer(uint32_t max_count)
  : max_count(max_count)
{
}

void Debouncer::step(bool rst, bool sw) {

  if (rst) {
    cycle_counter = 0;
    sync_counter = 0;

    sw_state = 0;
    level_state = 0;
    tick_state = 0;
    
    value_to_load = 0;
  } else {

    // Default value for tick
    tick_state = 0;

    // Check debouncer condition
    if (cycle_counter == max_count - 1) {
      if (level_state == 0 && value_to_load == 1) {
        tick_state = 1;
      }
      level_state = value_to_load;
    }

    // Check for input changes and model a 2-cycle input latency.
    // The first sample is the cycle where the change is detected.
    // If the value is still stable on the next cycle, sync_counter becomes 1,
    // which represents the second stable sample.
    if (sw != sw_state) {
      sync_counter = 0;
    } else {
      if (sync_counter <= 2) {
        sync_counter++;
      }
    }
      
    // After the second stable sample, restart the debounce counter
    // and capture the value that will be loaded after the stable time.
    if (sync_counter == 1) {
      cycle_counter = 0;
      value_to_load = sw;
    } else {
     if (cycle_counter < max_count - 1) {
       cycle_counter++;
     } 
    }
    
    // Update state
    sw_state = sw;
  }
}


void Debouncer::print_state(std::string const& msg) {
  std::cout << "\n================" << msg << "==============\n";
  printf("Sync counter:     0d%04d\n", sync_counter);
  printf("Cycle counter:    0d%04d\n", cycle_counter);
  printf("Level state:      0d%04d\n", level_state);
  printf("Tick state:       0d%04d\n", tick_state);
  printf("SW state:         0d%04d\n", sw_state);
}