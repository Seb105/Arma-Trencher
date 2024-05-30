#include "script_component.hpp"
params ["_module"];
private _ehs = [
    "AttributesChanged3DEN",
    "ConnectionChanged3DEN",
    "RegisteredToWorld3DEN"
];
// _module call FUNC(buildTrenchSystem);
{
    private _eh = _x;
    _module addEventHandler [_eh, {
        params ["_object"];
        if (time < 1) exitWith {};
        _object call FUNC(buildTrenchSystem);
    }];
} forEach _ehs;
// Object is deleted AFTER this eh fires.
_module addEventHandler ["UnregisteredFromWorld3DEN", {
    params ["_object"];
    // Delete anything assosciated with this node.
    [[_object]] call FUNC(cleanUpNodes);
    // Find something that is connnected to this node.
    private _connections = get3DENConnections _object;
    if (count _connections == 0) exitWith {};
    _newObj = _connections#1;
    // Next frame, _object is deleted, so we need to update the new object.
    [{
        params ["_newObj"];
        _newObj call FUNC(buildTrenchSystem);
    },[_newObj]] call CBA_fnc_execNextFrame
}];
