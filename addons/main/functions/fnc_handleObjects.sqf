#include "script_component.hpp"
params ["_nodes"];
_nodes apply {
    private _node = _x;
    // Hide objects
    private _toHide = _node getVariable [QGVAR(toHideObjs), []];
    {
        _x hideObjectGlobal true;
    } forEach _toHide;

    // Place objects
    private _toPlace = _node getVariable [QGVAR(toPlace), []];
    private _trenchPieces = [];
    // Remove objects that are intersecting with the trench walkable area
    {
        _x params ["_posASL", "_vectorDirAndUp", ["_long", false]];
        private _class = ["Peer_Trench_Straight_Short_Chameleon", "Peer_Trench_Straight_Long_Chameleon"] select _long;
        private _trenchPiece = createSimpleObject [_class, _posASL];
        _trenchPiece setPosASL _posASL;
        // _posASL set [2, true];
        _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
        _trenchPiece setObjectMaterialGlobal [0, SEGMENT_MATERIAL];
        _trenchPiece hideSelection ["snow", true];
        _trenchPiece setVectorDirAndUp _vectorDirAndUp;
        _trenchPiece enableSimulationGlobal false;
        _trenchPieces pushBack _trenchPiece;
    } forEach _toPlace;
    _node setVariable [QGVAR(trenchPieces), _trenchPieces];
};
