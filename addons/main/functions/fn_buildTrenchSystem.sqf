params ["_origin"];
([_origin] call trencher_main_fnc_uniquePairs) params ["_nodes", "_pairs"];
// Cleanup existing objs 
[_nodes] call trencher_main_fnc_cleanUpNodes;
if (count _nodes < 2) exitwith {};
_controllers = _nodes select {_x isKindOf "trencher_main_Module_TrenchController"};
if (count _controllers > 1) exitwith {
    ["A trench can only have 1 controller module synced", 1, 5, true, 0.2] call BIS_fnc_3DENNotification
};
if (count _controllers == 0) exitwith {
    ["A trench must have a controller module synced", 1, 5, true, 0] call BIS_fnc_3DENNotification
};
private _cellSize = (getTerrainInfo)#2;
private _controller = _controllers#0;
private _depth = _controller getVariable "TrenchDepth";
private _trenchWidth = _controller getVariable "TrenchWidth";
private _minTrenchWidth = (_cellSize/2) * (sqrt 2);
if (_trenchWidth < _minTrenchWidth) then {
    _trenchWidth = _minTrenchWidth;
    private _msg = format ["Terrain cell size is %1. Trench width cannot be less than (cellsize/2) * √2. Defaulting to %2", _cellSize, _trenchWidth];
    [_msg, 0, 5, true, 0] call BIS_fnc_3DENNotification;
};
// Create new objs
private _segmentLength = 6;
private _segmentWidth = 9; // Width of bounding box
private _segmentSlopeBottom = 2.2;
private _segmentSlopeTop = 2.6;
private _segmentSlopeFall = _segmentSlopeTop - _segmentSlopeBottom;
private _widthToObj = (_segmentWidth + _trenchWidth)/2;
private _widthToEdge = _trenchWidth/3 + _segmentWidth;
private _trueDepth = 0 max (_depth - _segmentSlopeFall);
private _toPlace = [];
private _interSectionAreas = [];
private _hiddenObjects = [];
private _terrainPoints = [];
// Build list of objects to place
{
    _x params ["_startNode", "_endNode"];
    private _startPos = getPosASL _startNode;
    private _endPos = getPosASL _endNode;
    _startPos set [2, 0];
    _endPos set  [2, 0];
    private _dir = _startPos getDir _endPos;
    private _cosDir = cos _dir;
    private _sinDir = sin _dir;
    private _dist = _startPos distance2D _endPos;
    private _numSegments = ceil (_dist / _segmentLength);
    private _extraSegments = ceil (_widthToObj / 1.42 / _segmentLength); // So we cover the ends
    private _segmentOffset = (_endPos vectorDiff _startPos) vectorMultiply (1 / _numSegments);
    private _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;
    // Offset to the centre of the object forming trench wall, multiplier for rolls, 
    private _offsetLeft = [
        [
            _cosDir * _widthToObj, 
            _sinDir * -_widthToObj, 
            0
        ],
        1
    ];
    private _offsetRight = [
        [
            _cosDir * -_widthToObj, 
            _sinDir * _widthToObj, 
            0
        ],
        -1
    ];
    // Offsets to the edge of the trench wall
    private _offsetLeftEdge = [
        _cosDir * _widthToEdge, 
        _sinDir * -_widthToEdge, 
        0
    ];
    private _offsetRightEdge = [
        _cosDir * -_widthToEdge, 
        _sinDir * _widthToEdge, 
        0
    ];
    for "_i" from (-_extraSegments) to (_numSegments+_extraSegments) do {
        private _centerLine = _startPos vectorAdd (_segmentOffset vectorMultiply _i);
        private _segmentStartPos = _centerLine vectorAdd (_halfSegmentOffset vectorMultiply -1);
        private _segmentEndPos = _centerLine vectorAdd _halfSegmentOffset;
        private _currentHeight = selectMin ([_offsetLeftEdge, _offsetRightEdge] apply {
            getTerrainHeightASL (_segmentStartPos vectorAdd _x)
        });
        private _nextHeight = selectMin ([_offsetLeftEdge, _offsetRightEdge] apply {
            getTerrainHeightASL (_segmentEndPos vectorAdd _x)
        });
        private _fall = _nextHeight - _currentHeight;
        private _roll = asin ((_fall / (_segmentLength)) min 1); // Errors if fall is too steep
        private _pitch = 0;
        {
            _x params ["_offset", "_multiplier"];
            private _pieceDir = _dir - 90 * _multiplier;
            private _posASL = _centerLine vectorAdd _offset;
            // private _fall = (getTerrainHeightASL (_posASL vectorAdd _toEnd)) - (getTerrainHeightASL (_posASL vectorAdd _toStart));
            // private _roll = asin ((_fall / (_segmentLength)) min 1);
            _posASL set [2, (_currentHeight + _nextHeight)/2 - _segmentSlopeBottom];
            private _pieceRoll = _roll * -_multiplier;
            // The gradient of the segment pieces is actually 90 degrees to the direction of the trench, so we need to rotate it.
            private _vectorDirAndUp = [
                [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
                [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
            ];
            _toPlace pushBack [_posASL, _vectorDirAndUp];
        } forEach [_offsetLeft, _offsetRight];

        // Terrain modification areas
        if (_i >= 0 && _i < _numSegments) then {
            [_centerLine, _segmentEndPos, _terrainPoints, _widthToEdge, _widthToObj, _segmentLength, _dir, _currentHeight, _nextHeight, _trueDepth] call trencher_main_fnc_getTerrainModPoints;
        };
    };

    [_startPos, _endPos, _widthToObj, _dist, _dir, _interSectionAreas, _hiddenObjects] call trencher_main_fnc_getObjsToHide;
} forEach _pairs;

// Handle terrain
[_origin, _nodes, _terrainPoints, _widthToEdge] call trencher_main_fnc_handleTerrain;
// Handle objects
[_origin, _toPlace, _interSectionAreas, _segmentLength, _hiddenObjects] call trencher_main_fnc_handleObjects;
