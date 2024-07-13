#include "script_component.hpp"
// Deletes all trench pieces and restores terrain to original height.
params ["_nodes"];
{
    private _node = _x;

    private _objArrayVars = [
        QGVAR(simpleObjects),
        QGVAR(simulatedObjects),
        QGVAR(trenchPieces),
        QGVAR(edenObjects)
    ];

    _objArrayVars apply {
        private _varName = _x;
        private _objs = +(_node getVariable [_varName, []]);
        [_objs] spawn {
            params ["_objs"];
            sleep (random 1);
            {
                deleteVehicle _x;
            } forEach _objs;
        };
        _node setVariable [_varName, []];
    };

    private _points = _node getVariable [
        QGVAR(terrainPointsSet),
        []
    ];
    private _originalHeights = _points apply {[_x] call TerrainLib_fnc_unmodifiedTerrainHeight};
    [_originalHeights, false, true] call TerrainLib_fnc_setTerrainHeight;

    {
        _x hideObjectGlobal false;
    } forEach (_node getVariable [QGVAR(toHideObjs), []]);
    _node setVariable [QGVAR(toHideObjs), []];

    [
        QGVAR(toHideObjs),
        QGVAR(lines),
        QGVAR(ends),
        QGVAR(toPlace),
        QGVAR(toHideAreass),
        QGVAR(toPlace),
        QGVAR(terrainPoints)
    ] apply {
        _node setVariable [_x, nil];
    };

    // Blank hashmap sets all settings to nil.
    // [_node, nil] call FUNC(nodeSettingsSet);
} forEach _nodes;
