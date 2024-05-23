#include "script_component.hpp"
params ["_controller", "_nodes", "_terrainPoints", "_widthToEdge", "_blendTrenchEnds"];
// Iterate through and remove duplicatge [x,y] points, keeping the average Z
private _terrainPointsFiltered = [];
while {count _terrainPoints > 0} do {
    private _point = _terrainPoints#0;
    private _matching = _terrainPoints select {_x#0 isEqualTo _point#0 && {_x#1 isEqualTo _point#1}};
    _terrainPoints = _terrainPoints - _matching;
    private _matchingCount = count _matching;
    if (_matchingCount > 1) then {
        private _matchingZ = 0;
        {
            _matchingZ = _x#2 + _matchingZ;
        } forEach _matching;
        _matchingZ = _matchingZ / _matchingCount;
        _point set [2, _matchingZ];
    };
    _terrainPointsFiltered pushBack _point;
};
// Subtract the depth of trench
[_terrainPointsFiltered, true, true] call TerrainLib_fnc_setTerrainHeight;
// Restore end piece to blend transition
if !(_blendTrenchEnds) exitWith {};
private _restoredPoints = [];
private _endPieces = _nodes select {count get3DENConnections _x <= 1};
{
    private _node = _x;
    private _area = [_node, [_widthToEdge*2, _widthToEdge*2, 0, true]];
    private _restored = [_area, true, 0.5, 0] call TerrainLib_fnc_restoreTerrainHeight;
    _restoredPoints append _restored;
} forEach _endPieces;
// Overwrite low points in the original array
{
    private _point = _x;
    private _existing = _terrainPointsFiltered findIf {_x#0 isEqualTo _point#0 and _x#1 isEqualTo _point#1};
    if (_existing isNotEqualTo -1) then {
        private _existingZ = (_terrainPointsFiltered#_existing)#2;
        if (_existingZ < _point#2) then {
            _terrainPointsFiltered set [_existing, _point];
        };
    };
} forEach _restoredPoints;
_terrainPointsFiltered
