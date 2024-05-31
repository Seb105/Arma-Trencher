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

// systemchat str ["built", time];

// Check if we need to update. As you can modify more than one trench at a time, we need to check if the last frame we updated this trench was the current frame
// private _frame = diag_frameNo;
// if (_controller getVariable [QGVAR(lastFrame), -1] == _frame) exitWith {};
// _controller setVariable [QGVAR(lastFrame), _frame];


private _depth = _controller getVariable "TrenchDepth";
private _trenchWidth = _controller getVariable "TrenchWidth";
private _pitch = _controller getVariable "TrenchPitch"; // SLope of the trench walls
private _blendTrenchEnds = _controller getVariable "BlendEnds";
private _skipTerrain = _controller getVariable "SkipTerrain";
private _skipObjects = _controller getVariable "SkipObjects";
private _skipHidingObjects = _controller getVariable "SkipHidingObjects";


private _minTrenchWidth = (_cellSize/2) * (sqrt 2);
if (_trenchWidth < _minTrenchWidth) then {
    _trenchWidth = _minTrenchWidth;
    private _msg = format ["Terrain cell size is %1. Trench width cannot be less than (cellsize/2) * √2. Defaulting to %2", _cellSize, _trenchWidth];
    [_msg, 1, 5, true, 0] call BIS_fnc_3DENNotification;
    _controller setVariable ["TrenchWidth", _trenchWidth];
};


// Get new objs to place
private _widthToObj = (SEGMENT_WIDTH + _trenchWidth)/2;
private _widthToEdge = _trenchWidth/2 + SEGMENT_WIDTH;
private _trueDepth = 0 max (_depth - SEGMENT_FALL);
private _toPlace = if (_skipObjects) then {
    []
} else {
    private _lines = [_nodes, _trenchWidth] call FUNC(getTrenchLines);
    [_lines, _pitch, _trenchWidth] call FUNC(getTrenchObjects)
};
// Get objs to hide
private _toHideAreasAndObjs = if (_skipHidingObjects) then {
    [[], []]
} else {
    [_pairs, _trenchWidth + SEGMENT_WIDTH] call FUNC(getObjsToHide)
};
_toHideAreasAndObjs params ["_toHideAreas", "_toHideObjs"];

// Handle terrain
private _terrainPointsSet = if (_skipTerrain) then {
    []
} else {
    private _terrainPoints = [_pairs, _widthToEdge, _widthToObj, _cellSize, _trueDepth] call FUNC(getTerrainPoints);
    [_controller, _nodes, _terrainPoints, _widthToEdge, _blendTrenchEnds, _trueDepth, _cellSize] call trencher_main_fnc_handleTerrain
};

// Create new objs
private _trenchPieces = [_controller, _toPlace, _toHideObjs] call trencher_main_fnc_handleObjects;
private _simpleObjects = [];
private _simulatedObjects = [];
// Copy arr as to not iterate whilst modifying
(+_trenchPieces) apply {
    [_x, _trenchPieces, _simulatedObjects, _simpleObjects, _controller] call trencher_main_fnc_handleObjectAdditions;
};

// Write to SQM
_controller setVariable [QGVAR(simpleObjects), _simpleObjects];
_controller setVariable [QGVAR(simulatedObjects), _simulatedObjects];
_controller setVariable [QGVAR(terrainPoints), _terrainPointsSet];
_controller setVariable [QGVAR(trenchPieces), _trenchPieces];
_controller setVariable [QGVAR(hiddenObjects), _toHideObjs];
_controller setVariable [QGVAR(hideAreas), _toHideAreas];
call FUNC(writeToSQM);
// systemchat str ["built", _controller];
