#include "script_component.hpp"
private _allControllers = ((all3DENEntities)#3) select {_x isKindOf QGVAR(Module_TrenchController)};
private _terrainPoints = [];
private _hideAreas = [];
private _simpleObjects = [];
private _simulatedObjects = [];
private _trenchPieces = [];
private _fnc_serialise = {
    params ["_obj"];
    [getPosWorld _obj, [vectorDir _obj, vectorUp _obj], typeOf _obj]
};
_allControllers apply {
    private _controller = _x;
    _terrainPoints append (_controller getVariable QGVAR(terrainPoints));
    _hideAreas append (_controller getVariable QGVAR(hideAreas));
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
    [QUOTE(ADDON), QGVAR(simpleObjects), _simpleObjects],
    [QUOTE(ADDON), QGVAR(simulatedObjects), _simulatedObjects],
    [QUOTE(ADDON), QGVAR(trenchPieces), _trenchPieces],
    [QUOTE(ADDON), QGVAR(hideAreas), _hideAreas],
    [QUOTE(ADDON), QGVAR(terrainPoints), _terrainPoints]
];
// do3DENAction "MissionSave";
