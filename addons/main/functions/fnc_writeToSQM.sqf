#include "script_component.hpp"
private _allControllers = ((all3DENEntities)#3) select {_x isKindOf QGVAR(Module_TrenchController)};
private _terrainPoints = [];
private _hiddenObjects = [];
private _simpleObjects = [];
private _simulatedObjects = [];
private _trenchPieces = [];
private _fnc_serialise = {
    params ["_obj"];
    [getPosWorld _x, [vectorDir _x, vectorUp _x], typeOf _x]
};
_allControllers apply {
    private _controller = _x;
    _terrainPoints append (_x getVariable QGVAR(terrainPoints));
    _hiddenObjects append (_x getVariable QGVAR(hiddenObjects));
    _simpleObjects append (_x getVariable QGVAR(simpleObjects));
    _simulatedObjects append (_x getVariable QGVAR(simulatedObjects));
    _trenchPieces append (_x getVariable QGVAR(trenchPieces));
};
