#include "script_component.hpp"
private _allTrenchNetworks = call FUNC(allTrenchNetworks);
{
    private _origin = _x#0;
    // systemChat format ["Building trench system at %1", _origin];
    [_origin] call FUNC(buildTrenchSystem);
} forEach _allTrenchNetworks;


// This function runs every time the mission is loaded, but also every time the scenario preview is exited
// We need to make sure that we don't register the entities multiple times
private _allNodes = (all3DENEntities#3) select {_x isKindOf QGVAR(Module_TrenchPiece)};
_allNodes apply {_x call FUNC(registerEntity)};
if (missionNameSpace getVariable [QGVAR(EHSADDED), false]) exitWith {
    // systemchat "Trenches already initialized";
};
add3DENEventHandler ["OnEditableEntityAdded", {_this call FUNC(onEntityAdded)}];
add3DENEventHandler ["OnMissionPreviewEnd", {
	GVAR(EHSADDED) = true
}];
