#include "script_component.hpp"
params ["_startPos", "_endPos", "_widthToObj", "_dist", "_dir", "_interSectionAreas", "_hiddenObjects"];
// Area below the trench you can actually walk in
private _centre = _startPos vectorAdd _endPos vectorMultiply 0.5;
private _trenchArea = [_centre, _widthToObj/1.2, _dist/2, _dir, true, -1];
_interSectionAreas pushBack (_trenchArea);
// Hide objects in the trench area
private _nearObjs = nearestTerrainObjects [_centre, [], _dist, false, true];
private _objsToHide = (_nearObjs inAreaArray _trenchArea) select {!isObjectHidden _x};
_hiddenObjects append _objsToHide;
