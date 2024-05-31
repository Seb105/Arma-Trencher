#include "script_component.hpp"
params ["_controller", "_toPlace", "_toHide"];
// Hide objects
{
    _x hideObjectGlobal true;
} forEach _toHide;

// Place objects
private _trenchPieces = _controller getVariable QGVAR(trenchPieces); // By reference
// Remove objects that are intersecting with the trench walkable area
{
    _x params ["_posASL", "_vectorDirAndUp"];
    private _trenchPiece = createSimpleObject ["Peer_Trench_Straight_Short_Chameleon", _posASL];
    _trenchPiece setPosASL _posASL;
    // _posASL set [2, true];
    _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
    _trenchPiece setObjectMaterialGlobal [0, SEGMENT_MATERIAL];
    _trenchPiece hideSelection ["snow", true];
    _trenchPiece setVectorDirAndUp _vectorDirAndUp;
    _trenchPiece enableSimulationGlobal false;
    _trenchPieces pushBack _trenchPiece;
} forEach _toPlace;
_trenchPieces
