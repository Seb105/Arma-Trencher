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
        _node setVariable [QGVAR(connections), _connections];
        _newVisit append _connections;
    } forEach _toVisit;
    _newVisit = _newVisit - _connectedPieces;
    _newVisit = _newVisit arrayIntersect _newVisit; // Remove duplicates
    _connectedPieces append _newVisit;
    _toVisit = _newVisit;
};
_connectedPieces
