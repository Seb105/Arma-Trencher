#include "script_component.hpp"
params ["_nodes", "_trenchProperties"];
// POLYGONS = [];
_trenchProperties params [
    "_widthToObj",
    "_widthToEdge",
    "_widthToTransition",
    "_trenchWidth",
    "_objectsWidth",
    "_transitionLength",
    "_numHorizontal",
    "_cellSize",
    "_trueDepth"
];
private _halfCell = _cellSize/2;
private _cornerLength = (SEGMENT_LENGTH * _numHorizontal);
_nodes apply {
    private _mainLines = [];
    private _cornerLines = [];
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
            private _relAngle = 180 - (_a2 - _a1);
            if (_relAngle < 0) then {
                _relAngle = _relAngle + 360;
            };
            if (_relAngle > 360) then {
                _relAngle = _relAngle - 360;
            };
            private _tangent = tan (90 - _relAngle/2);
            private _sub = _widthToObj * _tangent;
            private _angleC = _relAngle;
            private _lengthC = _cornerLength;
            private _angleA = (180 - _relAngle)/2;
            private _lengthA = ((_lengthC/sin _angleC) * sin _angleA);
            private _totalSub = _sub + _lengthA;

    
            private _prevPos = getPosASL _prevNode;
            private _nextPos = getPosASL _nextNode;
            {
                _x set [2, 0]
            } forEach [_prevPos, _nextPos];
            private _start = (_prevPos vectorAdd _nodePos) vectorMultiply 0.5;
            private _end = (_nextPos vectorAdd _nodePos) vectorMultiply 0.5;
            private _distances = [
                (_start distance2d _nodePos) - _totalSub, 
                (_nodePos distance2d _end) - _totalSub
            ];
            _distances params ["_d1", "_d2"];
            // Intersection has overlapped
            if (_d1 min _d2 < 0) then {
                ["Angle between trenches too small, or trench is too short", 1, 5, true, 0] call BIS_fnc_3DENNotification;
                break;
            };

            private _iStart = [_start, _a1, _d1] call FUNC(offset);
            private _iEnd = [_end, _a2+180, _d2] call FUNC(offset);
            private _i1 = [_start, _a1 + 90, _widthToObj] call FUNC(offset);
            private _i2 = [_iStart, _a1 + 90, _widthToObj] call FUNC(offset);
            private _i3 = [_iEnd, _a2 + 90, _widthToObj] call FUNC(offset);
            private _i4 = [_end, _a2 + 90, _widthToObj] call FUNC(offset);
            private _midAngle = _i2 getDir _i3;

            private _turn = _relAngle-180;  
            private _halfTurn = _turn/2;
            private _quarterTurn = _halfTurn/2;
            private _a1Offset = _a1 + 90 - _quarterTurn;
            private _a2Offset = _a2 + 90 + _quarterTurn;
            private _cosFactor = cos _quarterTurn;
            private _sinFactor = sin _quarterTurn;
            private _halfCos = cos _halfTurn;
            private _tanFactor = tan _halfTurn;

            private _objectOffset = _objectsWidth/_cosFactor;
            private _objectInnerLength = _objectOffset*-_sinFactor;
            private _objectsOverlap = 2*_objectInnerLength;
            private _objectIntersection = _cornerLength - _objectsOverlap;
            private ["_o1", "_o2", "_o3", "_o4"];
            if (_relAngle > 180) then {//if (_objectsOverlap < 0) then {
                _o1 = [_i1, _a1 + 90, _objectsWidth] call FUNC(offset);
                _o2 = [_i2, _a1Offset, _objectOffset] call FUNC(offset);
                _o3 = [_i3, _a2Offset, _objectOffset] call FUNC(offset);
                _o4 = [_i4, _a2 + 90, _objectsWidth] call FUNC(offset);
            } else {
                private _centre = (_i2 vectorAdd _i3) vectorMultiply 0.5;
                _o1 = [_i1, _a1 + 90, _objectsWidth] call FUNC(offset);
                // _o2 = [_i2, _midAngle + 90, _objectsWidth/_halfCos] call FUNC(offset);
                // _o3 = [_i3, _midAngle + 90, _objectsWidth/_halfCos] call FUNC(offset);
                _o2 = [_centre, _midAngle + 90, _objectsWidth + (_objectIntersection/2) * _tanFactor] call FUNC(offset);
                _o3 = +_o2;
                _o4 = [_i4, _a2 + 90, _objectsWidth] call FUNC(offset);    
            };

            private _midOffset = _widthToObj/_cosFactor;
            _midStart = [_i2, _a1Offset, -_midOffset] call FUNC(offset);
            _midEnd = [_i3, _a2Offset, -_midOffset] call FUNC(offset);


            private _transition = _objectsWidth + _transitionLength;
            private _transitionOffset = _transition/_cosFactor;
            private _transitionInnerLength = _transitionOffset*-_sinFactor;
            private _transitionOverlap  = 2*_transitionInnerLength;
            private _transitionIntersection = _cornerLength - _transitionOverlap;
            private ["_b1", "_b2", "_b3", "_b4"];
            if (_relAngle > 180) then {//if (_transitionOverlap < 0) then {
                _b1 = [_i1, _a1 + 90, _transition] call FUNC(offset);
                _b2 = [_i2, _a1Offset, _transitionOffset] call FUNC(offset);
                _b3 = [_i3, _a2Offset, _transitionOffset] call FUNC(offset);
                _b4 = [_i4, _a2 + 90, _transition] call FUNC(offset);
            } else {
                private _centre = _i2 vectorAdd _i3 vectorMultiply 0.5;
                _b1 = [_i1, _a1 + 90, _transition] call FUNC(offset);
                // _b2 = [_i2, _midAngle + 90, _transition/_halfCos] call FUNC(offset);
                // _b3 = [_i3, _midAngle + 90, _transition/_halfCos] call FUNC(offset);
                _b2 = [_centre, _midAngle+90, _transition + (_transitionIntersection/2) * _tanFactor] call FUNC(offset);
                _b3 = +_b2;
                _b4 = [_i4, _a2 + 90, _transition] call FUNC(offset);
            };
    
            // Build polygon of this segment by lengthening and offsetting lines slightly. Expand due to fact inPolygon misses points at edge of polygon
            private _p1 = [_start, _a1 - 90, _halfCell] call FUNC(offset);
            private _p2 = [_nodePos, _a1 - 90, _halfCell] call FUNC(offset);
            private _p3 = [_nodePos, _a2 - 90, _halfCell] call FUNC(offset);
            private _p4 = [_end, _a2 - 90, _halfCell] call FUNC(offset);
            private _segmentPoly1 = [
                [_p1, _a1-180, _halfCell] call FUNC(offset),
                // [_i1, _a1-180, _halfCell] call FUNC(offset),
                [_o1, _a1-180, _halfCell] call FUNC(offset),
                [_b1, _a1-180, _halfCell] call FUNC(offset),
                [_b2, _a1, _halfCell] call FUNC(offset),
                [_o2, _a1, _halfCell] call FUNC(offset),
                // [_i2, _a1, _halfCell] call FUNC(offset),
                [_p2, _a1, _halfCell] call FUNC(offset),
                [_p1, _a1-180, _halfCell] call FUNC(offset)
            ];
            private _segmentPoly2 = [
                [_p3, _a2-180, _halfCell] call FUNC(offset),
                // [_i3, _a2-180, _halfCell] call FUNC(offset),
                [_o3, _a2-180, _halfCell] call FUNC(offset),
                [_b3, _a2-180, _halfCell] call FUNC(offset),
                [_b4, _a2, _halfCell] call FUNC(offset),
                [_o4, _a2, _halfCell] call FUNC(offset),
                // [_i4, _a2, _halfCell] call FUNC(offset),
                [_p4, _a2, _halfCell] call FUNC(offset),
                [_p3, _a2-180, _halfCell] call FUNC(offset)
            ];

            _mainLines pushBack [
                [_start, _midStart],
                [_i1, _i2],
                [_o1, _o2],
                [_b1, _b2],
                false,
                _segmentPoly1
            ];
            _cornerLines pushBack [
                [_midStart, _midEnd],
                [_i2, _i3],
                [_o2, _o3],
                [_b2, _b3],
                _a1,
                _a2,
                _relAngle
            ];
            _mainLines pushBack [
                [_midEnd, _end],
                [_i3, _i4],
                [_o3, _o4],
                [_b3, _b4],
                true,
                _segmentPoly2
            ];

            _polygonInner append [_i2, _i3];
            _polygonOuter append [_i2, _o2, _o3, _i3];
            _polygonTransition append [_i2, _o2, _b2, _b3, _o3, _i3];


        } forEach _connections;
    } else {
        private _nextNode = _connections#0;
        private _nextNodePos = getPosASL _nextNode;
        _nextNodePos set [2, 0];
        private _endPos = (_nextNodePos vectorAdd _nodePos) vectorMultiply 0.5;
        {
            _x params ["_n1", "_n2", "_reversed"];
            private _dir = _n1 getDir _n2;
            private _i1 = [_n1, _dir + 90, _widthToObj] call FUNC(offset);
            private _i2 = [_n2, _dir + 90, _widthToObj] call FUNC(offset);
            private _o1 = [_n1, _dir + 90, _widthToEdge] call FUNC(offset);
            private _o2 = [_n2, _dir + 90, _widthToEdge] call FUNC(offset);
            private _b1 = [_n1, _dir + 90, _widthToTransition] call FUNC(offset);
            private _b2 = [_n2, _dir + 90, _widthToTransition] call FUNC(offset);

            private _p1 = [_n1, _dir - 90, _halfCell] call FUNC(offset);
            private _p2 = [_n2, _dir - 90, _halfCell] call FUNC(offset);

            private _ownPolygon =[
                [_p1, _dir-180, _halfCell] call FUNC(offset),
                [_i1, _dir-180, _halfCell] call FUNC(offset),
                [_o1, _dir-180, _halfCell] call FUNC(offset),
                [_b1, _dir-180, _halfCell] call FUNC(offset),
                [_b2, _dir, _halfCell] call FUNC(offset),
                [_o2, _dir, _halfCell] call FUNC(offset),
                [_i2, _dir, _halfCell] call FUNC(offset),
                [_p2, _dir, _halfCell] call FUNC(offset),
                [_p1, _dir-180, _halfCell] call FUNC(offset)
            ];
            _mainLines pushBack [
                [_n1, _n2],
                [_i1, _i2],
                [_o1, _o2],
                [_b1, _b2],
                _reversed,
                _ownPolygon
            ];
        } forEach [
            [_nodePos, _endPos, false],
            [_endPos, _nodePos, true]
        ];
    };
    // Close polygons
    {
        _x pushBack (_x#0);
    } forEach [_polygonOuter, _polygonInner, _polygonTransition];

    // p1 = _polygonInner;
    // p2 = _polygonOuter;
    // p3 = _polygonTransition;

    _node setVariable [QGVAR(mainLines), _mainLines];
    _node setVariable [QGVAR(cornerLines), _cornerLines];
    _node setVariable [QGVAR(polygonInner), _polygonInner];
    _node setVariable [QGVAR(polygonOuter), _polygonOuter];
    _node setVariable [QGVAR(polygonTransition), _polygonTransition];
};
centrelines = [];
innerEdges = [];
outerEdges = [];
transitionEdges = [];
ownPolygons = [];
_nodes apply {
    private _node = _x;
    private _mainLines = _node getVariable QGVAR(mainLines);
    private _cornerLines = _node getVariable QGVAR(cornerLines);
    {  
        centrelines pushBack _x#0;
        innerEdges pushBack _x#1;
        outerEdges pushBack _x#2;
        transitionEdges pushBack _x#3;
        ownPolygons append _x#5;
    } forEach _mainLines;
    {  
        centrelines pushBack _x#0;
        innerEdges pushBack _x#1;
        outerEdges pushBack _x#2;
        transitionEdges pushBack _x#3;
    } forEach _cornerLines;
};
