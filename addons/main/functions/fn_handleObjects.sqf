params ["_origin", "_toPlace", "_interSectionAreas", "_segmentLength", "_hiddenObjects", "_extraComponents"];
// Hide objects
{
    _x hideObjectGlobal true;
} forEach _hiddenObjects;
_origin setVariable ["hiddenObjects", _hiddenObjects];

// Place objects
private _trenchPieces = _origin getVariable "trenchPieces"; // By reference
// Remove objets that are intersecting with the trench walkable area
private _notIntersecting = _toPlace select {
    private _objPos = (_x#0);
    _interSectionAreas findIf {_objPos inArea _x} isEqualTo -1
};
private _toPlaceFinal = [];
private _threshholdDist = _segmentLength/(1.5);
while {count _notIntersecting > 0} do {
    // Find nearby objects to this object
    private _objToPlace = (_notIntersecting#0);
    private _nearby = _notIntersecting select {
        (_objToPlace#0) distance (_x#0) < _threshholdDist
    };
    private _count = count _nearby;
    // Average their positions and directions
    _notIntersecting = _notIntersecting - _nearby;
    if (_count isEqualTo 1) then {
        _toPlaceFinal pushBack _objToPlace;
        continue;
    };
    private _pos = [0,0,0];
    _nearby apply {_pos = _pos vectorAdd _x#0};
    _pos = _pos vectorMultiply (1 / _count);

    private _vectorDirAndUp = _objToPlace#1;
    for "_i" from 1 to _count do {
        private _nextVectorDirAndUp = (_nearby#_i)#1;
        private _alpha = 1 / (_i + 1);
        _vectorDirAndUp = [
            [_vectorDirAndUp#0, _nextVectorDirAndUp#0, _alpha] call BIS_fnc_slerp,
            [_vectorDirAndUp#1, _nextVectorDirAndUp#1, _alpha] call BIS_fnc_slerp
        ]
    };
    _toPlaceFinal pushBack [_pos, _vectorDirAndUp]; 
};
{
    _x params ["_posASL", "_vectorDirAndUp"];
    private _trenchPiece = createSimpleObject ["Peer_Trench_Straight_Short_Chameleon", _posASL];
    _trenchPiece setPosASL _posASL;
    _posASL set [2, true];
    _trenchPiece setObjectTextureGlobal [0, (surfaceTexture _posASL)];
    _trenchPiece hideSelection ["snow", true];
    _trenchPiece setVectorDirAndUp _vectorDirAndUp;
    _trenchPiece enableSimulationGlobal false;
    _trenchPieces pushBack _trenchPiece;
} forEach _toPlaceFinal;
_trenchPieces
