#include "script_component.hpp"
systemchat "Trenches loaded 1";
[] spawn {
    // retard script wont work right at mission start
    waitUntil {missionNameSpace getVariable ["BIS_fnc_init", false]};
    isNil {
        systemChat "Trenches loaded 2";
        private _allTrenchNetworks = call FUNC(allTrenchNetworks);
        {
            private _origin = _x#0;
            [_origin] call FUNC(buildTrenchSystem);
        } forEach _allTrenchNetworks;
    };
};
