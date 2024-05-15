#include "script_component.hpp"
// Walks over all connected trench pieces and returns them in an array
params ["_origin"];
private _toVisit = [_origin];
private _connectedPieces = [_origin];
while {count _toVisit > 0} do {
    private _newVisit = [];
    {
        private _node = _x;
        private _connections = (get3DENConnections _node) apply {_x#1}; 
        _newVisit append _connections;
        // Get the minimum angle between the directions of any two connected pieces using cossine rule
        if (count _connections > 1) then {
            private _maxAngle = 10;
            {
                private _nodeB = _x;
                private _sidec = _nodeB distance2D _node;
                {
                    private _nodeC = _x;
                    if (_nodeB isEqualTo _nodeC) then {continue}; // Skip if the same node
                    private _sideb = _nodeC distance2D _node;
                    private _sidea = _nodeC distance2D _nodeB;
                    private _theta = acos ((_sideb^2 + _sidec^2 - _sidea^2) / (2 * _sideb * _sidec));
                    _maxAngle = _maxAngle max _theta;
                } forEach _connections;
            } forEach _connections;
            _node setVariable ["maxAngle", _maxAngle];
        } else {
            _node setVariable ["maxAngle", 180];
        }
    } forEach _toVisit;
    _newVisit = _newVisit - _connectedPieces;
    _newVisit = _newVisit arrayIntersect _newVisit; // Remove duplicates
    _connectedPieces append _newVisit;
    _toVisit = _newVisit;
};
[_connectedPieces, [], {count get3DENConnections _x}, "DESCEND"] call BIS_fnc_sortBy
