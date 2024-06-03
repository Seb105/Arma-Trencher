#include "script_component.hpp"
params ["_nodes", "_trenchWidth"];
private _lines = [];
private _ends  = [];
_nodes apply {
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
        private _r1 = [_nodePos, _dir + 90, _trenchWidth/2] call FUNC(offset);
        private _r2 = [_halfWay, _dir + 90, _trenchWidth/2] call FUNC(offset);
        private _l1 = [_nodePos, _dir - 90, _trenchWidth/2] call FUNC(offset);
        private _l2 = [_halfWay, _dir - 90, _trenchWidth/2] call FUNC(offset);
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
        private _lengthC = SEGMENT_LENGTH;
        private _angleA = (180 - _relAngle)/2;
        private _lengthA = ((_lengthC/sin _angleC) * sin _angleA) + 0.1;
        private _distances = [_start distance2d _nodePos, _nodePos distance2d _end] apply {
            _x - _sub - _lengthA
        };
        _distances params ["_d1", "_d2"];
        // Intersection has overlapped
        if (_d1 min _d2 < 0) then {
            continue;
        };
        private _o1 = [_start, _a1 + 90, _trenchWidth/2] call FUNC(offset);
        private _o4 = [_end, _a2 + 90, _trenchWidth/2] call FUNC(offset);
        private _o2 = [_o1, _a1, _d1] call FUNC(offset);
        private _o3 = [_o4, _a2+180, _d2] call FUNC(offset);
        // Append lines to be drawn
        _lines pushBack [_o1, _o2];
        _ends pushBack [_o2, _o3, _relAngle];
        _lines pushBack [_o3, _o4];
    } forEach _connections;
};
[_lines, _ends]
