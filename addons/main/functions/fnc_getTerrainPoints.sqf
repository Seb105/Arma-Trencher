#include "script_component.hpp"
params ["_nodes", "_trenchProperties", "_blendTrenchEnds"];
_trenchProperties params [
    "_widthToObj",
    "_widthToEdge",
    "_widthToTransition",
    "_trenchWidth",
    "_objectsWidth",
    "_transitionLength",
    "_numHorizontal",
    "_cellSize",
    "_trueDepth"
];
private _doTransition = _transitionLength > 0;
_nodes apply {
    private _node = _x;    
    private _skippers = (_node getVariable QGVAR(skippers)) select {
        _x getVariable QGVAR(skipTerrain)
    } apply {
        _x getVariable QGVAR(area)
    };
    private _connections = _node getVariable QGVAR(connections);
    private _terrainPoints = [];
    private _polygonInner = _node getVariable QGVAR(polygonInner);
    private _polygonOuter = _node getVariable QGVAR(polygonOuter);
    private _polygonTransition = _node getVariable QGVAR(polygonTransition);
    private _singleConnection = count _connections == 1;
    private _blendEnds = _singleConnection && _blendTrenchEnds;
    private _mainLines = _node getVariable QGVAR(mainLines);
    _mainLines apply {
        _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine", "_reversed", "_ownPolygon"];
        // Longest line will either be the centreline or the transition line
        private _d1 = _centreLine#0 distance2D _centreLine#1;
        private _d2 = _transitionLine#0 distance2D _transitionLine#1;
        private _centreIsLongest = _d1 > _d2;
        private _longestPair = [_transitionLine, _centreLine] select _centreIsLongest;
        private _length = _d1 max _d2;
        private _dir = _longestPair#0 getDir _longestPair#1;
        private _line = if (_centreIsLongest) then {
            // continue;
            _centreLine
        } else {
            private _centreLine = _transitionLine apply {
                [_x, _dir - 90, _widthToTransition] call FUNC(offset);
            };
            _centreLine
        };
        _line params ["_startPos", "_endPos"];
        private _fromTo = _startPos vectorFromTo _endPos;
        private _centreStart = [_startPos, _dir+90, _widthToTransition/2] call FUNC(offset);
        private _areaCentre = [_centreStart, _dir, _length/2] call FUNC(offset);
        private _area = [_areaCentre, _widthToTransition/2 + _cellSize/2, _length/2 + _cellSize/2, _dir, true, -1];

        private _offset = (1 + abs(sin(2*_dir)) * 0.42) * _cellSize;
        private _lowerWidth = (ceil (_trenchWidth/_offset) * _offset + _offset)/2;
    
        private _offsetLeft = [[0,0], _dir - 90, _widthToEdge] call FUNC(offset);
        private _offsetRight = [[0,0], _dir + 90, _widthToEdge] call FUNC(offset);
        private _newPoints = ([_area] call TerrainLib_fnc_getAreaTerrainGrid) select {(_x inPolygon _ownPolygon)};
        _newPoints apply {
            private _point = _x;
            private _dirToStart = (_startPos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startPos;
            private _xComponent = _distToCenter * cos _dirToStart;
            private _yComponent =  _distToCenter * sin _dirToStart;
            // if !(_point inPolygon _ownPolygon) then {
            //     continue
            // };
            private _linePos = _startPos vectorAdd (_fromTo vectorMultiply _xComponent);
            private _lowestEdge = selectMin [
                getTerrainHeightASL (_linePos vectorAdd _offsetLeft),
                getTerrainHeightASL (_linePos vectorAdd _offsetRight)
            ];
            private _height = _lowestEdge;
            if (_yComponent < _lowerWidth) then {
                _height = _height - _trueDepth;
            };
            if (_yComponent > _widthToEdge && _doTransition) then {
                private _transitionEdge = getTerrainHeightASL ([_linePos, _dir+90, _widthToTransition] call FUNC(offset));
                private _transitionAmount  = (_yComponent - _widthToEdge) / _transitionLength;
                _height = _lowestEdge * (1 - _transitionAmount) + _transitionEdge * _transitionAmount;
            };
            _point set [2, _height];
        };
        _terrainPoints append _newPoints;
    };
    private _cornerLines = _node getVariable QGVAR(cornerLines);

    _cornerLines apply {
        _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine", "_a1", "_a2", "_relAngle"];
        if (_relAngle < 180) then {
            continue;
        };
        _centreline params ["_startPos", "_endPos"];
        _innerline params ["_inner1", "_inner2"];
        _edgeline params ["_edge1", "_edge2"];
        _transitionLine params ["_trans1", "_trans2"];
        private _ownPolygon = [
            _inner1,
            _edge1,
            _trans1,
            _trans2,
            _edge2,
            _inner2
        ];
        private _length = _trans1 distance2D _trans2;
        private _dir = _inner1 getDir _inner2;
        private _fromTo = _edge1 vectorFromTo _edge2;

        private _zNear1 = getTerrainHeightASL _edge1;
        private _far1 =  [_edge1, _a1-90, _widthToEdge*2] call FUNC(offset);
        private _zFar1 = getTerrainHeightASL _far1;
        private _z1 = _zNear1 min _zFar1;

        private _zNear2 = getTerrainHeightASL _edge2;
        private _far2 =  [_edge2, _a2-90, _widthToEdge*2] call FUNC(offset);
        private _zFar2 = getTerrainHeightASL _far2;
        private _z2 = _zNear2 min _zFar2;

        private _centreStart = [_trans1, _dir-90, _widthToTransition/2] call FUNC(offset);
        private _areaCentre = [_centreStart, _dir, _length/2] call FUNC(offset);
        private _area = [_areaCentre, _widthToTransition/2 + _cellSize/2, _length/2 + _cellSize/2, _dir, true, -1];
        private _newPoints = ([_area] call TerrainLib_fnc_getAreaTerrainGrid) select {_x inPolygon _ownPolygon};
        private _newPointsFiltered = [];
        {
            private _point = _x;
            private _dirToStart = (_startPos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startPos;
            private _xComponent = _distToCenter * cos _dirToStart;
            private _yComponent =  _distToCenter * sin _dirToStart;
            if (_yComponent < _widthToObj) then {
                continue; // Handled in inner polygon
            };
            private _xWeight = _xComponent / _length;
            private _height = _z1 * (1 - _xWeight) + _z2 * _xWeight;
            if (_yComponent > _widthToEdge && _doTransition) then {
                private _linePos = _startPos vectorAdd (_fromTo vectorMultiply _xComponent);
                private _transitionEdge = getTerrainHeightASL ([_linePos, _dir+90, _widthToTransition] call FUNC(offset));
                private _transitionAmount  = (_yComponent - _widthToEdge) / _transitionLength;
                _height = _height * (1 - _transitionAmount) + _transitionEdge * _transitionAmount;
            };
            _point set [2, _height];
            _newPointsFiltered pushBack _point;
        } forEach _newPoints;
        _terrainPoints append _newPointsFiltered;
    };

    
    // Get corner lines from each side of trench and add them to corner points with the lowest Z of the 2
    if (count _connections > 1) then {
        private _innerPoints = [];
        {
            _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine", "_reversed"];
            _innerLine params ["_inner1", "_inner2"];
            private _dir = _inner1 getDir _inner2;
            private _innerPoint = if (_reversed) then {
                +_inner1
            } else {
                +_inner2
            };
            private _offsetLeft = [[0,0], _dir - 90, _widthToObj + _widthToEdge] call FUNC(offset);
            private _offsetRight = [[0,0], _dir + 90, _objectsWidth] call FUNC(offset);
            private _minZ = selectMin [
                getTerrainHeightASL (_innerPoint vectorAdd _offsetLeft),
                getTerrainHeightASL (_innerPoint vectorAdd _offsetRight)
            ];
            _innerPoint set [2, _minZ];
            _innerPoints pushBack _innerPoint;
        } forEach _mainLines;

        private _polygonSubject = _polygonInner;
        private _polygonX = _polygonSubject apply {_x#0};
        private _polygonY = _polygonSubject apply {_x#1};
        private _polygonMinX = selectMin _polygonX;
        private _polygonMaxX = selectMax _polygonX;
        private _polygonMinY = selectMin _polygonY;
        private _polygonMaxY = selectMax _polygonY;
        private _polygonRangeX = _polygonMaxX - _polygonMinX;
        private _polygonRangeY = _polygonMaxY - _polygonMinY;
        private _polygonCentre = [_polygonMinX + _polygonRangeX/2, _polygonMinY + _polygonRangeY/2, 0];
        private _polygonArea = [_polygonCentre, _polygonRangeX/2, _polygonRangeY/2, 0, true, -1];
        // systemChat str _polygonCentre;
        private _polygonPoints = ([_polygonArea] call TerrainLib_fnc_getAreaTerrainGrid) select {_x inPolygon _polygonSubject};
        _polygonPoints apply {
            private _point = _x;
            // Use inverse distance weighting to calculate the height of the point
            private _totalWeight = 0;
            private _totalHeight = 0;
            _innerPoints apply {
                private _dist = _point distance2D _x;
                private _weight = 1 / (_dist max 0.0001);
                _weight = _weight^3;
                _totalWeight = _totalWeight + _weight;
                _totalHeight = _totalHeight + _x#2 * _weight;
            };
            private _height = _totalHeight / _totalWeight;
            _point set [2, _height - _trueDepth];
        };
        _terrainPoints append _polygonPoints;
        // _terrainPoints = _polygonPoints;
    };

    _node setVariable [QGVAR(terrainPoints), _terrainPoints];
};
