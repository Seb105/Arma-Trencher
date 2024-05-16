#include "script_component.hpp"
params ["_origin"];
([_origin] call FUNC(uniquePairs)) params ["_nodes", "_pairs"];
// Cleanup existing objs 
[_nodes] call FUNC(cleanUpNodes);
if (count _nodes < 2) exitwith {};
private _controllers = _nodes select {_x isKindOf "trencher_main_Module_TrenchController"};
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
private _pitch = _controller getVariable "TrenchPitch"; // SLope of the trench walls
private _minTrenchWidth = (_cellSize/2) * (sqrt 2);
if (_trenchWidth < _minTrenchWidth) then {
    _trenchWidth = _minTrenchWidth;
    private _msg = format ["Terrain cell size is %1. Trench width cannot be less than (cellsize/2) * √2. Defaulting to %2", _cellSize, _trenchWidth];
    [_msg, 0, 5, true, 0] call BIS_fnc_3DENNotification;
};
// Create new objs
private _segmentLength = 7;
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
private _piecesDontPlace =  0 max (floor (_trenchWidth/_segmentLength) - 1);
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
    
    // Extra segments to connnect trenches that are at angles to eachother
    // private _startMaxAngle = _startNode getVariable "maxAngle";
    // private _endMaxAngle = _endNode getVariable "maxAngle";
    // private _extraSegmentsStart = abs round (((_trenchWidth/2) / (tan (_startMaxAngle/2))/_segmentLength));
    // private _extraSegmentsEnd = abs round (((_trenchWidth/2) / (tan (_endMaxAngle/2))/_segmentLength));
    private _extraSegmentsStart = 0;
    private _extraSegmentsEnd = 0;

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
    for "_i" from (_piecesDontPlace) to (_numSegments-_piecesDontPlace) do {
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
        // if (_i >= 0 && _i < _numSegments) then {
        [_centerLine, _segmentEndPos, _terrainPoints, _widthToEdge, _widthToObj, _segmentLength, _dir, _currentHeight, _nextHeight, _trueDepth] call FUNC(getTerrainModPoints);
        // };
    };

    // Area below the trench you can actually walk in
    private _centre = _startPos vectorAdd _endPos vectorMultiply 0.5;
    private _trenchArea = [_centre, _widthToObj/1.2, _dist/2, _dir, true, -1];
    _interSectionAreas pushBack _trenchArea;
    private _objsToHide = [_centre, _dist, _trenchArea] call FUNC(getObjsToHide);
    _hiddenObjects append _objsToHide;
} forEach _pairs;

private _needsCircles = _nodes select {
    count get3DENConnections _x > 1
    //&& _x getVariable "maxAngle" < 90
};
_needsCircles apply {
    private _node = _x;
    private _radius = _trenchWidth/2;
    private _radiusToObj = _radius+_segmentWidth/2;
    private _radiusToEdge = _radius+_segmentWidth;
    private _pos = getPosASL _node;    
    private _modifyArea = [_pos, _radiusToEdge, _radiusToEdge, 0, false];
    private _lowerArea = [_pos, (_radiusToEdge-_cellSize), (_radiusToEdge-_cellSize), 0, false];
    private _trenchArea = [_pos, _radiusToObj/1.01, _radiusToObj/1.01, 0, false, -1];
    _interSectionAreas pushBack _trenchArea;
    private _points = [_modifyArea] call terrainlib_fnc_getAreaTerrainGrid;
    private _minZ = selectMin (_points apply {_x#2});
    //private _minZ = (getTerrainHeightASL _pos);
    _points apply {
        private _sub = [0, _trueDepth] select (_x inArea _lowerArea);
        _x set [2, _minZ - _sub];
    };
    _pos set [2, _minZ];
    _terrainPoints append _points;

    private _objsToHide = [_pos, _radius, _modifyArea] call FUNC(getObjsToHide);
    _hiddenObjects append _objsToHide;
    
    
    private _objCircumference = 2 * pi * _radius;
    private _numObjs = ceil (_objCircumference / _segmentLength);
    private _angleStep = 360 / _numObjs;
    for "_i" from 0 to (_numObjs - 1) do {
        private _angle = _angleStep * _i;
        private _offset = [
            (sin _angle) * _radiusToObj,
            (cos _angle) * _radiusToObj,
            -_segmentSlopeBottom
        ];
        //systemChat str _offset;
        private _posASL = _pos vectorAdd _offset;
        private _pieceDir = _angle - 180;
        private _pieceRoll = 0;
        private _vectorDirAndUp = [
            [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
            [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
        ];
        _toPlace pushBack [_posASL, _vectorDirAndUp];
    };
};
// Handle terrain
private _blendTrenchEnds = _controller getVariable "BlendEnds";
[_origin, _nodes, _terrainPoints, _widthToEdge, _blendTrenchEnds] call FUNC(handleTerrain);
// Handle objects
private _trenchPieces = [_origin, _toPlace, _interSectionAreas, _segmentLength, _hiddenObjects] call FUNC(handleObjects);
// Handle object additions
private _wallType = parseNumber (_controller getVariable "WallType"); // Config values are strings
private _doSandbags = _controller getVariable "DoSandbags";
private _doBarbedWire = _controller getVariable "DoBarbedWire";
private _extraComponents = [_wallType, _doSandbags, _doBarbedWire];
// Copy arr to avoid modififying whilst iterating
(+_trenchPieces) apply {
    [_x, _trenchPieces, _extraComponents] call FUNC(handleObjectAdditions);
};
