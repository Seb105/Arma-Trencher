#include "script_component.hpp"
params ["_nodes", "_widthToEdge", "_blendTrenchEnds", "_depth", "_cellSize"];
// Vestigial function i cba to remove
_nodes apply {
    private _node = _x;
    private _terrainPoints = _node getVariable QGVAR(terrainPoints);
    [_terrainPoints, true, true] call TerrainLib_fnc_setTerrainHeight;
    _node setVariable [QGVAR(terrainPointsSet), _terrainPoints];
};
(all3DENEntities#0) apply {
    _x setPosATL (_x get3DENAttribute "position")#0;
}
