params ["_origin"];
([_origin] call trencher_main_fnc_uniquePairs) params ["_nodes", "_pairs"];
// Cleanup existing objs 
[_nodes] call trencher_main_fnc_cleanUpNodes;
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
private _msg = format ["Terrain cell size is %1. Trench width cannot be less than (cellsize/2) * âˆš2. Defaulting to %2", _cellSize, _trenchWidth];
[_msg, 1, 5, true, 0] call BIS_fnc_3DENNotification;
_controller setVariable ["TrenchWidth", _trenchWidth];
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
// private _piecesDontPlace =  0 max (floor (_widthToObj/_segmentLength) - 1);
{
_x params ["_startNode", "_endNode"];
private _startPos = getPosASL _startNode;
private _endPos = getPosASL _endNode;
_startPos set [2, 0];
_endPos set  [2, 0];
private _vectorDir = _startPos vectorFromTo _endPos;
if (count get3DENConnections _endNode > 1) then {
    _endPos = _endPos vectorAdd (_vectorDir vectorMultiply -(_widthToObj/2));
};
if (count get3DENConnections _startNode > 1) then {
    _startPos = _startPos vectorAdd (_vectorDir vectorMultiply (_widthToObj/2));
};

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
for "_i" from (0) to (_numSegments) do {
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
    [_centerLine, _segmentEndPos, _terrainPoints, _widthToEdge, _widthToObj, _segmentLength, _dir, _currentHeight, _nextHeight, _trueDepth] call trencher_main_fnc_getTerrainModPoints;
};

// Area below the trench you can actually walk in
private _centre = _startPos vectorAdd _endPos vectorMultiply 0.5;
private _trenchArea = [_centre, _widthToObj/1.1, _dist/2, _dir, true, -1];
_interSectionAreas pushBack _trenchArea;
private _objsToHide = [_centre, _dist, _trenchArea] call trencher_main_fnc_getObjsToHide;
_hiddenObjects append _objsToHide;
} forEach _pairs;

private _needsConnecting = _nodes select {
    count get3DENConnections _x > 1
};
_needsConnecting apply {
    private _node = _x;
    private _nodePos = getPosASL _node;
    _nodePos set [2,0];
    // Sorting the connection means that any an angle drawn between two nodes that are next to eachother
    // In this list will not sweep over another branch of the trench coming off this node
    private _connections = [
        (get3DENConnections _x) apply {_x#1}, 
        [_node], 
        {_input0 getDir _x},
        "DESCEND"
    ] call BIS_fnc_sortBy;

    // Terrain stuff
    private _search = _widthToEdge;
    private _modifyArea = [_nodePos, _search, _search, 0, false];
    private _trenchArea = [_nodePos, _trenchWidth, _trenchWidth, 0, false, -1];
    _interSectionAreas pushBack _trenchArea;
    private _points = [_modifyArea] call terrainlib_fnc_getAreaTerrainGrid;
    private _minZ = selectMin (_points apply {_x#2});
    //private _minZ = (getTerrainHeightASL _pos);
    _points apply {
        _x set [2, _minZ - _trueDepth];
    };
    _terrainPoints append _points;
    private _objsToHide = [_nodePos, _trenchWidth, _modifyArea] call trencher_main_fnc_getObjsToHide;
    _hiddenObjects append _objsToHide;    

    // Iterate over connections and build walls around the _interseciton
    private _numConnections = count _connections;    
    {
        private _nextNodeIndex = _forEachIndex + 1;
        if (_nextNodeIndex == _numConnections) then {_nextNodeIndex = 0};
        private _nextNode = _connections#_nextNodeIndex;
        private _prevNode = _x;
        private _prevPos = getPosASL _prevNode;
        private _nextPos = getPosASL _nextNode;
        {_x set [2,0]} forEach [_prevPos, _nextPos]; 

        private _a1 = _prevNode getDir _node;
        private _a2 = _node getDir _nextNode;
        // Angle between the two nodes, offset to always be 0-360
        private _relAngle = 180-(_a2 - _a1);
        if (_relAngle < 0) then {
            _relAngle = _relAngle + 360;
        };
        if (_relAngle > 360) then {
            _relAngle = _relAngle - 360;
        };
        //private _offsetDist = _widthToObj;///(sin (_relAngle/2));
        //private _tangentNormal = (_a1 - _relAngle/2);
        //systemChat str [_a1, _a2, _relAngle, _tangentNormal];
        //private _tangent = _nodePos vectorAdd [
            //-sin _tangentNormal * _widthToObj,
            //-cos _tangentNormal * _widthToObj,
            //0
        //];
        // Step along length of trench to the point the straights stop being generated
        private _v1 = _nodePos vectorFromTo _prevPos;
        private _v2 = _nodePos vectorFromTo _nextPos;
        private _offsetDist = _widthToEdge/2;
        //private _widthToIntersect = _widthToEdge - (_segmentWidth*1.5 * (cos (_relAngle/2)));
        private _widthToIntersect = _widthToObj / (sin (_relAngle/2));
        private _s1 = _nodePos vectorAdd (_v1 vectorMultiply _offsetDist);
        private _s2 = _nodePos vectorAdd (_v2 vectorMultiply _offsetDist);
        //SWEEPS pushback [_s1, _s2];
        // Turn 90 degrees and step out. The path _o1 -> _o2 connects the trench ends.
        private _r1 = _a1 + 90;
        private _r2 = _a2 + 90;
        private _o1 = _s1 vectorAdd [
            sin _r1 * _widthToIntersect,
            cos _r1 * _widthToIntersect,
            0 
        ];
        private _o2 = _s2 vectorAdd [
            sin _r2 * _widthToIntersect,
            cos _r2 * _widthToIntersect,
            0
        ];
        // Path from _o1 -> _o2 is the trench wall. Path from _s1 -> _s2 the trench floor
        // Path direction is tangent to the angle of the turn
        // If  _d1 does not equal _d2, (minus float errors) then _o1 -> _o2 has become negative.
        private _d1 = _s1 getDir _s2;
        private _d2 = _o1 getDir _o2;
        //systemChat str [_d1, _d2];
        private _distance = _o1 distance2D _o2;
        private _pieceDir = _d2 - 90;
        if (abs (_d1 - _d2) > 5) then {
            _pieceDir = _pieceDir + 180; 
        };       
        private _start = _o1;
        private _end = _o2;
        // _widthToIntersect approaches infinity as the relative angle approaches 360. Clamp it.
        private _chordLength = _widthToObj + 2 * _segmentLength;
        if (_distance > _chordLength) then {
            private _over = (_distance - _chordLength)/2 + _segmentLength;
            private _vectorDir = _start vectorFromTo _end;
            _start = _o1 vectorAdd (_vectorDir vectorMultiply _over);
            _end = _o2 vectorAdd (_vectorDir vectorMultiply -_over);
            _distance = _chordLength;
        };
        private _numSegments = ceil (_distance/_segmentLength);
        if (_numSegments < 1) then {continue};
        private _segmentOffset = (_end vectorDiff _start) vectorMultiply (1/_numSegments);
        private _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;
        private _halfWidth = _segmentWidth/2;
        private _cosDir = cos _pieceDir;
        private _sinDir = sin _pieceDir;
        private _offsetEdge1 = [
            _sinDir * (_widthToEdge + _halfWidth), 
            _cosDir * (_widthToEdge + _halfWidth), 
            0
        ];
        private _offsetEdge2 = [
            -_sinDir * -_halfWidth, 
            -_cosDir * _halfWidth, 
            0
        ];
        _start = _start vectorAdd _segmentOffset;
        for "_i" from (0) to (_numSegments-2) do {
            private _centerLine = _start vectorAdd (_segmentOffset vectorMultiply _i);
            private _segmentStartPos = _centerLine vectorAdd (_halfSegmentOffset vectorMultiply -1);
            private _segmentEndPos = _centerLine vectorAdd _halfSegmentOffset;
            private _currentHeight = selectMin ([_offsetEdge1, _offsetEdge2] apply {
                //POINTS pushBack (_segmentStartPos vectorAdd _x);
                getTerrainHeightASL (_segmentStartPos vectorAdd _x)
            });
            private _nextHeight = selectMin ([_offsetEdge1, _offsetEdge2] apply {
                getTerrainHeightASL (_segmentEndPos vectorAdd _x)
            });
            private _fall = _nextHeight - _currentHeight;
            private _pieceRoll = -asin ((_fall / (_segmentLength)) min 1); // Errors if fall is too steep
            private _posASL = _centerLine;
            _posASL set [2, (_currentHeight + _nextHeight)/2 - _segmentSlopeBottom];
            private _vectorDirAndUp = [
                [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
                [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
            ];
            _toPlace pushBack [_posASL, _vectorDirAndUp];
            //break;
        };
        //break;
    } forEach _connections;
    //break;

};
// Handle terrain
private _blendTrenchEnds = _controller getVariable "BlendEnds";
[_origin, _nodes, _terrainPoints, _widthToEdge, _blendTrenchEnds] call trencher_main_fnc_handleTerrain;
// Handle objects
private _trenchPieces = [_origin, _toPlace, _interSectionAreas, _segmentLength, _hiddenObjects] call trencher_main_fnc_handleObjects;
// Handle object additions
private _wallType = parseNumber (_controller getVariable "WallType"); // Config values are strings
private _doSandbags = _controller getVariable "DoSandbags";
private _doBarbedWire = _controller getVariable "DoBarbedWire";
private _extraComponents = [_wallType, _doSandbags, _doBarbedWire];
// Copy arr to avoid modififying whilst iterating
(+_trenchPieces) apply {
[_x, _trenchPieces, _extraComponents] call trencher_main_fnc_handleObjectAdditions;
};
