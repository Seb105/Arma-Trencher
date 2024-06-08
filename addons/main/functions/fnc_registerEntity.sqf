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
        // systemChat str [get3DENEntityID _object, _thisEvent];
        // [_object, diag_frameNo] spawn {
        //     params ["_object", "_frameNo"];
        //     waitUntil {diag_frameNo > _frameNo};
        //     isNil {
        //         _object call FUNC(buildTrenchSystem);
        //     };
        // };
    }];
} forEach _ehs;
// Object is deleted AFTER this eh fires.
_module addEventHandler ["UnregisteredFromWorld3DEN", {
    params ["_object"];
    // Delete anything assosciated with this node.
    [[_object]] call FUNC(cleanUpNodes);
    // Connections are deleted before this EH fires, so get cached.
    private _connections = _object getVariable [QGVAR(connections), []];
    [_connections, diag_frameNo] spawn {
        params ["_connections", "_frameNo"];
        waitUntil {diag_frameNo > _frameNo};
        _connections apply {_x call FUNC(buildTrenchSystem)};
    };
}];
