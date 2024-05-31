#include "script_component.hpp"
params ["_pairs", "_widthToEdge", "_widthToObj", "_cellSize", "_trueDepth"];
private _terrainPoints = [];
{
    _x params ["_startNode", "_endNode"];
    private _startNodePos = getPosASL _startNode;
    private _endNodePos = getPosASL _endNode;
    _startNodePos set [2, 0];
    _endNodePos set [2, 0];
    private _vectorDir = _startNodePos vectorFromTo _endNodePos;
    private _start = _startNodePos vectorAdd (_vectorDir vectorMultiply SEGMENT_LENGTH_HALF);
    private _end = _endNodePos vectorAdd (_vectorDir vectorMultiply -SEGMENT_LENGTH_HALF);
    private _distance = _start distance2D _end;
    private _dir = _start getDir _end;
    private _offsetToBack = [[0,0,0], _dir-90, _widthToEdge] call FUNC(offset);
    private _offsetToFront = [[0,0,0], _dir+90, _widthToEdge] call FUNC(offset);
    private _numSteps = (floor (_distance/SEGMENT_LENGTH))+1;
    private _step = (_endNodePos vectorDiff _startNodePos) vectorMultiply (1/_numSteps);
    private _halfStep = _step vectorMultiply 0.5;
    private _inverseHalfStep = _halfStep vectorMultiply -1;
    // private _start = _startNodePos vectorAdd (_step vectorMultiply 0.5);
    for "_i" from (0) to (_numSteps-1) do {
        private _segmentCentre = _start vectorAdd (_step vectorMultiply _i);
        private _segmentStart = _segmentCentre vectorAdd _inverseHalfStep;
        private _segmentEnd = _segmentCentre vectorAdd _halfStep;
        private _currentHeight = selectMin ([_offsetToBack, _offsetToFront] apply {
            // POINTS pushBack (_segmentStart vectorAdd _x);
            getTerrainHeightASL (_segmentStart vectorAdd _x)
        });
        private _nextHeight = selectMin ([_offsetToBack, _offsetToFront] apply {
            getTerrainHeightASL (_segmentEnd vectorAdd _x)
        });
        private _modifyArea = [_segmentCentre, _widthToEdge-2, SEGMENT_LENGTH, _dir, true, -1];
        private _lowerArea = [_segmentCentre, (_widthToEdge-_cellSize) max _widthToObj, SEGMENT_LENGTH, _dir, true, -1];
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
            private _weight = _distToStart / SEGMENT_LENGTH;
            private _trueCurrentHeight = _currentHeight * _weight + _nextHeight * (1-_weight);
            _x set [2, _trueCurrentHeight - _sub];
        };
        _terrainPoints append _newPoints;
    };
} forEach _pairs;
_terrainPoints
