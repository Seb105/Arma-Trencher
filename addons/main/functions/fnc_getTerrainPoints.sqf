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
        _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine"];
        // Longest line will either be the centreline or the transition line
        private _ownPolygon = [
            _centreLine#0,
            _innerLine#0,
            _edgeLine#0,
            _transitionLine#0,
            _transitionLine#1,
            _edgeLine#1,
            _innerLine#1,
            _centreLine#0
        ];
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
        private _newPoints = ([_area] call TerrainLib_fnc_getAreaTerrainGrid) select {!(_x inPolygon _polygonTransition)};
        _newPoints = _newPoints select {
            private _point = _x;
            private _dirToStart = (_startPos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startPos;
            private _xComponent = _distToCenter * cos _dirToStart;
            private _yComponent =  _distToCenter * sin _dirToStart;
            // If the point is outside the trench, skip it.
            if (_yComponent < 0) then {
                continueWith false;
            };
            if (abs _yComponent > _widthToObj) then {
                // Do this here as checking can accidentally miss points that are on the edge, this is a bit more lenient
                if !(_point inPolygon _ownPolygon) then {
                    continueWith false;
                };
            };
            private _centreLine = _startPos vectorAdd (_fromTo vectorMultiply _xComponent);
            private _lowestEdge = selectMin [
                getTerrainHeightASL (_centreLine vectorAdd _offsetLeft),
                getTerrainHeightASL (_centreLine vectorAdd _offsetRight)
            ];
            private _height = _lowestEdge;
            if (_yComponent < _lowerWidth) then {
                _height = _height - _trueDepth;
            };
            if (_yComponent > _widthToEdge && _doTransition) then {
                private _transitionEdge = getTerrainHeightASL ([_centreLine, _dir+90, _widthToTransition] call FUNC(offset));
                private _transitionAmount  = (_yComponent - _widthToEdge) / _transitionLength;
                _height = _lowestEdge * (1 - _transitionAmount) + _transitionEdge * _transitionAmount;
            };
            _x set [2, _height];
            true;
        };
        _terrainPoints append _newPoints;
    };

    // Get corner lines from each side of trench and add them to corner points with the lowest Z of the 2
    private _cornerLines = _node getVariable QGVAR(cornerLines);
    private _cornerPoints = [];
    {
        _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine"];
        private _nextLineIndex = _forEachIndex + 1;
        if (_nextLineIndex >= count _cornerLines) then {
            _nextLineIndex = 0;
        };
        private _nextLine = _cornerLines#_nextLineIndex;
        _nextLine params ["_nextCentreLine", "_nextInnerLine", "_nextEdgeLine", "_nextTransitionLine"];
        private _p1 = +(_edgeLine#1);
        private _p2 = +(_nextEdgeLine#0);
        private _minZ = selectMin [
            getTerrainHeightASL _p1,
            getTerrainHeightASL _p2
        ];
        _p1 set [2, _minZ];
        _p2 set [2, _minZ];
        _cornerPoints append [_p1, _p2];
    } forEach _cornerLines;

    if (count _connections > 1) then {
        private _polygonX = _polygonOuter apply {_x#0};
        private _polygonY = _polygonOuter apply {_x#1};
        private _polygonMinX = selectMin _polygonX;
        private _polygonMaxX = selectMax _polygonX;
        private _polygonMinY = selectMin _polygonY;
        private _polygonMaxY = selectMax _polygonY;
        private _polygonRangeX = _polygonMaxX - _polygonMinX;
        private _polygonRangeY = _polygonMaxY - _polygonMinY;
        private _polygonCentre = [_polygonMinX + _polygonRangeX/2, _polygonMinY + _polygonRangeY/2, 0];
        private _polygonArea = [_polygonCentre, _polygonRangeX/2, _polygonRangeY/2, 0, true, -1];
        // systemChat str _polygonCentre;
        private _polygonPoints = ([_polygonArea] call TerrainLib_fnc_getAreaTerrainGrid) select {_x inPolygon _polygonInner};
        _polygonPoints apply {
            private _point = _x;
            private _inInner = _point inPolygon _polygonInner;
            private _sub = [0, _trueDepth] select _inInner;
            // Use inverse distance weighting to calculate the height of the point
            private _totalWeight = 0;
            private _totalHeight = 0;
            _cornerPoints apply {
                private _dist = _point distance2D _x;
                private _weight = 1 / (_dist max 0.01);
                _weight = _weight^2;
                _totalWeight = _totalWeight + _weight;
                _totalHeight = _totalHeight + _x#2 * _weight;
            };
            private _height = _totalHeight / _totalWeight;
            _point set [2, _height - _sub];
        };
        _terrainPoints append _polygonPoints;
        // _terrainPoints = _polygonPoints;
    };

    _node setVariable [QGVAR(terrainPoints), _terrainPoints];
};
