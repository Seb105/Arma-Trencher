#include "script_component.hpp"
params ["_module"];
private _ehs = [
    "AttributesChanged3DEN",
    "ConnectionChanged3DEN",
    "RegisteredToWorld3DEN",
    "UnregisteredFromWorld3DEN"
];
_module call FUNC(updateTrenchSystem);
{
    private _eh = _x;
    _module addEventHandler [_eh, {
        params ["_object"];
        _object call FUNC(updateTrenchSystem);
    }];
} forEach _ehs;
