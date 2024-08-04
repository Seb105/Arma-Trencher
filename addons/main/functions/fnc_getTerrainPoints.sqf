#include "script_component.hpp"
params ["_nodes", "_trenchWidth", "_widthToEdge", "_transitionLength", "_cellSize", "_trueDepth", "_blendTrenchEnds"];
LINES1 = [];
LINES2 = [];
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
    private _singleConnection = count _connections == 1;
    private _blendEnds = _singleConnection && _blendTrenchEnds;
    private _lines = _node getVariable QGVAR(lines);
    _lines apply {
        _x params ["_startPos", "_endPos", "_reversed"];
        private _dir = _startPos getDir _endPos;
        // private _vectorDist = _endPos vectorDiff _startPos;
        private _center = (_startPos vectorAdd _endPos) vectorMultiply 0.5;
        // private _quarter = (_startPos vectorAdd (_vectorDist vectorMultiply 0.25));
        private _fromTo = _startPos vectorFromTo _center;

        // Offset oscillates between 1 and 1.42 * _cellSize every 45 degrees, to account for the hypotenuse of a terrain grid
        private _offset = (1 + abs(sin(2*_dir)) * 0.42) * _cellSize;
        private _lowerWidth = (ceil (_trenchWidth/_offset) * _offset + _offset)/2;
        // _lowerWidth = _lowerWidth max 1.5*_offset;
        private _flattenWidth = _widthToEdge max _lowerWidth;//(ceil (_widthToEdge/_offset) * _offset) max _lowerWidth;
        private _modifyWidth = _flattenWidth + _transitionLength;
        private _areaCenter = +_center;
        // if !(_single) then {
            _areaCenter = [_areaCenter, _dir + 90, _modifyWidth/2] call FUNC(offset);
            _modifyWidth = _modifyWidth/2;
        // };
        private _length = (_startPos distance2D _center);
        private _modifyArea = [_areaCenter, _modifyWidth + _cellSize/2, _length + _cellSize/2, _dir, true, -1];
        
        // private _marker = createMarker [str (_modifyArea#0), _modifyArea#0];
        // _marker setMarkerShape "RECTANGLE";
        // _marker setMarkerSize [_modifyArea#1, _modifyArea#2];
        // _marker setMarkerDir _modifyArea#3;
        // _marker setMarkerBrush "SolidBorder";

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
            private _dirToStart = (_startPos getDir _point) - _dir;
            private _distToCenter  = _point distance2D _startPos;

            private _xComponent = _distToCenter * cos _dirToStart;
            private _yComponent =  abs _distToCenter * sin _dirToStart;
            private _centreLine = _startPos vectorAdd (_fromTo vectorMultiply _xComponent);
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
            if (_transitionLength > 0 && _yComponent > _flattenWidth && _currentHeight > _lowestEdge) then {
                // P2 pushBack _point;
                private _distToEdge = _yComponent - _widthToEdge;
                private _blend = (1 min _distToEdge / _transitionLength) max 0;
                _newHeight = _currentHeight * _blend + _lowestEdge * (1 - _blend);
            };

            if (_newHeight isEqualTo _currentHeight) then {
                continue;
            };

            // Blend trench ends
            if (_blendEnds) then {
                private _distFromEntrance = if (_reversed) then {
                    _length*2 - _xComponent
                } else {
                    _xComponent
                };
                private _blend = (1 min _distFromEntrance / _blendLength) max 0;
                _newHeight = _newHeight * _blend + _currentHeight * (1 - _blend);
            };

            _point set [2, _newHeight];
            _selectedPoints pushBack _point;
        };
        _terrainPoints append _selectedPoints;
    };

    if (count _connections > 1) then {
        // LINES1 append _polygonInner;
        // LINES2 append _polygonOuter;
        private _polygonX = _polygonInner apply {_x#0};
        private _polygonY = _polygonInner apply {_x#1};
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
            _polygonInner apply {
                private _dist = _point distance2D _x;
                private _weight = 1 / (_dist max 0.01);
                _weight = _weight^3;
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
