#include "script_component.hpp"
params ["_centre", "_dist", "_trenchArea"];
// Hide objects in the trench area
private _nearObjs = nearestTerrainObjects [_centre, [], _dist, false, true];
private _objsToHide = (_nearObjs inAreaArray _trenchArea) select {!isObjectHidden _x};
_objsToHide;
