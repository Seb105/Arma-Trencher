#include "script_component.hpp"
params ["_origin", ["_thisSegmentOnly", true]];
([_origin] call trencher_main_fnc_uniquePairs) params ["_allNodes", "_allPairs"];
private _controllers = _allNodes select {
    _x isKindOf "trencher_main_Module_TrenchController"
};
if (count _controllers > 1) exitWith {
    ["A trench can only have 1 controller module synced", 1, 5, true, 0.5] call BIS_fnc_3DENNotification;
    [_allNodes] call trencher_main_fnc_cleanUpNodes;
};
if (count _controllers == 0) exitWith {
    ["A trench must have a controller module synced", 1, 5, true, 0] call BIS_fnc_3DENNotification;
    [_allNodes] call trencher_main_fnc_cleanUpNodes;
};
if (count _allNodes < 2) exitWith {
    [_allNodes] call trencher_main_fnc_cleanUpNodes;
};
private _cellSize = (getTerrainInfo)#2;
private _controller = _controllers#0;

// Check if we need to update. As you can modify more than one trench at a time, we need to check if the last frame we updated this trench was the current frame
// private _frame = diag_frameNo;
// if (_controller getVariable [QGVAR(lastFrame), -1] == _frame) exitWith {};
// _controller setVariable [QGVAR(lastFrame), _frame];
if (_controller getVariable [QGVAR(locked), false]) exitWith {};
_controller setVariable [QGVAR(locked), true];

private _controllerSettings = [_controller] call FUNC(nodeSettingsGet);
private _nodes = _allNodes;
private _pairs = _allPairs;
if (_thisSegmentOnly) then {
    private _connections = _origin getVariable QGVAR(connections);
    _nodes = _allNodes select {
        private _settings = [_x] call FUNC(nodeSettingsGet);
        // copyToClipboard str [get3DENEntityID _x, _settings, _controllerSettings];
        _x isEqualTo _origin || _x in _connections || _settings isNotEqualTo _controllerSettings;
    };
    _pairs = _allPairs select {
        count (_nodes arrayIntersect _x) > 0;
    };
};
systemChat str [count _nodes, count _pairs];
// Cleanup existing objs 
[_nodes] call trencher_main_fnc_cleanUpNodes;
_nodes apply {
    // systemChat str _controllerSettings;
    [_x, _controllerSettings] call FUNC(nodeSettingsSet);
};


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
if !(_skipObjects) then {
    [_nodes, _trenchWidth, _widthToEdge] call FUNC(getTrenchLines);
    [_nodes, _pitch, _trenchWidth] call FUNC(getTrenchObjects);
};
// Get objs to hide
if !(_skipHidingObjects) then {
    [_nodes, _trenchWidth + SEGMENT_WIDTH] call FUNC(getObjsToHide)
};

// Handle terrain
if !(_skipTerrain) then {
    [_pairs, _widthToEdge, _widthToObj, _cellSize, _trueDepth] call FUNC(getTerrainPoints);
    [_pairs, _widthToEdge, _blendTrenchEnds, _trueDepth, _cellSize] call FUNC(handleTerrain);
};

// Create new objs
[_nodes] call trencher_main_fnc_handleObjects;
[_nodes, _controller] call trencher_main_fnc_handleObjectAdditions;

// Write to SQM
call FUNC(writeToSQM);

_controller setVariable [QGVAR(locked), false];
