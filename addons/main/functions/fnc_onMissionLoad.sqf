#include "script_component.hpp"

[QGVAR(Module_TrenchSkipper), QGVAR(Module_TrenchPiece)] apply {
    private _type = _x;
    private _allType = (all3DENEntities#3) select {_x isKindOf _type};
    _allType apply {_x call FUNC(registerEntity)};
    [_type, "init", {_this call FUNC(registerEntity)}, true, []] call CBA_fnc_addClassEventHandler;
};

private _allTrenchNetworks = call FUNC(allTrenchNetworks);
{
    private _origin = _x#0;
    // systemChat format ["Building trench system at %1", _origin];
    [_origin] call FUNC(buildTrenchSystem);
} forEach _allTrenchNetworks;

// if (missionNameSpace getVariable [QGVAR(EHSADDED), false]) exitWith {
    // systemchat "Trenches already initialized";
// };
// add3DENEventHandler ["OnEditableEntityAdded", {_this call FUNC(onEntityAdded)}];
// add3DENEventHandler ["OnMissionPreviewEnd", {
// 	GVAR(EHSADDED) = true
// }];
