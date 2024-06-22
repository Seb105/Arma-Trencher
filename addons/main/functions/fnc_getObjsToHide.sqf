#include "script_component.hpp"
params ["_nodes", "_trenchWidth"];

_nodes apply {
    private _connections = _x getVariable QGVAR(connections);
    private _n1 = _x;
    private _toHide = [];
    private _areas = [];
    _connections apply {
        private _n2 = _x;
        private _n1Pos = getPos _n1;
        private _n2Pos = getPos _n2;
        [_n1Pos, _n2Pos] apply {
            _x set [2, 0]
        };
        private _dir = _n1Pos getDir _n2Pos;
        private _vectorFromTo = _n2Pos vectorDiff _n1Pos;
        private _quarterPoint = (_n1Pos vectorAdd (_vectorFromTo vectorMultiply 0.25));
        private _dist = _n1Pos distance2D _n2Pos;
        private _radius = sqrt (_trenchWidth^2 + _dist^2) / 2;
        private _area = [
            _quarterPoint,
            _trenchWidth/2,
            _dist/4,
            _dir,
            true
        ];
        private _objs = ((nearestTerrainObjects [_quarterPoint, [], _radius, false, true]) inAreaArray _area);
        
        if (count _objs > 0) then {
            _areas pushBack _area;
            _toHide append _objs;
        };
    };
    _toHide = _toHide arrayIntersect _toHide;
    _n1 setVariable [QGVAR(toHideObjs), _toHide];
    _n1 setVariable [QGVAR(toHideAreas), _areas];
};
