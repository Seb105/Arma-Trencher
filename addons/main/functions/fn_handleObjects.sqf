#include "script_component.hpp"
params ["_origin", "_toPlace", "_interSectionAreas", "_segmentLength", "_hiddenObjects"];
// Hide objects
{
    _x hideObjectGlobal true;
} forEach _hiddenObjects;
_origin setVariable ["hiddenObjects", _hiddenObjects];

// Place objects
private _trenchPieces = _origin getVariable "trenchPieces"; // By reference
{
    _x params ["_posASL", "_vectorDirAndUp"];
    if ((_interSectionAreas findIf {_posASL inArea _x}) isNotEqualTo -1) then {
        continue
    };
    if (_trenchPieces findIf {_posASL distance2D _x < _segmentLength/2} isNotEqualTo -1) then {
        continue
    };
    private _trenchPiece = createVehicle ["Peer_Trench_Straight_Short_Chameleon", ASLtoATL _posASL, [], 0, "CAN_COLLIDE"];
    _trenchPiece setPosASL _posASL;
    _posASL set [2, true];
    _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
    _trenchPiece setVectorDirAndUp _vectorDirAndUp;
    _trenchPieces pushBack _trenchPiece;        
} forEach _toPlace;
