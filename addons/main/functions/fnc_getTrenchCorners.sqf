#include "script_component.hpp"
params ["_allLines", "_pitch", "_depth"];
_allLines params ["_lines", "_ends"];

// Because terrain mods are already applied, just use terrain height as was set in previous steps
private _corners = [];
_ends apply {
    _x params ["_start", "_end", "_relAngle"];
    private _startASL = _start vectorAdd [0, 0, getTerrainHeightASL _start];
    private _endASL = _end vectorAdd [0, 0, getTerrainHeightASL _end];
    private _dir = _start getDir _end;
    private _pieceDir = _dir - 90;
    private _edgeCentre = (_startASL vectorAdd _endASL) vectorMultiply 0.5;

    private _objCentre = [_edgeCentre, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);

    private _currentHeight = (getTerrainHeightASL _start);
    private _nextHeight = (getTerrainHeightASL _end);
    private _dist = _start distance2D _end;
    private _fall = _nextHeight - _currentHeight;
    private _pieceRoll = -asin (_fall / _dist min 1 max -1); // Errors if fall is too steep

    _objCentre set [2, (_currentHeight + _nextHeight)/2 + _depth];
    private _vectorDirAndUp = [
        [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
        [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
    ];
    private _long = _relAngle > 190;
    _corners pushBack [_objCentre, _vectorDirAndUp, _long];
};
_corners
