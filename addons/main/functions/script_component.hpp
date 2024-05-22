#define COMPONENT main
#include "\z\trencher\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\trencher\addons\main\script_macros.hpp"

#define SEGMENT_LENGTH 7.5
#define SEGMENT_LENGTH_HALF (SEGMENT_LENGTH/2)
#define SEGMENT_WIDTH 9
#define SEGMENT_WIDTH_HALF (SEGMENT_WIDTH/2)
#define SEGMENT_SLOPE_TOP 2.7
#define SEGMENT_SLOPE_BOTTOM 2.2
#define SEGMENT_FALL (SEGMENT_SLOPE_TOP-SEGMENT_SLOPE_BOTTOM)
