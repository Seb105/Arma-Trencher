#include "script_component.hpp"
params ["_nodes", "_trenchWidth", "_widthToEdge", "_numHorizontal", "_cellSize"];
// POLYGONS = [];
private _objectsWidth = SEGMENT_WIDTH * _numHorizontal;
_nodes apply {
    private _lines = [];
    private _ends  = [];
    private _polygonInner = [];
    private _polygonOuter = [];
    private _node = _x;
    private _nodePos = getPosASL _node;
    // systemChat str _node;
    _nodePos set [2, 0];
    // Sorting the connection means that any an angle drawn between two nodes that are next to eachother
    // in this list will not sweep over another branch of the trench coming off this node
    private _connections = [
        _node getVariable QGVAR(connections),
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

        _lines pushBack [_nodePos, _halfWay, false];
        _lines pushBack [_halfWay, _nodePos, true];
    } else {
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
            private _lengthC = SEGMENT_LENGTH * _numHorizontal;
            private _angleA = (180 - _relAngle)/2;
            private _lengthA = ((_lengthC/sin _angleC) * sin _angleA) + 0.1;
            private _totalSub = _sub + _lengthA;
            private _distances = [_start distance2d _nodePos, _nodePos distance2d _end] apply {
                _x - _totalSub
            };
            _distances params ["_d1", "_d2"];
            // Intersection has overlapped
            if (_d1 min _d2 < 0) then {
                ["Angle between trenches too small, or trench is too short", 1, 5, true, 0] call BIS_fnc_3DENNotification;
                continue;
            };


            private _midStart = [_start, _a1, _d1] call FUNC(offset);
            private _midEnd = [_end, _a2+180, _d2] call FUNC(offset);

            private _o1 = [_start, _a1 + 90, _trenchWidth/2] call FUNC(offset);
            private _o2 = [_midStart, _a1 + 90, _trenchWidth/2] call FUNC(offset);
            private _o3 = [_midEnd, _a2 + 90, _trenchWidth/2] call FUNC(offset);
            private _o4 = [_end, _a2 + 90, _trenchWidth/2] call FUNC(offset);
            private _endDir = _o2 getDir _o3;

            private _o1r = [_start, _a1 + 90, _widthToEdge] call FUNC(offset);
            private _o1l = [_start, _a1 - 90, _widthToEdge] call FUNC(offset);
            private _o1z = (getTerrainHeightASL _o1r) min (getTerrainHeightASL _o1l);

            private _o4r = [_end, _a2 + 90, _widthToEdge] call FUNC(offset);
            private _o4l = [_end, _a2 - 90, _widthToEdge] call FUNC(offset);
            private _o4z = (getTerrainHeightASL _o4r) min (getTerrainHeightASL _o4l);

            private _o2r = [_midStart, _a1 + 90, _widthToEdge] call FUNC(offset);
            private _o2l = [_midStart, _a1 - 90, _widthToEdge] call FUNC(offset);
            private _o2z = (getTerrainHeightASL _o2r) min (getTerrainHeightASL _o2l);

            private _o3r = [_midEnd, _a2 + 90, _widthToEdge] call FUNC(offset);
            private _o3l = [_midEnd, _a2 - 90, _widthToEdge] call FUNC(offset);
            private _o3z = (getTerrainHeightASL _o3r) min (getTerrainHeightASL _o3l);

            _o1 set [2, _o1z];
            _o2 set [2, _o2z];
            _o3 set [2, _o3z];
            _o4 set [2, _o4z];

            _lines pushBack [_start, _midStart, false];
            _ends pushBack [_o2, _o3, _relAngle];
            _lines pushBack [_midEnd, _end, true];


            private _offset1 = (1 + abs(sin(2*_a1)) * 0.42) * _cellSize;
            private _lowerWidth1 = (ceil (_trenchWidth/_offset1) * _offset1 + _offset1 - _trenchWidth)/2;
            private _offset2 = (1 + abs(sin(2*_a2)) * 0.42) * _cellSize;
            private _lowerWidth2 = (ceil (_trenchWidth/_offset2) * _offset2 + _offset2 - _trenchWidth)/2;
            private _polygonOffset = (_widthToEdge - _totalSub) max 0;
            private _p1 = [_o2, _endDir+90, _lowerWidth1] call FUNC(offset);
            private _p2 = [_o3, _endDir+90, _lowerWidth2] call FUNC(offset);
            private _inner = [
                _p1,
                _p2
            ];
            _polygonInner append _inner;
        } forEach _connections;
        
        private _polygonCount = count _polygonInner - 1;
        for "_i" from 0 to _polygonCount step 2 do {
            private _first = _polygonInner#_i;
            private _second = _polygonInner#(_i+1);
            private _incomingIndex = _i-1;
            if (_incomingIndex < 0) then {
                _incomingIndex = _polygonCount;
            };
            private _outgoingIndex = _i+2;
            if (_outgoingIndex > _polygonCount) then {
                _outgoingIndex = 0;
            };
            private _incoming = _polygonInner#_incomingIndex;
            private _outgoing = _polygonInner#_outgoingIndex;

            private _d1 = _incoming getDir _first;
            private _d2 = _outgoing getDir _second;

            private _p1 = [_first, _d1, _objectsWidth] call FUNC(offset);
            private _p2 = [_second, _d2, _objectsWidth] call FUNC(offset);
            _polygonOuter append [_p1, _p2];
        };
        // p1 = _polygonInner;
        // p2 = _polygonOuter;
    };

    _node setVariable [QGVAR(polygonInner), _polygonInner];
    _node setVariable [QGVAR(polygonOuter), _polygonOuter];
    _node setVariable [QGVAR(lines), _lines];
    _node setVariable [QGVAR(ends), _ends];
};
