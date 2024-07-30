#include "script_component.hpp"
params ["_nodes", "_trenchWidth", "_widthToEdge", "_transitionLength", "_cellSize", "_trueDepth", "_blendTrenchEnds"];
LINES1 = [];
LINES2 = [];
_nodes apply {
    private _startNode = _x;    
    private _skippers = (_startNode getVariable QGVAR(skippers)) select {
        _x getVariable QGVAR(skipTerrain)
    } apply {
        _x getVariable QGVAR(area)
    };
    private _connections = _startNode getVariable QGVAR(connections);
    private _terrainPoints = [];
    private _startNodePos = getPosASL _startNode;
    private _polygonInner = _startNode getVariable QGVAR(polygonInner);
    private _polygonOuter = _startNode getVariable QGVAR(polygonOuter);
    _startNodePos set [2, 0];
    private _blendEnds = count _connections == 1 && _blendTrenchEnds;
    _connections apply {
        private _endNode = _x;
        private _endNodePos = getPosASL _endNode;
        _endNodePos set [2, 0];
        private _dir = _startNodePos getDir _endNodePos;
        private _vectorDist = _endNodePos vectorDiff _startNodePos;
        private _center = (_startNodePos vectorAdd _endNodePos) vectorMultiply 0.5;
        private _quarter = (_startNodePos vectorAdd (_vectorDist vectorMultiply 0.25));
        private _fromTo = _startNodePos vectorFromTO _center;

        // Offset oscillates between 1 and 1.42 * _cellSize every 45 degrees, to account for the hypotenuse of a terrain grid
        private _offset = (1 + abs(sin(2*_dir)) * 0.42) * _cellSize;
        private _lowerWidth = (ceil (_trenchWidth/_offset) * _offset + _offset)/2;
        _lowerWidth = _lowerWidth max 1.5*_offset;
        private _flattenWidth = (ceil (_widthToEdge/_offset) * _offset) max _lowerWidth;
        private _modifyWidth = _flattenWidth + _transitionLength;
        private _length = (_startNodePos distance2D _center) + _offset;
        private _modifyArea = [_quarter, _modifyWidth, _length/2, _dir, true, -1];
        private _newPoints = [_modifyArea] call TerrainLib_fnc_getAreaTerrainGrid;

        private _offsetLeft = [[0,0,0], _dir-90, _widthToEdge] call FUNC(offset);
        private _offsetRight = [[0,0,0], _dir+90, _widthToEdge] call FUNC(offset);

        private _blendLength = ((_trueDepth * 4) max (_offset*2)) min (_length*0.75);
        private _selectedPoints = [];

        _newPoints apply {
            private _point = _x; 
            if (_point inPolygon _polygonOuter) then {
                continue;
            };
            if (_skippers findIf {_point inArea _x} isNotEqualTo -1) then {continue};
            // This extracts the width along the trench of the point, ignoring the length component
            private _dirToStart = (_startNodePos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startNodePos;

            private _xCompontent = _distToCenter * cos _dirToStart;
            private _yComponent = abs (_distToCenter * sin _dirToStart);
            private _centreLine = _startNodePos vectorAdd (_fromTo vectorMultiply _xCompontent);
            private _lowestEdge = selectMin [
                getTerrainHeightASL (_centreLine vectorAdd _offsetLeft),
                getTerrainHeightASL (_centreLine vectorAdd _offsetRight)
            ];
            // private _yComponent = _distToCenter * sin _dirToStart;
            private _currentHeight = _point#2;
            private _newHeight = _currentHeight;
            // If the point is within the trench width, set the height to the trench depth
            if (_yComponent <= _lowerWidth) then {
                // P1 pushBack _point;
                _newHeight = _lowestEdge - _trueDepth;
            };
            // If the point in between the inner and outer lip of trench objects, flatten to the lowest edge
            if (_yComponent > _lowerWidth && _yComponent <= _flattenWidth) then {
                // P2 pushBack _point;
                _newHeight = _lowestEdge;
            };
            // If the point is outside the trench width, blend to the lowest edge. Ignore if the lowest edge is higher than the current height.
            if (_yComponent > _flattenWidth && _currentHeight > _lowestEdge) then {
                // P2 pushBack _point;
                private _distToEdge = _yComponent - _widthToEdge;
                private _blend = (1 min _distToEdge / _transitionLength) max 0;
                _newHeight = _currentHeight * _blend + _lowestEdge * (1 - _blend);
            };

            if (_newHeight isEqualTo _currentHeight) then {
                continue;
            };

            // Blend trench ends
            if (_xCompontent < _blendLength && _blendEnds) then {
                private _blend = (1 min _xCompontent / _blendLength) max 0;
                _newHeight = _newHeight * _blend + _currentHeight * (1 - _blend);
            };

            _point set [2, _newHeight];
            _selectedPoints pushBack _point;
            // if (_x inPolygon _polygon) then {
            //     _overlapping pushBack _point;
            // } else {
            //     _selectedPoints pushBack _point;
            // };
        };
        _terrainPoints append _selectedPoints;
    };


    /*
    while {count _overlapping > 0} do {
        private _point = _overlapping#0;
        private _matching = _overlapping select {_x#0 isEqualTo _point#0 && {_x#1 isEqualTo _point#1}};
        // systemChat str count _matching;
        _overlapping = _overlapping - _matching;
        private _matchingCount = count _matching;
        if (_matchingCount > 1) then {
            private _matchingZ = selectMin (_matching apply {_x#2});
            _point set [2, _matchingZ];
        };
        _terrainPoints pushBack _point;
    };
    */

    if (count _connections > 1) then {
        LINES1 append _polygonInner;
        LINES2 append _polygonOuter;
        private _polygonX = _polygonOuter apply {_x#0};
        private _polygonY = _polygonOuter apply {_x#1};
        private _polygonMinX = selectMin _polygonX;
        private _polygonMaxX = selectMax _polygonX;
        private _polygonMinY = selectMin _polygonY;
        private _polygonMaxY = selectMax _polygonY;

        private _polygonMinZ = selectMin (_polygonOuter apply {_x#2});

        private _polygonRangeX = _polygonMaxX - _polygonMinX;
        private _polygonRangeY = _polygonMaxY - _polygonMinY;
        private _polygonCentre = [_polygonMinX + _polygonRangeX/2, _polygonMinY + _polygonRangeY/2, 0];
        private _polygonArea = [_polygonCentre, _polygonRangeX/2, _polygonRangeY/2, 0, true, -1];
        // systemChat str _polygonCentre;
        private _polygonPoints = ([_polygonArea] call TerrainLib_fnc_getAreaTerrainGrid) select {_x inPolygon _polygonOuter};
        _polygonPoints apply {
            private _point = _x;
            if (_point inPolygon _polygonInner) then {
                _x set [2, _polygonMinZ - _trueDepth];;
            } else {
                _x set [2, _polygonMinZ]
            };
        };
        _terrainPoints append _polygonPoints;
        // _terrainPoints = _polygonPoints;
    };

    _startNode setVariable [QGVAR(terrainPoints), _terrainPoints];
};
