#include "script_component.hpp"
params ["_pairs", "_trenchWidth"];
private _toHide = [];
_pairs apply {
    _x params ["_n1", "_n2"];
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
    private _objs = ((nearestTerrainObjects [_mid, [], _radius, false, true]) inAreaArray _area) select {
        !(isObjectHidden _x)
    };
    _toHide append _objs;
};
_toHide = _toHide arrayIntersect _toHide;
_toHide 
