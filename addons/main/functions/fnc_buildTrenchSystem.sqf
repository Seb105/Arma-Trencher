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
if (count _allNodes < 2) exitWith {
    [_allNodes] call trencher_main_fnc_cleanUpNodes;
};
private _cellSize = (getTerrainInfo)#2;
private _controller = _controllers#0;

// Check if we need to update. As you can modify more than one trench at a time, we need to check if the last frame we updated this trench was the current frame
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
// systemChat str [count _nodes, count _pairs];
// Don't update objects that have already been updated this frame
private _frame = diag_frameNo; 
_nodes = _nodes select {
    private _frameNo = _x getVariable [QGVAR(frameNo), -1];
    _frameNo isNotEqualTo _frame
};
_nodes apply {
    _x setVariable [QGVAR(frameNo), _frame];
};

// Cleanup existing objs
[_nodes] call trencher_main_fnc_cleanUpNodes;
_nodes apply {
    // systemChat str _controllerSettings;
    [_x, _controllerSettings] call FUNC(nodeSettingsSet);
};


private _depth = _controller getVariable "TrenchDepth";
private _trenchWidth = ((_controller getVariable "TrenchWidth") max 0) + 0.7;
private _pitch = -3; //(_controller getVariable "TrenchPitch") - 3; // SLope of the trench walls
private _blendTrenchEnds = _controller getVariable "BlendEnds";
private _skipTerrain = _controller getVariable "SkipTerrain";
private _skipObjects = _controller getVariable "SkipObjects";
private _skipHidingObjects = _controller getVariable "SkipHidingObjects";
private _transitionLength = _controller getVariable "TransitionLength";

private _numHorizontal = 1 + (_controller getVariable "AdditionalHorizSegments");
private _objectsWidth = SEGMENT_WIDTH * _numHorizontal;
private _widthToObj = _trenchWidth/2;
private _widthToEdge = _widthToObj + _objectsWidth;
private _widthToTransition = _widthToEdge + _transitionLength;
private _trueDepth = 0 max (_depth - SEGMENT_FALL * _numHorizontal);
private _trenchProperties = [
    _widthToObj,
    _widthToEdge,
    _widthToTransition,
    _trenchWidth,
    _objectsWidth,
    _transitionLength,
    _numHorizontal,
    _cellSize,
    _trueDepth,
    _pitch
];
[_nodes, _trenchProperties] call FUNC(getTrenchLines);
if !(_skipObjects) then {
    [_nodes, _trenchProperties] call FUNC(getTrenchObjects);
};
// // Get objs to hide
// if !(_skipHidingObjects) then {
//     [_nodes, _trenchWidth/2 + SEGMENT_WIDTH] call FUNC(getObjsToHide)
// };

// Handle terrain
if !(_skipTerrain) then {
    [_nodes, _trenchProperties, _blendTrenchEnds] call FUNC(getTerrainPoints);
    [_nodes, _widthToEdge, _blendTrenchEnds, _trueDepth, _cellSize] call FUNC(handleTerrain);
};

// Create new objs
[_nodes] call trencher_main_fnc_handleObjects;
// [_nodes, _controller, _pitch] call trencher_main_fnc_handleObjectAdditions;

// // Write to SQM
// call FUNC(writeToSQM);
