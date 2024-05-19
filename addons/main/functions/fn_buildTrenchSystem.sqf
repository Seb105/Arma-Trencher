params ["_origin"];
([_origin] call trencher_main_fnc_uniquePairs) params ["_nodes", "_pairs"];
// Cleanup existing objs 
[_nodes] call trencher_main_fnc_cleanUpNodes;
if (count _nodes < 2) exitWith {};
private _controllers = _nodes select {
    _x isKindOf "trencher_main_Module_TrenchController"
};
if (count _controllers > 1) exitWith {
    ["A trench can only have 1 controller module synced", 1, 5, true, 0.2] call BIS_fnc_3DENNotification
};
if (count _controllers == 0) exitWith {
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
// Create new objs+
private _segmentLength = 8; // Used for long sections
private _segmentWidth = 9; // Width of bounding box
private _segmentSlopeBottom = 2.2;
private _segmentSlopeTop = 2.7;
private _segmentSlopeFall = _segmentSlopeTop - _segmentSlopeBottom;
private _widthToObj = (_segmentWidth + _trenchWidth)/2;
private _widthToEdge = _trenchWidth/2 + _segmentWidth;
private _trueDepth = 0 max (_depth - _segmentSlopeFall);
// private _objDepth = _depth + _segmentSlopeTop;
private _lines = [];
private _toPlace = [];
private _needsConnecting = _nodes select {
    true // count get3DENConnections _x > 1
};
SWEEPS = [];
POINTS = [];
clearRadio;
private _fnc_Offset = {
    params ["_pos", "_dir", "_offset"];
    _pos vectorAdd [
        sin _dir * _offset,
        cos _dir * _offset,
        0
    ]
};
_needsConnecting apply {
    private _node = _x;
    private _nodePos = getPosASL _node;
    // systemChat str _node;
    _nodePos set [2, 0];
    // Sorting the connection means that any an angle drawn between two nodes that are next to eachother
    // in this list will not sweep over another branch of the trench coming off this node
    private _connections = [
        (get3DENConnections _x) apply {
            _x#1
        },
        [_node],
        {
            _input0 getDir _x
        },
        "DESCEND"
    ] call BIS_fnc_sortBy;
    private _numConnections = count _connections;
    if (_numConnections < 2) then {
        private _connection = _connections#0;
        private _connectionPos = getPosASL _connection;
        // systemChat str _connectionPos;
        _connectionPos set [2, 0];
        private _dir = _nodePos getDir _connectionPos;
        private _halfWay = (_nodePos vectorAdd _connectionPos) vectorMultiply 0.5;
        private _r1 = [_nodePos, _dir + 90, _trenchWidth/2] call _fnc_Offset;
        private _r2 = [_halfWay, _dir + 90, _trenchWidth/2] call _fnc_Offset;
        private _l1 = [_nodePos, _dir - 90, _trenchWidth/2] call _fnc_Offset;
        private _l2 = [_halfWay, _dir - 90, _trenchWidth/2] call _fnc_Offset;
        _lines pushBack [_r1, _r2];
        _lines pushBack [_l2, _l1];
        continue;
    };
    {
        private _nextNodeIndex = _forEachIndex + 1;
        if (_nextNodeIndex == _numConnections) then {
            _nextNodeIndex = 0
        };
        private _nextNode = _connections#_nextNodeIndex;
        private _prevNode = _x;
        private _prevPos = getPosASL _prevNode;
        private _nextPos = getPosASL _nextNode;
        {
            _x set [2, 0]
        } forEach [_prevPos, _nextPos];

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
        private _start = (_prevPos vectorAdd _nodePos) vectorMultiply 0.5;
        private _end = (_nextPos vectorAdd _nodePos) vectorMultiply 0.5;
        private _tangent = tan (90 - _relAngle/2);
        private _sub = (_trenchWidth/2)  * _tangent;
        private _angleC = _relAngle;
        private _lengthC = _segmentLength;
        private _angleA = (180 - _relAngle)/2;
        private _lengthA = ((_lengthC/sin _angleC) * sin _angleA) + 0.1;
        private _distances = [_start distance2d _nodePos, _nodePos distance2d _end] apply {
            _x - _sub - _lengthA
        };
        _distances params ["_d1", "_d2"];
        // Intersection has overlapped
        if (_d1 min _d2 < 0) then {-
            continue;
        };
        private _o1 = [_start, _a1 + 90, _trenchWidth/2] call _fnc_Offset;
        private _o4 = [_end, _a2 + 90, _trenchWidth/2] call _fnc_Offset;
        private _o2 = [_o1, _a1, _d1] call _fnc_Offset;
        private _o3 = [_o4, _a2+180, _d2] call _fnc_Offset;
        // Append lines to be drawn
        _lines pushBack [_o1, _o2, false];
        _lines pushBack [_o2, _o3, true];
        _lines pushBack [_o3, _o4, false];
    } forEach _connections;
};

_lines apply {
    _x params ["_start", "_end", "_isSinglePoint"];
    // if (_isSinglePoint) then {continue};
    private _dir = _start getDir _end;
    private _pieceDir = _dir - 90;
    private _trueStart = [_start, _dir, _segmentLength/2] call _fnc_Offset;
    private _trueEnd = [_end, _dir+180, _segmentLength/2] call _fnc_Offset;
    private _objCentreStart = [_trueStart, _dir+90, _segmentWidth/2] call _fnc_Offset;
    private _objCentreEnd = [_trueEnd, _dir+90, _segmentWidth/2] call _fnc_Offset;
    // SWEEPS pushBack [_start, _end];
    // Get 3d distance so we can get extra objects on steeps slopes.
    private _start3D = _start vectorAdd [0,0,getTerrainHeightASL _start];
    private _end3D = _end vectorAdd [0,0,getTerrainHeightASL _end];
    private _distance = _start3D distance _end3D;
    // private _isSinglePoint = (_start distance2d _end) < (_trueSegmentLength);
    private _numSegments = (floor (_distance/_segmentLength)) max 1;
    private _segmentOffset = (_objCentreEnd vectorDiff _objCentreStart) vectorMultiply (1/_numSegments);
    private _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;

    // Offsets to the back and front of the trench. This ensures that both sides
    // of the trench are considered when calculating the height of the trench, and
    // that both sides are the same height.
    // private _offsetToBack = [[0,0,0], _dir-90, _segmentWidth/2] call _fnc_Offset;
    private _offsetToOtherSide = [[0,0,0], _dir-90, _trenchWidth + _segmentWidth*1.5] call _fnc_Offset;
    private _offsetToFront = [[0,0,0], _dir+90, _segmentWidth/2] call _fnc_Offset;
    if (_isSinglePoint) then {
        _numSegments = 0;
        _objCentreStart = (_objCentreStart vectorAdd _objCentreEnd) vectorMultiply 0.5;
        _segmentOffset = (_objCentreStart vectorFromTo _objCentreEnd) vectorMultiply _distance;
        _halfSegmentOffset = _segmentOffset vectorMultiply 0.5;
    };
    for "_i" from (0) to (_numSegments) do {
        private _objCentre = _objCentreStart vectorAdd (_segmentOffset vectorMultiply _i);
        private _segmentStartPos = _objCentre vectorAdd (_halfSegmentOffset vectorMultiply -1);
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
        private _dist = _segmentStartPos distance2d _segmentEndPos;
        private _fall = _nextHeight - _currentHeight;
        private _pieceRoll = -asin (_fall / _dist min 1 max -1); // Errors if fall is too steep
        private _posASL = _objCentre;
        _posASL set [2, (_currentHeight + _nextHeight)/2 - _segmentSlopeBottom];
        private _vectorDirAndUp = [
            [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
            [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
        ];
        _toPlace pushBack [_posASL, _vectorDirAndUp];
    };
};

// Handle terrain
_terrainPoints = [];
{
    _x params ["_startNode", "_endNode"];
    private _startNodePos = getPosASL _startNode;
    private _endNodePos = getPosASL _endNode;
    _startNodePos set [2, 0];
    _endNodePos set [2, 0];
    private _distance = _startNodePos distance2D _endNodePos;
    private _dir = _startNodePos getDir _endNodePos;
    private _offsetToBack = [[0,0,0], _dir-90, _widthToEdge] call _fnc_Offset;
    private _offsetToFront = [[0,0,0], _dir+90, _widthToEdge] call _fnc_Offset;
    private _numSteps = ceil (_distance/_segmentLength);
    private _step = (_endNodePos vectorDiff _startNodePos) vectorMultiply (1/_numSteps);
    private _halfStep = _step vectorMultiply 0.5;
    private _start = _startNodePos vectorAdd (_step vectorMultiply 0.5);
    for "_i" from (0) to (_numSteps-1) do {
        private _segmentCentre = _start vectorAdd (_step vectorMultiply _i);
        private _segmentStart = _segmentCentre vectorAdd (_halfStep vectorMultiply -1);
        private _segmentEnd = _segmentCentre vectorAdd _halfStep;
        private _currentHeight = selectMin ([_offsetToBack, _offsetToFront] apply {
            // POINTS pushBack (_segmentStart vectorAdd _x);
            getTerrainHeightASL (_segmentStart vectorAdd _x)
        });
        private _nextHeight = selectMin ([_offsetToBack, _offsetToFront] apply {
            getTerrainHeightASL (_segmentEnd vectorAdd _x)
        });
        private _modifyArea = [_segmentCentre, _widthToEdge-2, _segmentLength, _dir, true, -1];
        private _lowerArea = [_segmentCentre, (_widthToEdge-_cellSize) max _widthToObj, _segmentLength, _dir, true, -1];
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
    };
} forEach _pairs;
// POINTS = _terrainPoints;
// Handle terrain
private _blendTrenchEnds = _controller getVariable "BlendEnds";
[_origin, _nodes, _terrainPoints, _widthToEdge, _blendTrenchEnds] call trencher_main_fnc_handleTerrain;


// systemChat str _toPlace;
private _trenchPieces = [_origin, _toPlace, [], _segmentLength, []] call trencher_main_fnc_handleObjects;
private _wallType = parseNumber (_controller getVariable "WallType"); // Config values are strings
private _doSandbags = _controller getVariable "DoSandbags";
private _doBarbedWire = _controller getVariable "DoBarbedWire";
private _tankTrapType = parseNumber (_controller getVariable "TankTrapType");
private _additionalHorizComponents = _controller getVariable "AdditionalHorizSegments";
private _extraComponents = [_wallType, _doSandbags, _doBarbedWire, _tankTrapType,_additionalHorizComponents];
(+_trenchPieces) apply {
    [_x, _trenchPieces, _extraComponents] call trencher_main_fnc_handleObjectAdditions;
};	
