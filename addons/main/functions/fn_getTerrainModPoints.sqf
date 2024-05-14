#include "script_component.hpp"
params ["_centerLine", "_segmentEnd", "_terrainPoints", "_distToEdge", "_distToObjCentre", "_segmentLength", "_dir", "_currentHeight", "_nextHeight", "_trueDepth"];
private _modifyArea = [_centerLine, _distToEdge, _segmentLength, _dir, true, -1];
private _cellSize = (getTerrainInfo)#2;
private _lowerArea = [_centerLine, (_distToEdge-_cellSize) max _distToObjCentre, _segmentLength, _dir, true, -1];
private _newPoints = [_modifyArea] call TerrainLib_fnc_getAreaTerrainGrid;
_newPoints apply {
    // Flatten nodes inside the walls, lower ones in the trench proper.
    private _sub = [0, _trueDepth] select (_x inArea _lowerArea);
    // This extracts the length along the trench of the point, ignoring the width component
    // Then it uses this as a weight to blend between the current and next height.
    // This makes the trench segments blend into each other.
    private _magDist = _x distance2D _segmentEnd;
    private _angleTo = _x getDir _segmentEnd;
    private _distToStart = _magDist * cos (_angleTo - _dir);
    private _weight = _distToStart / _segmentLength;
    private _trueCurrentHeight = _currentHeight * _weight + _nextHeight * (1-_weight);
    _x set [2, _trueCurrentHeight - _sub];
};
_terrainPoints append _newPoints;
