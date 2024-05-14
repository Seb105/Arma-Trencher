params ["_centerLine", "_terrainPoints", "_widthToObj", "_segmentLength", "_dir", "_next", "_currentHeight", "_nextHeight", "_trueDepth"];
private _modifyArea = [_centerLine, _widthToObj, _segmentLength, _dir, true, -1];
private _newPoints = [_modifyArea] call TerrainLib_fnc_getAreaTerrainGrid;
_newPoints apply {
    // This extracts the length along the trench of the point, ignoring the width component
    // Then it uses this as a weight to blend between the current and next height.
    // This makes the trench segments blend into each other.
    private _magDist = _x distance2D _next;
    private _angleTo = _x getDir _next;
    private _distToStart = _magDist * cos (_angleTo - _dir);
    private _weight = _distToStart / _segmentLength;
    private _trueCurrentHeight = _currentHeight * _weight + _nextHeight * (1-_weight);
    _x set [2, _trueCurrentHeight - _trueDepth];
};
_terrainPoints append _newPoints;
