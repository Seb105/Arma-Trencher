#include "script_component.hpp"
if (isServer) then {
    private _terrainPoints = getMissionConfigValue QGVAR(terrainPoints);
    // Don't use terrainLib, so that it cannot be accidentally restored.
    setTerrainHeight [_terrainPoints, true];

    private _simulatedObjects = getMissionConfigValue QGVAR(simulatedObjects);
    _simulatedObjects apply {
        _x params ["_posASL", "_vectorDirAndUp", "_type"];
        private _posAGL = ASLtoAGL _posASL;
        private _object = createVehicle [_type, _posAGL, [], 0, "CAN_COLLIDE"];
        _object setPosWorld _posASL; // stupid game
        _object setVectorDirAndUp _vectorDirAndUp;
        _object enableDynamicSimulation true;
    };
    private _hideAreas = getMissionConfigValue QGVAR(hideAreas);

    _hideAreas apply {
        private _area = _x;
        private _mid = _area#0;
        private _a = _area#1;
        private _b = _area#2;
        private _radius = sqrt (_a^2 + _b^2);
        private _objs = ((nearestTerrainObjects [_mid, [], _radius, false, true]) inAreaArray _area);
        _objs apply {
            _x hideObjectGlobal true;
        }
    }
};
private _fnc_createSimpleObject = {
    params ["_posASL", "_vectorDirAndUp", "_type"];
    private _obj = createSimpleObject [_type, _posASL, true];
    _obj setPosWorld _posASL; // imagine the commands actually working like they say they do lmao
    _obj setVectorDirAndUp _vectorDirAndUp;
    _obj enableSimulation false;
    _obj
};
private _simpleObjects = getMissionConfigValue QGVAR(simpleObjects);
_simpleObjects apply {
    _x call _fnc_createSimpleObject;
};
private _trenchPieces = getMissionConfigValue QGVAR(trenchPieces);

_trenchPieces apply {
    private _obj = _x call _fnc_createSimpleObject;
    _obj setObjectTexture [0, (surfaceTexture (getPos _obj))];
    _obj hideSelection ["snow", true];
};
