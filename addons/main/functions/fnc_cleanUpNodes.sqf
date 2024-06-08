#include "script_component.hpp"
// Deletes all trench pieces and restores terrain to original height.
params ["_nodes"];
{
    private _node = _x;        
    {
        deleteVehicle _x;
    } forEach (_node getVariable [QGVAR(simpleObjects), []]);
    _node setVariable [QGVAR(simpleObjects), []];
    
    {
        deleteVehicle _x;
    } forEach (_node getVariable [QGVAR(simulatedObjects), []]);
    _node setVariable [QGVAR(simulatedObjects), []];
    
    {
        deleteVehicle _x;
    } forEach (_node getVariable [QGVAR(trenchPieces), []]);
    _node setVariable [QGVAR(trenchPieces), []];

    private _points = _node getVariable [
        QGVAR(terrainPointsSet),
        []
    ];
    private _originalHeights = _points apply {[_x] call TerrainLib_fnc_unmodifiedTerrainHeight};
    [_originalHeights, true, true] call TerrainLib_fnc_setTerrainHeight;

    {
        _x hideObjectGlobal false;
    } forEach (_node getVariable [QGVAR(toHideObjs), []]);
    _node setVariable [QGVAR(toHideObjs), []];

    [
        QGVAR(toHideObjs),
        QGVAR(lines),
        QGVAR(ends),
        QGVAR(toPlace),
        QGVAR(toHideAreas),
        QGVAR(toPlace),
        QGVAR(terrainPoints)
    ] apply {
        _node setVariable [_x, nil];
    };

    // Blank hashmap sets all settings to nil.
    // [_node, nil] call FUNC(nodeSettingsSet);
} forEach _nodes;
