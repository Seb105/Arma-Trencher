#include "script_component.hpp"
params ["_nodes", "_trenchWidth", "_widthToEdge", "_numHorizontal", "_cellSize", "_transitionLength"];
// POLYGONS = [];
private _objectsWidth = SEGMENT_WIDTH * _numHorizontal;
private _halfWidth = _trenchWidth/2;
clearRadio;
_nodes apply {
    private _centrelines = [];
    private _innerEdges = [];
    private _outerEdges = [];
    private _transitionEdge = [];
    private _polygonInner = [];
    private _polygonOuter = [];
    private _polygonTransition = [];
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
    private _nodeProperties = [];
    _nodeProperties resize [_numConnections, [0, 1]];
    if (_numConnections > 1) then {
        {
            private _nextNodeIndex = _forEachIndex + 1;
            if (_nextNodeIndex == _numConnections) then {
                _nextNodeIndex = 0
            };
            private _prevNode = _x;
            private _nextNode = _connections#_nextNodeIndex;
            private _a1 = _prevNode getDir _node;
            private _a2 = _node getDir _nextNode;
            private _relativeAngle = 180 - (_a2 - _a1);
            if (_relativeAngle < 0) then {
                _relativeAngle = _relativeAngle + 360;
            };
            if (_relativeAngle > 360) then {
                _relativeAngle = _relativeAngle - 360;
            };
            private _relAngle = _relativeAngle;
            private _tangent = tan (90 - _relAngle/2);
            private _sub = (_trenchWidth/2)  * _tangent;
            private _angleC = _relAngle;
            private _lengthC = (SEGMENT_LENGTH * _numHorizontal);
            private _angleA = (180 - _relAngle)/2;
            private _lengthA = ((_lengthC/sin _angleC) * sin _angleA) + 0.1;
            private _totalSub = _sub + _lengthA;
            _nodeProperties set [_forEachIndex, [_totalSub, _relativeAngle, _tangent]];
        } forEach _connections;
    
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
            private _start = (_prevPos vectorAdd _nodePos) vectorMultiply 0.5;
            private _end = (_nextPos vectorAdd _nodePos) vectorMultiply 0.5;
            _nodeProperties#_forEachIndex params ["_sub1", "_relAngle", "_tangent"];
            private _halfRelAngle = _relAngle/2;
            private _distances = [
                (_start distance2d _nodePos) - _sub1, 
                (_nodePos distance2d _end) - _sub1
            ];
            _distances params ["_d1", "_d2"];
            // Intersection has overlapped
            if (_d1 min _d2 < 0) then {
                
                ["Angle between trenches too small, or trench is too short", 1, 5, true, 0] call BIS_fnc_3DENNotification;
                continue;
            };


            private _midStart = [_start, _a1, _d1] call FUNC(offset);
            private _midEnd = [_end, _a2+180, _d2] call FUNC(offset);


            _centrelines pushBack [_start, _midStart];
            _centrelines pushBack [_midStart, _midEnd];
            _centrelines pushBack [_midEnd, _end];

            private _i1 = [_start, _a1 + 90, _halfWidth] call FUNC(offset);
            private _i2 = [_midStart, _a1 + 90, _halfWidth] call FUNC(offset);
            private _i3 = [_midEnd, _a2 + 90, _halfWidth] call FUNC(offset);
            private _i4 = [_end, _a2 + 90, _halfWidth] call FUNC(offset);
            private _midAngle = _i2 getDir _i3;

            _innerEdges pushBack [_i1, _i2];
            _innerEdges pushBack [_i2, _i3];
            _innerEdges pushBack [_i3, _i4];

            private _offset1 = (1 + abs(sin(2*_a1)) * 0.42) * _cellSize;
            private _offset2 = (1 + abs(sin(2*_a2)) * 0.42) * _cellSize;
            private _lowerWidth1 = (ceil (_trenchWidth/_offset1) * _offset1 + _offset1)/2;
            private _lowerWidth2 = (ceil (_trenchWidth/_offset2) * _offset2 + _offset2)/2;

            private _turn = _relAngle-180;  
            private _halfTurn = _turn/2;
            private _quarterTurn = _halfTurn/2;
            private _a1Offset = _a1 + 90 - _quarterTurn;
            private _a2Offset = _a2 + 90 + _quarterTurn;
            private _cosFactor = cos _quarterTurn;
            private _sinFactor = sin _quarterTurn;
            private _tanFactor = tan _halfTurn;


            private _objectOffset = _objectsWidth/_cosFactor;
            private _objectInnerLength = _objectOffset*-_sinFactor;
            private _objectsOverlap = (SEGMENT_LENGTH*_numHorizontal) - 2*_objectInnerLength;
            private ["_o1", "_o2", "_o3", "_o4"];
            if (_objectsOverlap > 0) then {
                _o1 = [_i1, _a1 + 90, _objectsWidth] call FUNC(offset);
                _o2 = [_i2, _a1Offset, _objectOffset] call FUNC(offset);
                _o3 = [_i3, _a2Offset, _objectOffset] call FUNC(offset);
                _o4 = [_i4, _a2 + 90, _objectsWidth] call FUNC(offset);
            } else {
                private _centre = (_i2 vectorAdd _i3) vectorMultiply 0.5;
                _o1 = [_i1, _a1 + 90, _objectsWidth] call FUNC(offset);
                _o2 = [_centre, _midAngle + 90, _objectsWidth + (_objectsOverlap/2) * _tanFactor] call FUNC(offset);
                _o3 = +_o2;
                _o4 = [_i4, _a2 + 90, _objectsWidth] call FUNC(offset);
            };
            _outerEdges pushBack [_o1, _o2];
            _outerEdges pushBack [_o2, _o3];
            _outerEdges pushBack [_o3, _o4];



            private _transition = _objectsWidth + _transitionLength;
            private _transitionOffset = _transition/_cosFactor;
            private _transitionInnerLength = _transitionOffset*-_sinFactor;
            private _transitionOverlap  = (SEGMENT_LENGTH*_numHorizontal) - 2*_transitionInnerLength;
            if (_numConnections > 1 && _relAngle < 180) then {
                systemChat str [_transitionOverlap];
            };
            private ["_b1", "_b2", "_b3", "_b4"];
            if (_transitionOverlap > 0) then {
                _b1 = [_i1, _a1 + 90, _transition] call FUNC(offset);
                _b2 = [_i2, _a1Offset, _transitionOffset] call FUNC(offset);
                _b3 = [_i3, _a2Offset, _transitionOffset] call FUNC(offset);
                _b4 = [_i4, _a2 + 90, _transition] call FUNC(offset);

            } else {
                private _centre = _i2 vectorAdd _i3 vectorMultiply 0.5;
                _b1 = [_i1, _a1 + 90, _transition] call FUNC(offset);
                _b2 = [_centre, _midAngle+90, _transition + (_transitionOverlap/2) * _tanFactor] call FUNC(offset);
                _b3 = +_b2;
                _b4 = [_i4, _a2 + 90, _transition] call FUNC(offset);
            };
            _transitionEdge pushBack [_b1, _b2];
            _transitionEdge pushBack [_b2, _b3];
            _transitionEdge pushBack [_b3, _b4];

            _polygonInner append [_i2, _i3];
            _polygonOuter append [_i2, _o2, _o3, _i3];
            _polygonTransition append [_i2, _o2, _b2, _b3, _o3, _i3];
        } forEach _connections;
    } else {
        private _nextNode = _connections#0;
        private _nextNodePos = getPosASL _nextNode;
        _nextNodePos set [2, 0];
        private _endPos = (_nextNodePos vectorAdd _nodePos) vectorMultiply 0.5;
        private _a1 = _node getDir _endPos;
        private _a2 = _endPos getDir _node;
        _centrelines pushBack [_nodePos, _endPos];
        _centrelines pushBack [_endPos, _nodePos];
        {
            _x params ["_offset", "_array"];
            private _r1 = [_nodePos, _a1 + 90, _offset] call FUNC(offset);
            private _r2 = [_endPos, _a1 + 90, _offset] call FUNC(offset);
            _array pushBack [_r1, _r2];

            private _l1 = [_endPos, _a2 + 90, _offset] call FUNC(offset);
            private _l2 = [_nodePos, _a2 + 90, _offset] call FUNC(offset);
            _array pushBack [_l1, _l2];
        } forEach [
            [_halfWidth, _innerEdges],
            [_halfWidth + _objectsWidth, _outerEdges],
            [_halfWidth + _objectsWidth + _transitionLength, _transitionEdge]
        ];
    };
    // Close polygons
    {
        _x pushBack (_x#0);
    } forEach [_polygonOuter, _polygonInner, _polygonTransition];

    centrelines = _centrelines;
    innerEdges = _innerEdges;
    outerEdges = _outerEdges;
    transitionEdge = _transitionEdge;

    p1 = _polygonInner;
    p2 = _polygonOuter;
    p3 = _polygonTransition;

    _node setVariable [QGVAR(centrelines), _centrelines];
    _node setVariable [QGVAR(innerEdges), _innerEdges];
    _node setVariable [QGVAR(outerEdges), _outerEdges];
    _node setVariable [QGVAR(transitionEdge), _transitionEdge];
};
