#include "script_component.hpp"
// Walks over all connected trench pieces and returns them in an array
params ["_origin"];
private _toVisit = [_origin];
private _connectedPieces = [_origin];
private _allSkippers = (all3DENEntities#3) select {
    _x isKindOf QGVAR(Module_TrenchSkipper)
};
while {count _toVisit > 0} do {
    private _newVisit = [];
    {
        private _node = _x;
        private _connections = ((get3DENConnections _node) apply {_x#1}) select {_x isKindOf QGVAR(Module_TrenchPiece)};
        private _nodeRadius = 0;
        private _connectedSkippers = [];
        if (count _connections > 0) then {
            _nodeRadius = selectMax (_connections apply {
                _node distance2d _x
            })/2;
            _connectedSkippers = _allSkippers select {
                private _distance = _node distance2d _x;
                private _skipperRadius = _x getVariable QGVAR(radius);
                // systemChat str [_nodeRadius, _distance, _skipperRadius];
                _distance < (_skipperRadius + _nodeRadius)
            };
        };
        _node setVariable [QGVAR(radius), _nodeRadius];
        _node setVariable [QGVAR(skippers), _connectedSkippers];
        _node setVariable [QGVAR(connections), _connections];
        _newVisit append _connections;
    } forEach _toVisit;
    _newVisit = _newVisit - _connectedPieces;
    _newVisit = _newVisit arrayIntersect _newVisit; // Remove duplicates
    _connectedPieces append _newVisit;
    _toVisit = _newVisit;
};
_connectedPieces
