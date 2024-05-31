#include "script_component.hpp"
params ["_controller", "_nodes", "_terrainPoints", "_widthToEdge", "_blendTrenchEnds", "_depth", "_cellSize"];
// Iterate through and remove duplicatge [x,y] points, keeping the average Z
private _terrainPointsFiltered = [];
while {count _terrainPoints > 0} do {
    private _point = _terrainPoints#0;
    private _matching = _terrainPoints select {_x#0 isEqualTo _point#0 && {_x#1 isEqualTo _point#1}};
    _terrainPoints = _terrainPoints - _matching;
    private _matchingCount = count _matching;
    if (_matchingCount > 1) then {
        // private _matchingZ = 0;
        // {
        //     _matchingZ = _x#2 + _matchingZ;
        // } forEach _matching;
        // _matchingZ = _matchingZ / _matchingCount;
        private _matchingZ = selectMin (_matching apply {_x#2});
        _point set [2, _matchingZ];
    };
    _terrainPointsFiltered pushBack _point;
};
// Subtract the depth of trench
// Restore end piece to blend transition
if (_blendTrenchEnds) then {
    private _endPieces = _nodes select {count get3DENConnections _x <= 1};
    {
        private _node = _x;
        private _connection = ((get3DENConnections _node)#0)#1;
        private _nodePos = getPosASL _node;
        private _connectionPos = getPosASL _connection;
        _nodePos set [2, 0];
        _connectionPos set [2, 0];
        private _distance = _nodePos distance2d _connectionPos;
        private _dir = _node getDir _connection;
        private _vectorDir = _nodePos vectorFromTo _connectionPos;
        private _blendLength = (_depth*4) min (_distance/2);
        private _centre = _nodePos vectorAdd (_vectorDir vectorMultiply _blendLength/2);
        private _blendEnd = _nodePos vectorAdd (_vectorDir vectorMultiply _blendLength);
        private _area = [_centre, [_widthToEdge*2,_blendLength/2+_cellSize*2, _dir, true]];
        private _points = [_area] call TerrainLib_fnc_getAreaTerrainGrid;
        _points apply {
            private _point = _x;
            private _coord = _point select [0,2];
            private _index = _terrainPointsFiltered findIf {_coord isEqualTo (_x select [0,2])};
            if (_index isEqualTo -1) then {
                continue;
            };
            private _newPoint = _terrainPointsFiltered#_index;
            private _newZ = _newPoint#2;
            private _currentZ = _point#2;
            private _magDist = _x distance2D _blendEnd;
            private _angleTo = _x getDir _blendEnd;
            private _distToStart = _magDist * cos (_angleTo - _dir);
            private _weight = _distToStart / _blendLength;
            _weight = _weight min 1 max 0;
            private _blendedZ = _currentZ * _weight + _newZ * (1-_weight);
            _newPoint set [2, _blendedZ];
        };
        // _restoredPoints append _restored;
    } forEach _endPieces;
};
[_terrainPointsFiltered, true, true] call TerrainLib_fnc_setTerrainHeight;
_terrainPointsFiltered
