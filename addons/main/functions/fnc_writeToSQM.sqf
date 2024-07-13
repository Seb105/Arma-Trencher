#include "script_component.hpp"
private _allNodes = ((all3DENEntities)#3) select {_x isKindOf QGVAR(Module_TrenchPiece)};
private _terrainPoints = [];
private _hideAreas = [];
private _simpleObjects = [];
private _simulatedObjects = [];
private _trenchPieces = [];
private _fnc_serialise = {
    params ["_obj"];
    [getPosWorld _obj, [vectorDir _obj, vectorUp _obj], typeOf _obj]
};
_allNodes apply {
    private _controller = _x;
    _terrainPoints append (_controller getVariable QGVAR(terrainPointsSet));
    _hideAreas append (_controller getVariable QGVAR(toHideAreas));
    [
        [_simpleObjects, QGVAR(simpleObjects)],
        [_simulatedObjects, QGVAR(simulatedObjects)],
        [_trenchPieces, QGVAR(trenchPieces)]
    ] apply {
        _x params ["_array", "_var"];
        private _values = (_controller getVariable _var) apply {
            [_x] call _fnc_serialise
        };
        _array append _values;
    };
};
set3DENMissionAttributes [
    [QUOTE(ADDON), QGVAR(simpleObjects), str _simpleObjects],
    [QUOTE(ADDON), QGVAR(simulatedObjects), str _simulatedObjects],
    [QUOTE(ADDON), QGVAR(trenchPieces), str _trenchPieces],
    [QUOTE(ADDON), QGVAR(hideAreas), str _hideAreas],
    [QUOTE(ADDON), QGVAR(terrainPoints), str _terrainPoints]
];
// do3DENAction "MissionSave";
