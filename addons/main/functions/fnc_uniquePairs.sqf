#include "script_component.hpp"
// Walks over trench pieces and returns an array of unique pairs of connected trench pieces
params ["_origin"];
private _pairs = [];
private _nodes = [_origin] call FUNC(connectedTrenchPieces);
{
    private _node = _x;
    private _connections = _node getVariable QGVAR(connections);
    {
        private _connection = _x;
        private _pair = [[_node, _connection],[],{str _x}] call BIS_fnc_sortBy; // Can't sort objects so cast to str
        _pairs pushBackUnique _pair;
    } forEach _connections
} forEach _nodes;
[_nodes, _pairs]
