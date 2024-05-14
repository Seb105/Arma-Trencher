params ["_origin", "_nodes", "_terrainPoints", "_widthToObj"];
// Iterate through and remove duplicatge [x,y] points, keeping the lowest z
private _terrainPointsFiltered = [];
{
    private _point = _x;
    private _existing = _terrainPointsFiltered findIf {_x#0 isEqualTo _point#0 and _x#1 isEqualTo _point#1};
    if (_existing isEqualTo -1) then {
        _terrainPointsFiltered pushBack _point;
    } else {
        private _existingZ = (_terrainPointsFiltered#_existing)#2;
        if (_existingZ > _point#2) then {
            _terrainPointsFiltered set [_existing, _point];
        };
    };
} forEach _terrainPoints;
_origin setVariable ["points", _terrainPoints];

// Subtract the depth of trench
private _terrainPointsSub = _terrainPointsFiltered;// apply {_x vectorAdd [0,0,-_trueDepth]}; 
[_terrainPointsSub, true, true] call TerrainLib_fnc_setTerrainHeight;
// Restore end piece to blend transition
private _endPieces = _nodes select {count get3DENConnections _x <= 1};
{
    private _node = _x;
    private _area = [_node, [_widthToObj*2, _widthToObj*2, 0, false]];
    [_area, true, 0.5, 3] call TerrainLib_fnc_restoreTerrainHeight;
} forEach _endPieces;
