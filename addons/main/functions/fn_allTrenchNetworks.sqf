#include "script_component.hpp"
// Walks over all trench pieces and returns an array of arrays, where each sub array is 1 contiguous trench network.
private _allTrenchNetworks = [];
private _toVisit = (all3DENEntities#0) select {_x isKindOf "trencher_main_Module_TrenchPiece"};
while {count _toVisit > 0} do {
    private _origin = _toVisit#0;
    private _network = [_origin] call FUNC(connectedTrenchPieces);
    _allTrenchNetworks pushBack _network;
    _toVisit = _toVisit - _network;
};
_allTrenchNetworks
