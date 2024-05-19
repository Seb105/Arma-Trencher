params ["_origin", "_toPlace", "_interSectionAreas", "_segmentLength", "_hiddenObjects"];
// Hide objects
_hiddenObjects = _hiddenObjects arrayIntersect _hiddenObjects;
{
    _x hideObjectGlobal true;
} forEach _hiddenObjects;
_origin setVariable ["hiddenObjects", _hiddenObjects];

// Place objects
private _trenchPieces = _origin getVariable "trenchPieces"; // By reference
// Remove objects that are intersecting with the trench walkable area
private _notIntersecting = _toPlace select {
    private _objPos = (_x#0);
    _interSectionAreas findIf {_objPos inArea _x} isEqualTo -1
};
private _toPlaceFinal = _notIntersecting;
{
    _x params ["_posASL", "_vectorDirAndUp"];
    private _trenchPiece = createSimpleObject ["Peer_Trench_Straight_Short_Chameleon", _posASL];
    _trenchPiece setPosASL _posASL;
    // _posASL set [2, true];
    _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
    _trenchPiece hideSelection ["snow", true];
    _trenchPiece setVectorDirAndUp _vectorDirAndUp;
    _trenchPiece enableSimulationGlobal false;
    _trenchPieces pushBack _trenchPiece;
} forEach _toPlaceFinal;
_trenchPieces
