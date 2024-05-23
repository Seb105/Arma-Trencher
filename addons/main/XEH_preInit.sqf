#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "initSettings.sqf"
ADDON = true;
if (is3den) then {
    call FUNC(onMissionLoad);
};
