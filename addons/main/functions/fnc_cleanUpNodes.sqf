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
        QGVAR(terrainPoints),
        []
    ];
    private _originalHeights = _points apply {[_x] call TerrainLib_fnc_unmodifiedTerrainHeight};
    [_originalHeights, true, true] call TerrainLib_fnc_setTerrainHeight;
    _node setVariable [QGVAR(terrainPoints), []];

    _node setVariable [QGVAR(hideAreas), []];

    {
        _x hideObjectGlobal false;
    } forEach (_node getVariable [QGVAR(hiddenObjects), []]);
    _node setVariable [QGVAR(hiddenObjects), []];
} forEach _nodes;
