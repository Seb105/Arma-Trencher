#include "script_component.hpp"
params ["_nodes", "_trenchProperties"];
_trenchProperties params [
    "_widthToObj",
    "_widthToEdge",
    "_widthToTransition",
    "_trenchWidth",
    "_objectsWidth",
    "_transitionLength",
    "_numHorizontal",
    "_cellSize",
    "_trueDepth",
    "_pitch"
];
private _distToOtherEdge = _widthToEdge + _trenchWidth/2 + SEGMENT_WIDTH/2;
private _distToFront = _objectsWidth - SEGMENT_WIDTH/2;
_nodes apply {
    private _toPlace = [];
    private _node = _x;

    private _skippers = (_node getVariable QGVAR(skippers)) select {
        _x getVariable QGVAR(segmentSkip)
    } apply {
        _x getVariable QGVAR(area)
    };
    
    private _lines = _node getVariable QGVAR(mainLines);
    private _ends = _node getVariable QGVAR(cornerLines);
    _lines apply {
        _x params ["_", "_innerLine", "_", "_", "_", "_"];
        _innerLine params ["_start", "_end"];
        // if (_isSinglePoint) then {continue};
        private _dir = _start getDir _end;
        private _pieceDir = _dir - 90;
        // private _trueStart = [_start, _dir, SEGMENT_LENGTH_HALF] call FUNC(offset);
        // private _trueEnd = [_end, _dir, SEGMENT_LENGTH_HALF] call FUNC(offset);
        private _objCentreStart = [_start, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);
        private _objCentreEnd = [_end, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);

        private _totalDistance = _objCentreStart distance2D _objCentreEnd;
        private _fromTo = _objCentreStart vectorFromTo _objCentreEnd;
        private _distance = 0;
        private _offsetOtherSide = [[0,0], _dir - 90, _distToOtherEdge] call FUNC(offset);
        private _offsetToFront = [[0,0], _dir + 90, _distToFront] call FUNC(offset);
        private _lineLengths = [];
        while {_distance <= (_totalDistance)} do {
            private _startPos = _objCentreStart vectorAdd (_fromTo vectorMultiply _distance);
            private _startHeight = selectMin [
                getTerrainHeightASL (_startPos vectorAdd _offsetOtherSide),
                getTerrainHeightASL (_startPos vectorAdd _offsetToFront)
            ];
            private ["_searchDist", "_endPos", "_endHeight", "_fall", "_hypotenuse"];
            for "_i" from 0 to (SEGMENT_LENGTH - 0.1) step 0.1 do {
                _searchDist = SEGMENT_LENGTH - _i;
                _endPos = _objCentreStart vectorAdd (_fromTo vectorMultiply (_distance + _searchDist));
                _endHeight = selectMin [
                    getTerrainHeightASL (_endPos vectorAdd _offsetOtherSide),
                    getTerrainHeightASL (_endPos vectorAdd _offsetToFront)
                ];
                _fall = _endHeight - _startHeight;
                _hypotenuse = sqrt (_searchDist^2 + _fall^2);
                if (_hypotenuse < SEGMENT_LENGTH) exitWith {};
            };
            _lineLengths pushBack _searchDist;
            _distance = _distance + _searchDist;
        };
        private _offBy = _totalDistance/_distance;
        private _lineLengths = _lineLengths apply {
            _x * _offBy
        };
        private _along = 0;
        {
            _x params ["_searchDist"];
            private _startPos = _objCentreStart vectorAdd (_fromTo vectorMultiply _along);
            private _endPos = _objCentreStart vectorAdd (_fromTo vectorMultiply (_along + _searchDist));
            private _startHeight = selectMin [
                getTerrainHeightASL (_startPos vectorAdd _offsetOtherSide),
                getTerrainHeightASL (_startPos vectorAdd _offsetToFront)
            ];
            private _endHeight = selectMin [
                getTerrainHeightASL (_endPos vectorAdd _offsetOtherSide),
                getTerrainHeightASL (_endPos vectorAdd _offsetToFront)
            ];
            private _fall = _endHeight - _startHeight;
            // private _hypotenuse = sqrt (_searchDist^2 + _fall^2);
            private _pieceRoll = -atan (_fall / _searchDist);
            _startPos set [2, _startHeight - SEGMENT_SLOPE_BOTTOM];
            _endPos set [2, _endHeight - SEGMENT_SLOPE_BOTTOM];
            private _vectorDirAndUp = [
                [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
                [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
            ];
            private _posASL = (_startPos vectorAdd _endPos) vectorMultiply 0.5;
            _toPlace pushBack [_posASL, _vectorDirAndUp];
            _along = _along + _searchDist;
        } forEach _lineLengths;
    };

    _ends apply {
        _x params ["_centreLine", "_innerLine", "_edgeLine", "_transitionLine", "_a1", "_a2", "_relAngle"];
        _innerLine params ["_start", "_end"];
        private _dir = _start getDir _end;
        private _long = _relAngle > 190;
        private _pieceDir = _dir - 90;
        private _startHeight = selectMin [
            getTerrainHeightASL ([_start, _a1+90, _objectsWidth] call FUNC(offset)),
            getTerrainHeightASL ([_start, _a1-90, _widthToEdge + _trenchWidth/2] call FUNC(offset))
        ];  
        private _endHeight = selectMin [
            getTerrainHeightASL ([_end, _a2+90, _distToFront] call FUNC(offset)),
            getTerrainHeightASL ([_end, _a2-90, _widthToEdge + _trenchWidth/2] call FUNC(offset))
        ];

        private _fall = _endHeight - _startHeight;
        private _distanced2d = _start distance2D _end;
        // private _numHorizontal = 1;
        private _pieceRoll = atan (_fall / _distanced2d);

        // private _height = (_currentHeight + _nextHeight)/2 - SEGMENT_SLOPE_BOTTOM;
        // _objCentre set [2, _height];
        private _vectorDirAndUp = [
            [sin _pieceDir * cos _pitch, cos _pieceDir * cos _pitch, sin _pitch],
            [[sin _pieceRoll, -sin _pitch, cos _pieceRoll * cos _pitch], -_pieceDir] call BIS_fnc_rotateVector2D
        ];
        for "_i" from 1 to _numHorizontal do {
            private _isEnd = (_i == _numHorizontal || _i == 1) && _long;
            private _proportion = (_i-0.5) / _numHorizontal;
            private _height = _startHeight - _fall*_proportion;
            private _edgeCentre = [_start, _dir, _proportion * _distanced2d] call FUNC(offset);
            private _objCentre = [_edgeCentre, _dir+90, SEGMENT_WIDTH_HALF] call FUNC(offset);
            if (_skippers findIf {_objCentre inArea _x} isNotEqualTo -1) then {continue};
            _objCentre set [2, _height - SEGMENT_SLOPE_BOTTOM];
            _toPlace pushBack [_objCentre, _vectorDirAndUp, _isEnd];
        };
    };
    _node setVariable [QGVAR(toPlace), _toPlace];
};
