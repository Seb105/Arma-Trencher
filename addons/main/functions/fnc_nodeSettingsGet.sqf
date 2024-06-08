#include "script_component.hpp"
params ["_node"];
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
private _settings = createHashMap;
_names apply {
    _settings set [_x, _node getVariable [_x, nil]];
};
_settings
