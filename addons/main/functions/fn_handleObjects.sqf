#include "script_component.hpp"
params ["_origin", "_toPlace", "_interSectionAreas", "_segmentLength", "_hiddenObjects", "_extraComponents"];
_extraComponents params ["_doConcrete", "_doSandbags", "_doBarbedWire"];
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
    // private _trenchPiece = createVehicle ["Peer_Trench_Straight_Short_Chameleon", ASLtoATL _posASL, [], 0, "CAN_COLLIDE"];
    private _trenchPiece = createSimpleObject ["Peer_Trench_Straight_Short_Chameleon", _posASL];
    _trenchPiece setPosASL _posASL;
    _posASL set [2, true];
    _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
    _trenchPiece hideSelection ["snow", true];
    _trenchPiece setVectorDirAndUp _vectorDirAndUp;
    _trenchPieces pushBack _trenchPiece;
    _trench enableSimulationGlobal false;
    if (_doConcrete) then {
        {
            _x params ["_relativePos", "_relativeDirAndUp"];
            private _posASL = _trenchPiece modelToWorldWorld _relativePos;
            private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
            private _concPiece = createSimpleObject ["Land_Bunker_01_blocks_3_F", _posASL];
            _concPiece setPosWorld _posASL;
            _concPiece setVectorDirAndUp _vectorDirAndUp;
            _concPiece enableSimulationGlobal false;
            _trenchPieces pushBack _concPiece;
        } forEach [
            [[1.58472,4.27881,0.666987],[[0,-1,0],[0,0,1]]],
            [[-1.77271,4.27197,0.666987],[[0,-1,0],[0,0,1]]]
        ];
    };
    if (_doBarbedWire) then {
        private _relativePos = [0,-0.23584,2.16478];
        private _relativeDirAndUp = [[0,1,0],[0,0,1]];
        private _posASL = _trenchPiece modelToWorldWorld _relativePos;
        private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
        // This object should be simulated so it can be destroyed
        private _barbedWire = createVehicle ["Land_Razorwire_F", _posASL];   
        _barbedWire setPosWorld _posASL;
        _barbedWire setVectorDirAndUp _vectorDirAndUp;
        _barbedWire enableDynamicSimulation true;
        _trenchPieces pushBack _barbedWire;
    };
    if (_doSandbags) then {
        {
            _x params ["_relativePos", "_relativeDirAndUp"];
            private _posASL = _trenchPiece modelToWorldWorld _relativePos;
            private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
            private _sandbag = createSimpleObject ["Land_BagFence_Long_F", _posASL];
            _sandbag setPosWorld _posASL;
            _sandbag setVectorDirAndUp _vectorDirAndUp;
            _sandbag enableSimulationGlobal false;
            _trenchPieces pushBack _sandbag;
        } forEach [
            [[2.56104,4.17676,2.23402],[[0,1,0],[0,0,1]]],
            [[-0.236084,4.17676,2.23402],[[0,-1,0],[0,0,1]]],
            [[-2.67896,4.17676,2.23402],[[0,1,0],[0,0,1]]]
        ]
    }
} forEach _toPlace;
