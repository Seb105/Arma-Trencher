#include "script_component.hpp"
params ["_pairs", "_trenchWidth"];

_pairs apply {
    _x params ["_n1", "_n2"];
    private _toHide = [];
    private _areas = [];
    private _n1Pos = getPos _n1;
    private _n2Pos = getPos _n2;
    [_n1Pos, _n2Pos] apply {
        _x set [2, 0]
    };
    private _dir = _n1Pos getDir _n2Pos;
    private _dist = _n1Pos distance2D _n2Pos;
    private _mid = (_n1Pos vectorAdd _n2Pos) vectorMultiply 0.5;
    private _radius = sqrt (_trenchWidth^2 + _dist^2) / 2;
    private _area = [
        _mid,
        _trenchWidth/2,
        _dist/2,
        _dir,
        true
    ];
    private _objs = ((nearestTerrainObjects [_mid, [], _radius, false, true]) inAreaArray _area);
    
    if (count _objs > 0) then {
        _areas pushBack _area;
        _toHide append _objs;
    };
    _toHide = _toHide arrayIntersect _toHide;
    _n1 setVariable [QGVAR(toHideObjs), _toHide];
    _n1 setVariable [QGVAR(toHideArea), _area];
};
