#include "script_component.hpp"
params ["_origin"];
([_origin] call trencher_main_fnc_uniquePairs) params ["_nodes", "_pairs"];
// Cleanup existing objs 
[_nodes] call trencher_main_fnc_cleanUpNodes;
if (count _nodes < 2) exitWith {};
private _controllers = _nodes select {
    _x isKindOf "trencher_main_Module_TrenchController"
};
if (count _controllers > 1) exitWith {
    ["A trench can only have 1 controller module synced", 1, 5, true, 0.2] call BIS_fnc_3DENNotification
};
if (count _controllers == 0) exitWith {
    ["A trench must have a controller module synced", 1, 5, true, 0] call BIS_fnc_3DENNotification
};
private _cellSize = (getTerrainInfo)#2;
private _controller = _controllers#0;
private _depth = _controller getVariable "TrenchDepth";
private _trenchWidth = _controller getVariable "TrenchWidth";
private _pitch = _controller getVariable "TrenchPitch"; // SLope of the trench walls
private _blendTrenchEnds = _controller getVariable "BlendEnds";
private _minTrenchWidth = (_cellSize/2) * (sqrt 2);
if (_trenchWidth < _minTrenchWidth) then {
    _trenchWidth = _minTrenchWidth;
    private _msg = format ["Terrain cell size is %1. Trench width cannot be less than (cellsize/2) * √2. Defaulting to %2", _cellSize, _trenchWidth];
    [_msg, 1, 5, true, 0] call BIS_fnc_3DENNotification;
    _controller setVariable ["TrenchWidth", _trenchWidth];
};
// Create new objs+
private _widthToObj = (SEGMENT_WIDTH + _trenchWidth)/2;
private _widthToEdge = _trenchWidth/2 + SEGMENT_WIDTH;
private _trueDepth = 0 max (_depth - SEGMENT_FALL);
private _lines = [_nodes, _trenchWidth] call FUNC(getTrenchLines);
private _toPlace = [_lines, _pitch] call FUNC(getTrenchObjects);
private _toHide = [_pairs, _trenchWidth] call FUNC(getObjsToHide);
// Handle terrain
_terrainPoints = [_pairs, _widthToEdge, _widthToObj, _cellSize, _trueDepth] call FUNC(getTerrainPoints);
[_controller, _nodes, _terrainPoints, _widthToEdge, _blendTrenchEnds] call trencher_main_fnc_handleTerrain;

// systemChat str _toPlace;
private _trenchPieces = [_controller, _toPlace, _toHide] call trencher_main_fnc_handleObjects;
// Copy arr as to not iterate whilst modifying
(+_trenchPieces) apply {
    [_x, _trenchPieces, _controller] call trencher_main_fnc_handleObjectAdditions;
};	
