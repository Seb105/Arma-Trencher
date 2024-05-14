#include "script_component.hpp"
// Walks over all connected trench pieces and returns them in an array
params ["_origin"];
private _toVisit = get3DENConnections _origin apply {_x#1};
private _connectedPieces = [_origin] + _toVisit;
while {count _toVisit > 0} do {
    private _newVisit = [];
    {
        private _connections = (get3DENConnections _x) apply {_x#1}; 
        _newVisit append _connections;
    } forEach _toVisit;
    _newVisit = _newVisit - _connectedPieces;
    _newVisit = _newVisit arrayIntersect _newVisit; // Remove duplicates
    _connectedPieces append _newVisit;
    _toVisit = _newVisit;
};
[_connectedPieces, [], {count get3DENConnections _x}, "DESCEND"] call BIS_fnc_sortBy;
