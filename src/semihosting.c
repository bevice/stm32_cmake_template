#include "semihosting.h"
void init_semihosting(){
  #ifdef SEMIHOSTING_ENABLE
  initialise_monitor_handles();
  setbuf(stdout, NULL);
  #endif

}
