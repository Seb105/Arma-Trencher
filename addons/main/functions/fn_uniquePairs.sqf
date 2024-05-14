// Walks over trench pieces and returns an array of unique pairs of connected trench pieces
params ["_origin"];
private _pairs = [];
private _nodes = [_origin] call trencher_main_fnc_connectedTrenchPieces;
{
    private _node = _x;
    private _connections = get3DENConnections _node apply {_x#1};
    _connections = [_connections, [], {count get3DENConnections _x}, "DESCEND"] call BIS_fnc_sortBy;
    {
        private _connection = _x;
        private _pair = [[_node, _connection],[],{str _x}] call BIS_fnc_sortBy; // Can't sort objects so cast to str
        _pairs pushBackUnique _pair;
    } forEach _connections
} forEach _nodes;
[_nodes, _pairs]
