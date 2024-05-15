#include "script_component.hpp"
[] spawn {
    // retard script wont work right at mission load unless i do this shit
    waitUntil {time > 1};
    isNil {
        private _allTrenchNetworks = call FUNC(allTrenchNetworks);
        {
            private _origin = _x#0;
            [_origin] call FUNC(buildTrenchSystem);
        } forEach _allTrenchNetworks;
    };
};
