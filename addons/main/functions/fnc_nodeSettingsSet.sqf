#include "script_component.hpp"
params ["_node", "_settingsHash", "_ctx"];
// Don't overwrite the settings of a controller
if (_node isKindOf QGVAR(Module_TrenchController)) exitWith {};
private _names = [
    "TrenchDepth",
    "TrenchWidth",
    "BlendEnds",
    "TrenchPitch",
    "WallType",
    "DoSandbags",
    "DoBarbedWire",
    "TankTrapType",
    "AdditionalHorizSegments",
    "SkipTerrain",
    "SkipObjects",
    "SkipHidingObjects"
];
if (isNil "_settingsHash") then {
    _names apply {
        _node setVariable [_x, nil];
    };
} else {
    // systemChat str [typeName _node, typeName _settingsHash];
    _names apply {
        private _hashValue = _settingsHash get _x;
        // systemChat str [isNull _node, _x, _hashValue];
        _node setVariable [_x, _hashValue];
    };
};
