#include "script_component.hpp"
params ["_allLines", "_pitch", "_trenchWidth"];
_allLines params ["_lines", "_ends"];
private _toPlace = [];
private _distToOtherEdge = _trenchWidth + SEGMENT_WIDTH*1.5;
_lines apply {
    _x params ["_start", "_end"];
    // if (_isSinglePoint) then {continue};
    private _dir = _start getDir _end;
    private _pieceDir = _dir - 90;
    private _trueStart = [_start, _dir, SEGMENT_LENGTH_HALF] call FUNC(offset);
    private _trueEnd = [_end, _dir+180, SEGMENT_LENGTH_HALF] call FUNC(offset);
    private _objCentreStart = [_trueStart, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);
    private _objCentreEnd = [_trueEnd, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);
    // SWEEPS pushBack [_start, _end];
    // Get 3d distance so we can get extra objects on steeps slopes.
    // private _start3D = _start vectorAdd [0,0,getTerrainHeightASL _start];
    // private _end3D = _end vectorAdd [0,0,getTerrainHeightASL _end];
    private _distance = _start distance _end;
    private _isSinglePoint = _distance < SEGMENT_LENGTH;
    private _numSegments = (floor (_distance/SEGMENT_LENGTH)) max 1;
    private _segmentOffset = (_objCentreEnd vectorDiff _objCentreStart) vectorMultiply (1/_numSegments);
    private _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;
    private _inverseHalfSegmentOffset = _halfSegmentOffset vectorMultiply -1;

    // Offsets to the back and front of the trench. This ensures that both sides
    // of the trench are considered when calculating the height of the trench, and
    // that both sides are the same height.
    // private _offsetToBack = [[0,0,0], _dir-90, SEGMENT_WIDTH_HALF] call FUNC(offset);
    private _offsetToOtherSide = [[0,0,0], _dir-90, _distToOtherEdge] call FUNC(offset);
    private _offsetToFront = [[0,0,0], _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);
    if (_isSinglePoint) then {
        _numSegments = 0;
        _objCentreStart = (_objCentreStart vectorAdd _objCentreEnd) vectorMultiply 0.5;
        _segmentOffset = (_objCentreStart vectorFromTo _objCentreEnd) vectorMultiply _distance;
        _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;
    };
    for "_i" from (0) to (_numSegments) do {
        private _objCentre = _objCentreStart vectorAdd (_segmentOffset vectorMultiply _i);
        private _segmentStartPos = _objCentre vectorAdd _inverseHalfSegmentOffset;
        private _segmentEndPos = _objCentre vectorAdd _halfSegmentOffset;
        private _segmentFrontStart = _segmentStartPos vectorAdd _offsetToFront;
        private _segmentFrontEnd = _segmentEndPos vectorAdd _offsetToFront;
        private _segmentBackStart = _segmentStartPos vectorAdd _offsetToOtherSide;
        private _segmentBackEnd = _segmentEndPos vectorAdd _offsetToOtherSide;
        // SWEEPS pushBack [_segmentFrontStart, _segmentFrontEnd];
        private _currentHeight = (getTerrainHeightASL _segmentFrontStart) min (getTerrainHeightASL _segmentBackStart);
        private _nextHeight = (getTerrainHeightASL _segmentFrontEnd) min (getTerrainHeightASL _segmentBackEnd);
        // private _start3d = _segmentStartPos vectorAdd [0,0,_currentHeight];
        // private _end3d = _segmentEndPos vectorAdd [0,0,_nextHeight];
        private _dist = _segmentStartPos distance _segmentEndPos;
        private _fall = _nextHeight - _currentHeight;
        private _pieceRoll = -asin (_fall / _dist min 1 max -1); // Errors if fall is too steep
        private _posASL = _objCentre;
        _posASL set [2, (_currentHeight + _nextHeight)/2 - SEGMENT_SLOPE_BOTTOM];
        private _vectorDirAndUp = [
            [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
            [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
        ];
        _toPlace pushBack [_posASL, _vectorDirAndUp];
    };
};
_toPlace
