#include "script_component.hpp"
params ["_nodes", "_trenchWidth", "_widthToEdge", "_cellSize", "_trueDepth"];
// private _offset = _cellSize * 1.41421356;
// POINTS = [];
// private _lowerWidth = (_trenchWidth/2) + _offset;
// private _modifyWidth = (_widthToEdge) max (_lowerWidth);
_nodes apply {
    private _startNode = _x;
    private _connections = _startNode getVariable QGVAR(connections);
    private _terrainPoints = [];
    private _startNodePos = getPosASL _startNode;
    private _polygon = _startNode getVariable QGVAR(polygon);
    // private _overlapping = ([_startNodePos, _trenchWidth*2, _trenchWidth*2, 0, false, -1] call TerrainLib_fnc_getAreaTerrainGrid) select {_x inPolygon _polygon};
    private _overlapping = [];
    _startNodePos set [2, 0];
    private _blendEnds = count _connections == 1;
    _connections apply {
        private _endNode = _x;
        private _endNodePos = getPosASL _endNode;
        _endNodePos set [2, 0];
        private _dir = _startNodePos getDir _endNodePos;
        // Offset oscillates between 1 and 1.42 * _cellSize every 45 degrees, to account for the hypotenuse of a terrain grid
        private _offset = (1 + (abs(sin(2*_dir)) * 0.41421356)) * _cellSize;
        private _lowerWidth = (_trenchWidth/2) + _offset;
        private _modifyWidth = (_widthToEdge + _offset) max (_lowerWidth);
        private _vectorDist = _endNodePos vectorDiff _startNodePos;
        private _center = (_startNodePos vectorAdd _endNodePos) vectorMultiply 0.5;
        private _quarter = (_startNodePos vectorAdd (_vectorDist vectorMultiply 0.25));
        private _fromTo = _startNodePos vectorFromTO _center;
        private _length = (_startNodePos distance2D _center) + _offset;
        private _modifyArea = [_quarter, _modifyWidth, _length/2, _dir, true, -1];
        private _lowerArea = [_quarter, _lowerWidth, _length/2, _dir, true, -1];
        private _newPoints = [_modifyArea] call TerrainLib_fnc_getAreaTerrainGrid;

        private _offsetLeft = [[0,0,0], _dir-90, _widthToEdge] call FUNC(offset);
        private _offsetRight = [[0,0,0], _dir+90, _widthToEdge] call FUNC(offset);

        private _blendLength = ((_trueDepth * 4) max (_offset*2)) min (_length*0.75);
        private _selectedPoints = [];
        _newPoints apply {
            private _point = _x;
            private _sub = [0, _trueDepth] select (_point inArea _lowerArea);
            // This extracts the width along the trench of the point, ignoring the length component
            private _dirToStart = (_startNodePos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startNodePos;

            private _xCompontent = _distToCenter * cos _dirToStart;
            private _centreLine = _startNodePos vectorAdd (_fromTo vectorMultiply _xCompontent);
            private _height = selectMin [
                getTerrainHeightASL (_centreLine vectorAdd _offsetLeft),
                getTerrainHeightASL (_centreLine vectorAdd _offsetRight)
            ];
            // private _yComponent = _distToCenter * sin _dirToStart;
            private _newHeight = _height - _sub;
            if (_xCompontent < _blendLength && _blendEnds) then {
                private _currentHeight = _point select 2;
                private _blend = (1 min _xCompontent / _blendLength) max 0;
                _newHeight = _newHeight * _blend + _currentHeight * (1 - _blend);
            };

            _point set [2, _newHeight];
            if (_x inPolygon _polygon) then {
                _overlapping pushBack _point;
            } else {
                _selectedPoints pushBack _point;
            };
        };
        _terrainPoints append _selectedPoints;
    };
    while {count _overlapping > 0} do {
        private _point = _overlapping#0;
        private _matching = _overlapping select {_x#0 isEqualTo _point#0 && {_x#1 isEqualTo _point#1}};
        // systemChat str count _matching;
        _overlapping = _overlapping - _matching;
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
        _terrainPoints pushBack _point;
    };
    _startNode setVariable [QGVAR(terrainPoints), _terrainPoints];
};
